// deno-lint-ignore-file no-explicit-any
/**
 * Edge Function: points-ledger
 * Adds ledger entry (earn/spend) with optional idempotency
 * Expects JSON: { userId, delta, type, source, description, idemKey?, ttlSeconds? }
 * Auth: TODO role check (admin or owner)
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
    const { userId, delta, type, source, description, idemKey, ttlSeconds = 86400 } =
      await req.json();
    if (!userId || !delta || !type) return new Response("Invalid payload", { status: 400 });

    // Idempotency check
    if (idemKey) {
      const { data: idem, error: idemErr } = await supabase
        .from("idempotency_keys")
        .select("*")
        .eq("key", idemKey)
        .single();
      if (!idemErr && idem) {
        return new Response(JSON.stringify({ cached: true, result: idem.result }), {
          status: 200,
          headers: { "Content-Type": "application/json" },
        });
      }
    }

    const { error } = await supabase.from("point_ledgers").insert({
      user_id: userId,
      delta,
      type,
      source,
      description,
    });
    if (error) throw error;

    if (idemKey) {
      const expiresAt = new Date(Date.now() + ttlSeconds * 1000).toISOString();
      await supabase.from("idempotency_keys").insert({
        key: idemKey,
        uid: userId,
        operation: "points",
        status: "completed",
        result: { userId, delta, type },
        expires_at: expiresAt,
      });
    }

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("points-ledger error", e);
    return new Response("Error", { status: 500 });
  }
});
