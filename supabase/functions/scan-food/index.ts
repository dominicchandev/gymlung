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

// Production edge function: glm-4.6v primary → qwen3-vl-flash fallback

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 1. Validate auth
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing authorization header" }),
        {
          status: 401,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // 2. Parse request body (no provider param — auto-routes)
    const { image_base64, tone_mode, region } = await req.json();

    if (!image_base64) {
      return new Response(
        JSON.stringify({ error: "Missing image_base64" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // 3. Resolve tone and region
    const { resolvedRegion, tonePrompt } = resolveToneAndRegion(
      tone_mode,
      region
    );

    // 4. Build prompt
    const primaryCfg = providers.zai46v;
    const schemaAppend = primaryCfg.supportsJsonSchema
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
      "zai46v"
    );
    const requestBody = buildRequestBody(
      primaryCfg,
      "zai46v",
      messages,
      resolvedRegion
    );

    // 5. Try primary provider (glm-4.6v) with 15s timeout
    const primaryKey = Deno.env.get(primaryCfg.keyEnv);
    if (!primaryKey) {
      return new Response(
        JSON.stringify({ error: "Primary provider API key not configured" }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    let foodResult;
    let usedProvider = "zai46v";

    try {
      foodResult = await callProvider(
        primaryCfg,
        "zai46v",
        primaryKey,
        requestBody,
        15000
      );
    } catch (primaryError) {
      console.error("Primary provider (zai46v) failed:", primaryError);

      // 6. Fallback to qwen3-vl-flash
      usedProvider = "qwen";
      const fallbackCfg = providers.qwen;
      const fallbackKey = Deno.env.get(fallbackCfg.keyEnv);

      if (!fallbackKey) {
        return new Response(
          JSON.stringify({
            error: "Both primary and fallback providers failed",
            primary_error: String(primaryError),
          }),
          {
            status: 502,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      // Rebuild for fallback provider
      const fbSchemaAppend = fallbackCfg.supportsJsonSchema
        ? ""
        : jsonSchemaInstruction;
      const fbSystemPrompt = buildSystemPrompt(
        resolvedRegion,
        tonePrompt,
        fbSchemaAppend
      );
      const fbMessages = buildMessages(
        fbSystemPrompt,
        image_base64,
        resolvedRegion,
        "qwen"
      );
      const fbRequestBody = buildRequestBody(
        fallbackCfg,
        "qwen",
        fbMessages,
        resolvedRegion
      );

      try {
        foodResult = await callProvider(
          fallbackCfg,
          "qwen",
          fallbackKey,
          fbRequestBody
        );
      } catch (fallbackError) {
        console.error("Fallback provider (qwen) failed:", fallbackError);
        return new Response(
          JSON.stringify({
            error: "Both primary and fallback providers failed",
            primary_error: String(primaryError),
            fallback_error: String(fallbackError),
          }),
          {
            status: 502,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }
    }

    // 7. Return result with provider info
    return new Response(
      JSON.stringify({ ...foodResult, _provider: usedProvider }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("scan-food error:", error);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});
