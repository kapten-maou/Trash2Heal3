// deno-lint-ignore-file no-explicit-any
/**
 * Edge Function: redeem-disbursement
 * Handles redeem requests status changes (pending -> processing -> completed/failed)
 * Expects JSON: { requestId, action: "process" | "complete" | "fail", failureReason? }
 * Auth: replace placeholder with proper admin role check (currently bearer token required)
 * Secrets: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
 */
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.48.0";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }
  try {
    const { requestId, action, failureReason } = await req.json();
    if (!requestId || !action) {
      return new Response("Invalid payload", { status: 400 });
    }

    // TODO: proper role check using JWT claims
    const authHeader = req.headers.get("authorization");
    if (!authHeader?.includes("Bearer")) {
      return new Response("Unauthorized", { status: 401 });
    }

    const { data: redeem, error } = await supabase
      .from("redeem_requests")
      .select("*")
      .eq("id", requestId)
      .single();
    if (error || !redeem) throw error ?? new Error("Not found");

    const now = new Date().toISOString();
    const updates: Record<string, any> = { updated_at: now };

    if (action === "process") {
      updates.status = "processing";
      updates.processed_at = now;
    } else if (action === "complete") {
      updates.status = "completed";
      updates.completed_at = now;
    } else if (action === "fail") {
      updates.status = "failed";
      updates.failed_at = now;
      updates.failure_reason = failureReason ?? "Unknown";
    } else {
      return new Response("Invalid action", { status: 400 });
    }

    const { error: updErr } = await supabase
      .from("redeem_requests")
      .update(updates)
      .eq("id", requestId);
    if (updErr) throw updErr;

    return new Response(JSON.stringify({ success: true, status: updates.status }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("redeem-disbursement error", e);
    return new Response("Error", { status: 500 });
  }
});
