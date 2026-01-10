// deno-lint-ignore-file no-explicit-any
/**
 * Edge Function: midtrans-webhook
 * Verifies Midtrans signature and updates payments table.
 * Expects POST: { order_id, status_code, gross_amount, signature_key, transaction_status, transaction_id }
 * Secrets: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, MIDTRANS_SERVER_KEY
 */
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.48.0";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const midtransKey = Deno.env.get("MIDTRANS_SERVER_KEY")!;
const supabase = createClient(supabaseUrl, serviceRoleKey);

function mapStatus(status: string): string {
  const s = status.toLowerCase();
  if (["capture", "settlement", "success"].includes(s)) return "paid";
  if (s === "pending") return "pending";
  if (["expire", "expired"].includes(s)) return "expired";
  if (["cancel", "deny", "failure", "failed"].includes(s)) return "failed";
  return s;
}

async function sha512Hex(value: string): Promise<string> {
  const data = new TextEncoder().encode(value);
  const hash = await crypto.subtle.digest("SHA-512", data);
  return Array.from(new Uint8Array(hash))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }
  try {
    const body = (await req.json()) as Record<string, any>;
    const orderId = body.order_id as string;
    const statusCode = body.status_code as string;
    const grossAmount = body.gross_amount as string;
    const signatureKey = body.signature_key as string;
    const transactionStatus = body.transaction_status as string;
    const transactionId = body.transaction_id as string | undefined;

    if (!orderId || !statusCode || !grossAmount || !signatureKey) {
      return new Response("Invalid payload", { status: 400 });
    }

    const expected = await sha512Hex(
      `${orderId}${statusCode}${grossAmount}${midtransKey}`,
    );
    if (expected !== signatureKey) {
      return new Response("Invalid signature", { status: 401 });
    }

    const paymentId = orderId.replace("T2H-", "");
    const mappedStatus = mapStatus(transactionStatus);

    const updates: Record<string, any> = {
      status: mappedStatus,
      transaction_id: transactionId ?? null,
      updated_at: new Date().toISOString(),
    };
    if (mappedStatus === "paid") {
      updates.paid_at = new Date().toISOString();
      updates.is_verified = true;
    } else if (mappedStatus === "failed" || mappedStatus === "expired") {
      updates.is_verified = false;
    }

    const { error } = await supabase
      .from("payments")
      .update(updates)
      .eq("id", paymentId);
    if (error) throw error;

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("midtrans-webhook error", e);
    return new Response("Error", { status: 500 });
  }
});
