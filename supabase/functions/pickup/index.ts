// deno-lint-ignore-file no-explicit-any
/**
 * Edge Function: pickup
 * Update pickup_requests status and optionally assign courier
 * Expects JSON: { requestId, status, courierId? }
 * Auth: TODO role check (courier/admin)
 */
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.48.0";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

serve(async (req) => {
  if (req.method !== "POST") return new Response("Method not allowed", { status: 405 });
  try {
    const { requestId, status, courierId } = await req.json();
    if (!requestId || !status) return new Response("Invalid payload", { status: 400 });

    // TODO: role check for courier/admin using JWT claims

    const updates: Record<string, any> = { status, updated_at: new Date().toISOString() };
    if (courierId) updates.courier_id = courierId;

    const { error } = await supabase
      .from("pickup_requests")
      .update(updates)
      .eq("id", requestId);
    if (error) throw error;

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("pickup error", e);
    return new Response("Error", { status: 500 });
  }
});
