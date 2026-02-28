// Shared types and helpers for scan-food edge functions

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// Tone-specific roast instructions
export const toneInstructions: Record<string, string> = {
  normal: `roast_comment 規則（串嘴模式）：
⚠️ 只寫一句，最多20個字，針對佢食緊嘅嘢嚟串
- 用口語廣東話，唔好書面語，唔好爆粗，唔好用emoji
- 要刻薄、抵死、一針見血，好似損友咁串你
- 針對食物本身嚟串，唔好講廢話
- 好嘅例子：
  "乾炒牛河？你條血管同啲河粉一樣油"
  "珍珠奶茶當水飲 難怪你咁肥"
  "食西多士？你塊面都夠油煎多兩塊"
  "又叫外賣 你對腳係咪已經退化咗"
  "嘩燒鵝飯 你個胃口大過你個人"
  "菠蘿油加牛油 你心臟應該想同你離婚"
  "食完呢餐你今日卡路里已經爆咗"
  "公仔麵加午餐肉 你係咪想即食埋你條命"
  "凍檸茶少甜？少咗嗰啲甜你食返晒啦"
  "你食嘢嘅速度同你增磅嘅速度一樣快"
- 如果食物健康："吓？你今日食錯藥？竟然食菜？"`,

  adult: `roast_comment 規則（18+模式）：
⚠️ 只寫一句，最多25個字，針對佢食緊嘅嘢嚟屌
- 用口語廣東話，一定要爆粗，越狠越好
- 粗口要自然融入句子，唔好為爆而爆
- 針對食物本身嚟屌，要有畫面感
- 好嘅例子：
  "屌你老母又食炸嘢 你個心臟早晚罷撚工"
  "仆街珍珠奶茶 你不如直接將糖塞入條撚血管啦"
  "嘩屌 碟乾炒牛河油到反光 你食撚完等住通波仔"
  "西多士加煉奶？癡撚線 你當你個胰臟係鐵打？"
  "又食燒味飯 你條腰圍同個飯桶一樣撚粗"
  "公仔麵加午餐肉 你條命平過呢包麵"
  "菠蘿油？食撚完你塊面同個包一樣油"
  "食完呢餐 你部磅秤應該想屌你"
  "凍奶茶走甜？走咗都冇撚用你食咗幾多嘢"
  "你食嘢嘅樣 同倒垃圾入口冇分別"
- 如果食物健康："屌？你今日係咪撞親個頭先食菜？"`,

  gentle: `roast_comment 規則（仁慈模式）：
⚠️ 只寫一句，最多20個字，溫柔鼓勵
- 用口語廣東話，語氣暖，唔好用emoji
- 好嘅例子：
  "食啦食啦 開心就好"
  "一餐半餐冇所謂嘅"
  "你已經好叻啦 慢慢嚟"
  "今日辛苦咗 食嘢獎勵下自己"
  "呢個都幾好食嘅 唔使有罪惡感"
- 如果食物健康："嘩好叻呀 食得咁健康"`,

  twGanHua: `roast_comment 規則（幹話王模式 - 台灣）：
⚠️ 只寫一句，最多25個字，只講無用的事實
- 用台灣口語，technically correct但沒有幫助，不要給建議，不要用emoji
- 好的例子：
  "你剛攝取的熱量等於跑步40分鐘，一個你不會做的運動"
  "這個便當含有食物，而食物含有熱量，以上"
  "珍奶含糖量等於十顆方糖，這是數學不是建議"
  "根據紀錄你上次吃這麼健康是...查無資料"
  "這個雞排的油脂含量，跟你的自制力成反比"`,

  twAma: `roast_comment 規則（阿嬤碎念模式 - 台灣）：
⚠️ 只寫一句，最多25個字，阿嬤口氣碎念
- 用台灣阿嬤語氣，嘮叨但有愛，不要用emoji
- 好的例子：
  "唉唷又吃這個，阿嬤煮的比較健康啦"
  "外面的東西都馬很油，阿嬤跟你說"
  "吃這麼少怎麼會飽啦"
  "年輕人就是愛亂吃"
- 如果食物健康："有在吃菜喔，乖，阿嬤很欣慰"`,

  twYanShi: `roast_comment 規則（厭世仙人掌模式 - 台灣）：
⚠️ 只寫一句，最多25個字，厭世但有道理
- 用台灣年輕人厭世語氣，很喪很累，不要用emoji
- 好的例子：
  "吃吧，反正人生也沒什麼好期待的"
  "這熱量...算了，你開心就好"
  "吃完這餐就是明天的你的問題了"
  "你的錢包跟你的腰圍一樣控制不住"
- 如果食物健康："你是不是失戀了才吃這麼健康"`,
};

// Provider configs
export interface ProviderConfig {
  endpoint: string;
  model: string;
  keyEnv: string;
  supportsJsonSchema: boolean;
}

export const providers: Record<string, ProviderConfig> = {
  openai: {
    endpoint: "https://api.openai.com/v1/chat/completions",
    model: "gpt-4o",
    keyEnv: "OPENAI_API_KEY",
    supportsJsonSchema: true,
  },
  zai: {
    endpoint: "https://open.bigmodel.cn/api/paas/v4/chat/completions",
    model: "glm-4.6v-flash",
    keyEnv: "ZAI_API_KEY",
    supportsJsonSchema: false,
  },
  zaiFlashX: {
    endpoint: "https://open.bigmodel.cn/api/paas/v4/chat/completions",
    model: "glm-4.6v-flashx",
    keyEnv: "ZAI_API_KEY",
    supportsJsonSchema: false,
  },
  zai46v: {
    endpoint: "https://open.bigmodel.cn/api/paas/v4/chat/completions",
    model: "glm-4.6v",
    keyEnv: "ZAI_API_KEY",
    supportsJsonSchema: false,
  },
  qwen: {
    endpoint: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions",
    model: "qwen3-vl-flash",
    keyEnv: "QWEN_API_KEY",
    supportsJsonSchema: false,
  },
  qwenPlus: {
    endpoint: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions",
    model: "qwen-vl-plus",
    keyEnv: "QWEN_API_KEY",
    supportsJsonSchema: false,
  },
};

// Build region-aware system prompt
export function buildSystemPrompt(
  resolvedRegion: string,
  tonePrompt: string,
  schemaAppend: string
): string {
  if (resolvedRegion === "tw") {
    return `你是一個台灣食物辨認專家。你要做兩件事：

1. 準確辨認照片裡的食物，估計卡路里和營養素
2. roast_comment：只寫一句短評，針對食物本身來講。不要解釋、不要囉嗦、不要寫超過一句。

常見台灣食物：
- 夜市: 鹹酥雞, 雞排, 蚵仔煎, 臭豆腐, 大腸包小腸, 地瓜球, 蔥油餅, 肉圓, 芋圓
- 便當店: 排骨便當, 雞腿便當, 滷肉飯, 控肉飯, 魚排便當
- 早餐店: 蛋餅, 燒餅油條, 大冰奶, 蘿蔔糕, 鐵板麵, 總匯三明治
- 手搖飲: 珍珠奶茶, 四季春, 冬瓜茶, 青茶, 多多綠
- 小吃: 牛肉麵, 小籠包, 水煎包, 魯味, 滷味, 豆漿, 水餃
- 快餐: 麥當勞, 肯德基, 摩斯漢堡, 八方雲集

${tonePrompt}

份量估計用視覺線索（盤子大小、餐具、手的比例）。
台灣食物偏油偏甜，卡路里不要估太低。
如果認不出來，confidence設為0，name寫"未知食物"。${schemaAppend}`;
  }

  return `你係一個香港食物辨認專家。你要做兩件事：

1. 準確辨認相片入面嘅食物，估計卡路里同營養素
2. roast_comment：只寫一句短評，針對食物本身嚟講。唔好解釋、唔好囉嗦、唔好寫多過一句。

常見香港食物：
- 茶餐廳: 常餐, 公仔麵, 菠蘿油, 凍檸茶, 奶茶, 西多士, 乾炒牛河, 星洲炒米
- 點心: 蝦餃, 燒賣, 叉燒包, 腸粉, 鳳爪, 流沙包, 蛋撻
- 街頭小食: 魚蛋, 燒賣, 雞蛋仔, 格仔餅, 碗仔翅, 車仔麵, 煎釀三寶
- 燒味: 叉燒, 燒鵝, 燒鴨, 油雞, 燒肉
- 飲品: 珍珠奶茶, 凍檸茶, 維他檸檬茶, 益力多
- 快餐: 麥當勞, KFC, 譚仔, 大家樂, 美心

${tonePrompt}

份量估計用視覺線索（碟嘅大小、餐具、手做比例）。
HK食物普遍多油，卡路里唔好估低。
如果認唔到，confidence設做0，name寫"未知食物"。${schemaAppend}`;
}

// Build messages array for the API call
export function buildMessages(
  systemPrompt: string,
  imageBase64: string,
  resolvedRegion: string,
  providerKey: string
) {
  const userText =
    resolvedRegion === "tw"
      ? `辨認這張照片裡所有食物。回傳 structured JSON。`
      : `辨認呢張相入面所有食物。返返structured JSON。`;

  // Only OpenAI supports `detail` param
  // deno-lint-ignore no-explicit-any
  const imageUrlObj: any = { url: `data:image/jpeg;base64,${imageBase64}` };
  if (providerKey === "openai") {
    imageUrlObj.detail = "low";
  }

  return [
    { role: "system", content: systemPrompt },
    {
      role: "user",
      content: [
        { type: "text", text: userText },
        { type: "image_url", image_url: imageUrlObj },
      ],
    },
  ];
}

// Build request body for the API call
export function buildRequestBody(
  providerCfg: ProviderConfig,
  providerKey: string,
  // deno-lint-ignore no-explicit-any
  messages: any[],
  resolvedRegion: string
) {
  const nameZhDesc =
    resolvedRegion === "tw"
      ? "食物中文名（台灣用語）"
      : "食物中文名（廣東話）";
  const roastDesc =
    resolvedRegion === "tw"
      ? "只寫一句短評（最多25字），針對食物，用台灣中文，不要囉嗦"
      : "只寫一句短評（最多20字），針對食物，用廣東話口語，唔好囉嗦";

  // deno-lint-ignore no-explicit-any
  const requestBody: any = {
    model: providerCfg.model,
    messages,
    max_tokens: 1000,
  };

  if (providerCfg.supportsJsonSchema) {
    requestBody.response_format = {
      type: "json_schema",
      json_schema: {
        name: "food_scan_result",
        strict: true,
        schema: {
          type: "object",
          properties: {
            food_items: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  name_zh: { type: "string", description: nameZhDesc },
                  name_en: {
                    type: "string",
                    description: "Food name in English",
                  },
                  estimated_calories: {
                    type: "number",
                    description: "估計卡路里 (kcal)",
                  },
                  protein_g: { type: "number", description: "蛋白質 (g)" },
                  carbs_g: { type: "number", description: "碳水化合物 (g)" },
                  fat_g: { type: "number", description: "脂肪 (g)" },
                  portion_description: {
                    type: "string",
                    description: "份量描述（例如：一碟, 一杯, 一件）",
                  },
                  confidence: { type: "number", description: "信心分數 0-1" },
                },
                required: [
                  "name_zh",
                  "name_en",
                  "estimated_calories",
                  "protein_g",
                  "carbs_g",
                  "fat_g",
                  "portion_description",
                  "confidence",
                ],
                additionalProperties: false,
              },
            },
            total_calories: {
              type: "number",
              description: "所有食物的總卡路里",
            },
            roast_comment: { type: "string", description: roastDesc },
          },
          required: ["food_items", "total_calories", "roast_comment"],
          additionalProperties: false,
        },
      },
    };
  } else {
    requestBody.response_format = { type: "json_object" };
  }

  return requestBody;
}

// JSON schema instruction for non-schema providers
export const jsonSchemaInstruction = `

你必須回傳以下 JSON 格式（唔好加任何其他內容）：
{
  "food_items": [
    {
      "name_zh": "食物中文名",
      "name_en": "Food name in English",
      "estimated_calories": 123,
      "protein_g": 10,
      "carbs_g": 20,
      "fat_g": 5,
      "portion_description": "一碟",
      "confidence": 0.9
    }
  ],
  "total_calories": 123,
  "roast_comment": "一句短評"
}`;

// Call a provider and return parsed JSON result
export async function callProvider(
  providerCfg: ProviderConfig,
  providerKey: string,
  apiKey: string,
  // deno-lint-ignore no-explicit-any
  requestBody: any,
  timeoutMs?: number
  // deno-lint-ignore no-explicit-any
): Promise<any> {
  const fetchOptions: RequestInit = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify(requestBody),
  };

  if (timeoutMs) {
    const controller = new AbortController();
    setTimeout(() => controller.abort(), timeoutMs);
    fetchOptions.signal = controller.signal;
  }

  const aiResponse = await fetch(providerCfg.endpoint, fetchOptions);

  if (!aiResponse.ok) {
    const errorBody = await aiResponse.text();
    throw new Error(
      `${providerKey} API error ${aiResponse.status}: ${errorBody}`
    );
  }

  const aiData = await aiResponse.json();
  const resultContent = aiData.choices?.[0]?.message?.content;

  if (!resultContent) {
    throw new Error(`Empty response from ${providerKey}`);
  }

  return JSON.parse(resultContent);
}

// Resolve tone and region from request params
export function resolveToneAndRegion(
  toneMode: string | undefined,
  region: string | undefined
): { resolvedRegion: string; tone: string; tonePrompt: string } {
  const resolvedRegion = region === "tw" ? "tw" : "hk";
  const defaultTone = resolvedRegion === "tw" ? "twGanHua" : "normal";
  const tone =
    toneMode && toneMode in toneInstructions ? toneMode : defaultTone;
  const tonePrompt = toneInstructions[tone];
  return { resolvedRegion, tone, tonePrompt };
}
