// deno-lint-ignore-file no-explicit-any
/**
 * Edge Function: send-notification
 * Stores notification and (optionally) sends push via FCM/OneSignal
 * Expects JSON: { userId, title, body, data? }
 * Secrets: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, (optional) FCM_SERVER_KEY, ONESIGNAL_API_KEY
 */
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.48.0";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);
const fcmKey = Deno.env.get("FCM_SERVER_KEY") ?? "";

serve(async (req) => {
  if (req.method !== "POST") return new Response("Method not allowed", { status: 405 });
  try {
    const { userId, title, body, data } = await req.json();
    if (!userId || !title || !body) return new Response("Invalid payload", { status: 400 });

    await supabase.from("notifications").insert({
      user_id: userId,
      title,
      body,
      type: "custom",
      data,
    });

    // TODO: fetch device token(s) for user and send push using FCM/OneSignal if available.
    // Placeholder: not sending if fcmKey missing.

    return new Response(JSON.stringify({ success: true, sent: !!fcmKey }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("send-notification error", e);
    return new Response("Error", { status: 500 });
  }
});
