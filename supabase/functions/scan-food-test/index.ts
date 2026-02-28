import "jsr:@supabase/functions-js/edge-runtime.d.ts";

import {
  corsHeaders,
  providers,
  jsonSchemaInstruction,
  buildSystemPrompt,
  buildMessages,
  buildRequestBody,
  callProvider,
  resolveToneAndRegion,
} from "../_shared/scan-food-shared.ts";

// Testing edge function: all providers, requires service_role key

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 1. Validate service_role key
    const authHeader = req.headers.get("Authorization");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!authHeader || !serviceRoleKey) {
      return new Response(
        JSON.stringify({ error: "Missing authorization" }),
        {
          status: 401,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const token = authHeader.replace("Bearer ", "");
    if (token !== serviceRoleKey) {
      return new Response(
        JSON.stringify({ error: "Invalid service_role key" }),
        {
          status: 403,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // 2. Parse request body
    const {
      image_base64,
      tone_mode,
      region,
      provider: reqProvider,
    } = await req.json();

    if (!image_base64) {
      return new Response(
        JSON.stringify({ error: "Missing image_base64" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // 3. Resolve provider
    const providerKey =
      reqProvider && reqProvider in providers ? reqProvider : "openai";
    const providerCfg = providers[providerKey];

    const apiKey = Deno.env.get(providerCfg.keyEnv);
    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: `${providerKey} API key not configured` }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // 4. Resolve tone and region
    const { resolvedRegion, tonePrompt } = resolveToneAndRegion(
      tone_mode,
      region
    );

    // 5. Build prompt
    const schemaAppend = providerCfg.supportsJsonSchema
      ? ""
      : jsonSchemaInstruction;
    const systemPrompt = buildSystemPrompt(
      resolvedRegion,
      tonePrompt,
      schemaAppend
    );
    const messages = buildMessages(
      systemPrompt,
      image_base64,
      resolvedRegion,
      providerKey
    );
    const requestBody = buildRequestBody(
      providerCfg,
      providerKey,
      messages,
      resolvedRegion
    );

    // 6. Call the AI provider
    const foodResult = await callProvider(
      providerCfg,
      providerKey,
      apiKey,
      requestBody
    );

    return new Response(JSON.stringify(foodResult), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("scan-food-test error:", error);
    return new Response(
      JSON.stringify({
        error: "Scan failed",
        detail: String(error),
      }),
      {
        status: 502,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});
