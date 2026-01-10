// deno-lint-ignore-file no-explicit-any
/**
 * Edge Function: create-payment (Midtrans charge)
 * Expects JSON: { tier, amount, method, bank, userEmail, userName }
 * Requires Authorization: Bearer <supabase JWT>
 * Secrets: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, MIDTRANS_SERVER_KEY, MIDTRANS_BASE_URL (optional)
 */
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.48.0";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const midtransKey = Deno.env.get("MIDTRANS_SERVER_KEY")!;
const midtransBase =
  Deno.env.get("MIDTRANS_BASE_URL") ?? "https://api.sandbox.midtrans.com/v2";

const supabase = createClient(supabaseUrl, serviceRoleKey);

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  try {
    // Auth: verify bearer token
    const authHeader = req.headers.get("authorization");
    const token = authHeader?.replace("Bearer ", "");
    if (!token) return new Response("Unauthorized", { status: 401 });
    const {
      data: { user },
      error: userErr,
    } = await supabase.auth.getUser(token);
    if (userErr || !user) return new Response("Unauthorized", { status: 401 });

    const body = await req.json();
    const { tier, amount, method, bank, userEmail, userName } = body as Record<
      string,
      any
    >;

    if (!tier || !amount || amount <= 0 || !method) {
      return new Response("Invalid payload", { status: 400 });
    }

    // Insert pending payment
    const {
      data: paymentRow,
      error: insertErr,
    } = await supabase
      .from("payments")
      .insert({
        user_id: user.id,
        provider: "midtrans",
        method,
        amount,
        status: "pending",
      })
      .select()
      .single();
    if (insertErr || !paymentRow) throw insertErr;

    const paymentId = paymentRow.id as string;
    const orderId = `T2H-${paymentId}`;

    // Build Midtrans charge payload
    const paymentType =
      method === "qris"
        ? "qris"
        : method === "bank_transfer" || method === "virtual_account"
        ? "bank_transfer"
        : method === "ewallet"
        ? "gopay"
        : "credit_card";

    const payload: Record<string, any> = {
      payment_type: paymentType,
      transaction_details: { order_id: orderId, gross_amount: amount },
      customer_details: {
        email: userEmail ?? user.email,
        first_name: userName ?? user.user_metadata?.full_name,
      },
      item_details: [
        { id: tier, price: amount, quantity: 1, name: `${tier} membership` },
      ],
    };

    if (paymentType === "bank_transfer") {
      payload.bank_transfer = { bank: bank ?? "bca" };
    } else if (paymentType === "qris") {
      payload.qris = {};
    } else if (paymentType === "gopay") {
      payload.gopay = { enable_callback: false };
    }

    // Call Midtrans charge
    const res = await fetch(`${midtransBase}/charge`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        Authorization: "Basic " + btoa(`${midtransKey}:`),
      },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      const text = await res.text();
      console.error("Midtrans charge failed", res.status, text);
      throw new Error("Midtrans charge failed");
    }
    const charge = (await res.json()) as Record<string, any>;

    const vaNumber =
      charge.va_numbers?.[0]?.va_number ??
      charge.permata_va_number ??
      charge.bill_key ??
      null;
    const bankName = charge.va_numbers?.[0]?.bank ?? bank ?? null;
    const qrUrl =
      charge.qr_url ??
      charge.actions?.find((a: any) => a.name === "generate-qr-code")?.url ??
      null;
    const redirectUrl =
      charge.redirect_url ??
      charge.actions?.find((a: any) => a.name === "deeplink-redirect")?.url ??
      null;

    // Update payment with orderId + metadata
    const { error: updateErr } = await supabase
      .from("payments")
      .update({
        order_id: orderId,
        metadata: { vaNumber, bank: bankName, qrUrl, redirectUrl, tier },
      })
      .eq("id", paymentId);
    if (updateErr) throw updateErr;

    return new Response(
      JSON.stringify({
        paymentId,
        orderId,
        vaNumber,
        bank: bankName,
        qrUrl,
        redirectUrl,
        status: "pending",
      }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  } catch (e) {
    console.error("create-payment error", e);
    return new Response("Internal error", { status: 500 });
  }
});
