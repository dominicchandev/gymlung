# CaLoMei Design System
## UI/UX Specification for Hong Kong People

---

## Design Philosophy: 「深夜茶餐廳」(Late-Night Cha Chaan Teng)

The entire app experience is framed as a **late-night cha chaan teng (茶餐廳)**. This is the single most uniquely Hong Kong metaphor possible:

- **The staff are rude** — 茶餐廳 staff are legendarily blunt, impatient, and sharp-tongued. This IS the app's personality. The app is the 阿姐 behind the counter who judges your order.
- **The lighting is dim** — dark theme with warm neon accents, like walking past a 茶餐廳 at midnight
- **The neon sign outside** — our accent colors are inspired by classic HK neon signage (warm amber/green glow)
- **The menu board** — information-dense but scannable, like a 茶餐廳 wall menu
- **It's where you go to eat trash** — and get judged for it

This metaphor gives us: a distinct HK identity, a personality-driven design language, and a visual system that no Western health app would ever use.

---

## 1. Color System

### Core Philosophy
Hong Kong's visual identity lives in the contrast between deep urban darkness and electric neon glow. Our palette reflects a **midnight Mong Kok** vibe — dark streets punctuated by buzzing neon signs.

### Background Layers (Dark → Light)

| Token | Hex | Usage |
|-------|-----|-------|
| `bg.primary` | `#111111` | Main app background — deeper black, like a dim 茶餐廳 interior |
| `bg.card` | `#1A1A1A` | Card surfaces, elevated content |
| `bg.elevated` | `#222222` | Input fields, tertiary surfaces |
| `bg.divider` | `#2A2A2A` | Subtle separators, borders |

> **Change from current:** Background shifts from `#151515` → `#111111` (slightly deeper for more contrast with neon accents). Card background from `#1E1E1E` → `#1A1A1A` (warmer undertone).

### Accent Colors — The Neon Signs

| Token | Hex | Name | Usage |
|-------|-----|------|-------|
| `neon.green` | `#5BFF62` | 霓虹綠 | Primary accent — progress rings, positive states, health metrics. Brighter than Material green, feels like an actual neon tube. |
| `neon.amber` | `#FFB547` | 霓虹金 | Secondary accent — roast overlays, warnings, calorie numbers. The color of a glowing 茶餐廳 sign. |
| `neon.red` | `#FF4757` | 霓虹紅 | Danger — over-limit calories, destructive actions. Like a 紅色警告. |
| `neon.blue` | `#54A0FF` | 霓虹藍 | Info — fat macro, secondary data. Cool contrast to warm accents. |

> **Why change the green?** Current `#4CAF50` is Google's Material Design green — literally the most generic "health app" green possible. `#5BFF62` is electric, neon, and unmistakably different. It glows against the dark background.

### Neon Glow Effect
Key UI elements should have a subtle glow effect to simulate neon lighting:
```
// Neon glow shadow (use sparingly — only on key interactive elements)
.shadow(color: Color(hex: "#5BFF62").opacity(0.3), radius: 8, x: 0, y: 0)
```
Apply glow to: calorie ring, primary action buttons, tab bar active indicator. Do NOT apply to every element — restraint is key.

### Text Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `text.primary` | `#FFFFFF` | Headings, primary content |
| `text.secondary` | `#A0A0A0` | Subtitles, labels (warmer than current #999999) |
| `text.tertiary` | `#606060` | Hints, placeholders, disabled text |
| `text.muted` | `#404040` | Inactive borders, very subtle elements |

### Macro Colors (Unchanged, they work well)

| Macro | Hex | Token |
|-------|-----|-------|
| Protein | `#FF6B6B` | `macro.protein` |
| Carbs | `#FFB74D` | `macro.carbs` |
| Fat | `#64B5F6` | `macro.fat` |

### State Colors

| State | Hex | Usage |
|-------|-----|-------|
| Selected option bg | `#1A2E1A` | Dark green tint for selected survey options |
| Hover/press | white @ 5% opacity | Tap highlight on list items |
| Focused input border | `neon.green` @ 80% | Active text field border |

---

## 2. Typography

### Font Stack

**Primary:** System font (San Francisco for Latin / PingFang HK for Chinese)

PingFang HK is Apple's purpose-built font for Hong Kong Traditional Chinese. It includes Cantonese-specific characters (e.g., 嘅, 咗, 啲, 嘢, 㗎) that other Chinese fonts often miss. There is zero reason to use a custom font — PingFang HK is already the best option for our audience.

**Numbers:** Use `.monospacedDigit()` modifier on all calorie/macro number displays. This prevents layout jitter when numbers animate or change, and gives a "dashboard instrument" feel.

### Type Scale

| Level | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| Display | 36pt | `.bold` | 1.1 | Calorie ring center number |
| H1 | 24pt | `.bold` | 1.3 | Page headers, user's name |
| H2 | 18pt | `.semibold` | 1.3 | Section titles, card headers |
| H3 | 16pt | `.semibold` | 1.4 | Sub-section titles |
| Body | 15pt | `.regular` | 1.5 | Main content text |
| Body Strong | 15pt | `.medium` | 1.5 | Food names, emphasized content |
| Caption | 13pt | `.regular` | 1.4 | Macro details, secondary info |
| Micro | 11pt | `.regular` | 1.3 | Timestamps, tertiary details |
| Button | 17pt | `.bold` | 1.0 | Action buttons |
| Tab | 10pt | `.medium` | 1.0 | Tab bar labels |

### Chinese Typography Rules

1. **Line height for Chinese text must be ≥ 1.4x** — Chinese characters are taller and denser than Latin. 1.5x is ideal for body text.
2. **Never letter-space Chinese** — unlike Latin type, Chinese characters are self-spacing. Adding tracking makes it look wrong.
3. **Use Traditional Chinese (繁體)** — Simplified Chinese will alienate HK users immediately. This includes punctuation: use 「」not ""（）not ().
4. **Mix Chinese + English naturally** — HK people code-switch constantly. "今日食咗500 kcal" is natural. Don't force pure Chinese.
5. **Short, punchy copy** — 茶餐廳 menus don't have paragraphs. Keep all UI text under 12 characters where possible.

---

## 3. Spacing System (4pt Grid)

All spacing uses a **4pt base unit**. This creates visual rhythm.

| Token | Value | Usage |
|-------|-------|-------|
| `space.xs` | 4pt | Text stacking, micro gaps |
| `space.sm` | 8pt | Icon-to-text gaps, tight groupings |
| `space.md` | 12pt | Inner card content spacing |
| `space.lg` | 16pt | Card internal padding |
| `space.xl` | 20pt | Screen horizontal margins, section spacing |
| `space.2xl` | 24pt | Between major sections |
| `space.3xl` | 32pt | Onboarding top padding, modal padding |
| `space.4xl` | 40pt | Page-level breathing room |

### Screen Margins
- **Horizontal padding:** 20pt (both sides) — standard for iOS, gives content room to breathe
- **Bottom safe area:** Always respect `safeAreaInsets.bottom` + 16pt minimum

---

## 4. Corner Radius

| Token | Value | Usage |
|-------|-------|-------|
| `radius.sm` | 8pt | Input fields, chips, meal type buttons |
| `radius.md` | 12pt | Cards, buttons, standard containers |
| `radius.lg` | 16pt | Large cards, summary sections |
| `radius.xl` | 20pt | Modal overlays, roast popup |
| `radius.pill` | 999pt | Pill-shaped buttons, tags |
| `radius.circle` | 50% | Avatars, calorie ring |

---

## 5. Component Specifications

### 5a. Calorie Ring (Hero Element)

The calorie ring is the **emotional centerpiece** of the app. It should feel like a neon sign.

```
Size: 180 x 180pt (increased from 160 — this is the hero)
Stroke width: 14pt (increased from 12 for more presence)
Background ring: bg.divider (#2A2A2A)
Progress ring: neon.green (#5BFF62) with glow shadow
Over-limit ring: neon.red (#FF4757) with red glow
Center number: 36pt bold, monospacedDigit
Center label: 13pt, text.secondary
Animation: spring(response: 0.6, dampingFraction: 0.7) — bouncy!
```

**Neon glow on ring:**
```swift
.shadow(color: Color(hex: "#5BFF62").opacity(0.4), radius: 12, x: 0, y: 0)
```

When calories exceed the limit, the ring turns red with a red glow — visual alarm.

### 5b. Action Buttons

```
Height: 52pt
Corner radius: 12pt (radius.md)
Font: 17pt bold
Background: neon.green (#5BFF62)
Text color: #111111 (dark text on bright neon — high contrast)
Stroke: none (the neon color is strong enough)
Glow: subtle green glow shadow
Pressed: scale(0.97) + brightness(-0.1)
Disabled: bg #333333, text #555555, no glow
Haptic: medium impact
```

> **Key change:** Text on primary buttons is now **dark** instead of white. White text on a bright neon green has worse contrast than dark text. This also gives a "neon sign" feeling — the button IS the glowing element.

### 5c. Cards

```
Background: bg.card (#1A1A1A)
Corner radius: radius.md (12pt) or radius.lg (16pt) for hero cards
Padding: 16pt all sides
Border: none by default
Elevation: no shadow (flat, layered via color)
Content spacing: 12pt between child elements
```

### 5d. Input Fields

```
Background: bg.elevated (#222222)
Border (idle): 1pt, text.muted (#404040)
Border (focused): 1.5pt, neon.green (#5BFF62) with subtle glow
Corner radius: radius.sm (8pt)
Padding: 12pt horizontal, 10pt vertical
Placeholder: text.tertiary (#606060)
Text: text.primary (#FFFFFF)
Font: 15pt regular
```

### 5e. Roast Toast (Signature Element)

This is the **most important branded moment** in the app. When you add food, the roast overlay should feel like a neon sign flickering to life.

```
Overlay scrim: black @ 60% opacity
Container: bg.card (#1A1A1A), radius.xl (20pt)
Border: 1.5pt neon.amber (#FFB547) @ 70% opacity — glowing amber border
Glow: shadow(color: neon.amber @ 0.3, radius: 16)
Emoji: 48pt
Roast text: 17pt semibold, text.primary, centered
Padding: 32pt internal, 40pt horizontal margin
Animation: spring(response: 0.5, dampingFraction: 0.7) — dramatic entrance
Duration: 2.5 seconds (slightly longer — let them read and screenshot)
```

### 5f. Meal Type Selector

```
Layout: horizontal scroll, equal-width pills
Active: neon.green (#5BFF62) background, dark text (#111111)
Inactive: bg.card (#1A1A1A), text.secondary
Corner radius: radius.sm (8pt)
Padding: 10pt vertical, 16pt horizontal
Font: 14pt medium
Haptic: light impact on tap
```

### 5g. Tab Bar

```
Background: bg.primary (#111111) with ultra-thin material blur
Active icon tint: neon.green (#5BFF62)
Inactive icon tint: text.tertiary (#606060)
Active label: neon.green, 10pt medium
Badge (if needed): neon.red (#FF4757)
```

### 5h. Macro Progress Bars

```
Track: bg.divider (#2A2A2A), 8pt height, 4pt radius
Fill: respective macro color, animated
Label: 14pt, text.secondary
Value: 13pt medium, text.primary, monospacedDigit
Spacing: 6pt between label row and bar
```

### 5i. Food Entry Row

```
Layout: HStack, vertical center aligned
Food name: 15pt medium, text.primary
Subtitle: 12pt, text.secondary
Calorie text: 15pt semibold, neon.green (#5BFF62), monospacedDigit
Vertical padding: 6pt top/bottom
Divider: bg.divider (#2A2A2A), 0.5pt
Swipe action: neon.red background, white trash icon
```

### 5j. Survey Option Button (Onboarding)

```
Unselected:
  Background: bg.card (#1A1A1A)
  Border: 1pt, text.muted (#404040)
  Title: text.primary, 16pt medium
  Subtitle: text.secondary, 13pt

Selected:
  Background: #1A2E1A (dark green tint)
  Border: 1.5pt, neon.green (#5BFF62) with subtle glow
  Checkmark: neon.green
  Title: text.primary

Corner radius: radius.md (12pt)
Padding: 16pt
Haptic: light impact
Animation: spring(response: 0.3)
```

---

## 6. Iconography

### System Icons (SF Symbols)
Use SF Symbols exclusively. They're built for iOS, scale perfectly, and support dynamic type.

| Location | Icon | Weight |
|----------|------|--------|
| Tab: Home | `house.fill` | `.medium` |
| Tab: Food Log | `list.bullet.clipboard.fill` | `.medium` |
| Tab: Profile | `person.fill` | `.medium` |
| Add food | `plus.circle.fill` | `.medium` |
| Search | `magnifyingglass` | `.regular` |
| Close/dismiss | `xmark` | `.medium` |
| Chevron | `chevron.right` | `.semibold` |
| Delete | `trash.fill` | `.medium` |
| Edit | `pencil` | `.medium` |

### Emoji Usage
Emojis are a core part of the HK texting/meme aesthetic. Use them:
- **Meal type headers:** 🌅 早餐, 🌞 午餐, 🌙 晚餐, 🍿 小食
- **Roast overlays:** 😈 (default), 💀 (extreme roast), 🤡 (self-own), 🔥 (meme reference)
- **Onboarding options:** Each option has a relevant emoji
- **Empty states:** Use emoji as illustration replacement (cheaper than custom art, more HK-feeling)

Do NOT use emojis in: navigation titles, tab labels, button text, or data displays.

---

## 7. Animation & Motion

### Principles
1. **Snappy, not sluggish** — HK people are impatient. Everything should feel responsive.
2. **Spring over ease** — Spring animations feel more natural and energetic.
3. **Meaningful, not decorative** — Animate to communicate state changes, not to look fancy.

### Standard Animations

| Context | Type | Parameters |
|---------|------|------------|
| Page transition | Spring | response: 0.35, damping: 0.85 |
| Card appearance | Spring | response: 0.4, damping: 0.8 |
| Button press | EaseInOut | duration: 0.1 |
| Progress bar fill | EaseInOut | duration: 0.4 |
| Roast overlay enter | Spring | response: 0.5, damping: 0.7 |
| Roast overlay exit | EaseOut | duration: 0.25 |
| Number change | `.contentTransition(.numericText())` | default |
| Tab switch | None | instant (snappy) |

### Haptic Feedback

| Event | Style |
|-------|-------|
| Primary button tap | `.medium` impact |
| Option selection | `.light` impact |
| Food added | `.success` notification |
| Delete | `.warning` notification |
| Over calorie limit | `.error` notification |

---

## 8. Layout Patterns

### 8a. Dashboard (Home Page)
```
┌────────────────────────────┐
│ Greeting        Date/Day   │ ← top bar, no nav title
│ User Name                  │
├────────────────────────────┤
│                            │
│     ╭──────────────╮       │
│     │  ◯ 1,240     │       │ ← calorie ring (hero)
│     │  仲可以食     │       │    neon green glow
│     ╰──────────────╯       │
│                            │
│  食咗 760    上限 2,000    │
├────────────────────────────┤
│ 今日營養                    │
│ ███████░░░ 蛋白質 80/120g  │ ← macro bars
│ ██████░░░░ 碳水 180/250g   │
│ ████░░░░░░ 脂肪 30/65g    │
├────────────────────────────┤
│ [  又食嘢？記低佢  ]       │ ← primary action, neon glow
├────────────────────────────┤
│ 今日罪行                    │
│ 叉燒飯       680 kcal     │ ← food entries
│ 奶茶         150 kcal     │
└────────────────────────────┘
```

### 8b. Add Food Sheet
```
┌────────────────────────────┐
│ 算啦        認罪           │ ← nav bar
├────────────────────────────┤
│ [早餐] [午餐] [晚餐] [小食]│ ← meal selector pills
├────────────────────────────┤
│ 🔍 今次食咗咩...           │ ← search bar
├────────────────────────────┤
│ + 自首                  ▼  │ ← expand custom entry
├────────────────────────────┤
│ 你成日食嗰啲                │
│ 叉燒飯           680 kcal │
│ ────────────────────────── │
│ 雲吞麵           380 kcal │
│ ────────────────────────── │
│ 菠蘿油           340 kcal │
└────────────────────────────┘
```

### 8c. Roast Overlay (Branded Moment)
```
┌────────────────────────────┐
│░░░░░░░░░░░░░░░░░░░░░░░░░░│
│░░░░░░░░░░░░░░░░░░░░░░░░░░│
│░░░ ╭─── amber glow ───╮ ░░│
│░░░ │                   │ ░░│
│░░░ │       😈          │ ░░│
│░░░ │                   │ ░░│
│░░░ │  全亞洲最優秀嘅    │ ░░│
│░░░ │  肉餅飯 🏆        │ ░░│
│░░░ │  食完記得排隊      │ ░░│
│░░░ │  排到元朗          │ ░░│
│░░░ │                   │ ░░│
│░░░ ╰──────────────────╯ ░░│
│░░░░░░░░░░░░░░░░░░░░░░░░░░│
│░░░░░░░░░░░░░░░░░░░░░░░░░░│
└────────────────────────────┘
  ░ = scrim (black 60%)
  amber border with glow
```

---

## 9. Empty States & Personality Moments

Every "empty" state is an opportunity to roast. Never show generic placeholder text.

| Screen | Empty State Text | Emoji |
|--------|-----------------|-------|
| Home (no entries today) | "今日仲未食嘢？ 你以為你喺戒食？" | 🤨 |
| Food log (no entries) | "冇記錄 唔代表你冇食" | 👀 |
| Profile (no data) | "連自己幾重都唔知？" | 💀 |
| Search (no results) | "搵唔到 自己打返個名啦" | 🤷 |
| Over calorie limit | "恭喜你 今日超標" | 🎉 |

---

## 10. HK-Specific UX Considerations

### 10a. Information Density
HK users are accustomed to **high information density** — think OpenRice, HKTVmall, LIHKG. Don't over-simplify. Show data upfront rather than hiding it behind taps. The macro breakdown, calorie numbers, and food list should all be visible on the home screen without scrolling.

### 10b. Speed Over Polish
HK users are impatient (fast city, dense schedules). Prioritize:
- **One-tap food logging** from common foods list
- **No loading spinners** — use optimistic UI updates
- **Instant feedback** — haptics + roast toast immediately on food add
- **Swipe gestures** for delete/edit (HK users are gesture-savvy)

### 10c. Social Shareability
The roast overlays should be **screenshot-ready**:
- High contrast text on dark background reads well as screenshots
- Roast text should be self-contained (makes sense without app context)
- The amber-bordered roast card looks distinctive when shared on IG Stories / WhatsApp

### 10d. Code-Switching (中英混用)
HK people naturally mix Chinese and English. The UI should too:
- "kcal" not "千卡"
- "BMI" not "身體質量指數"
- "lunch" alongside "午餐"
- Numbers in Arabic numerals, not Chinese (760 not 七百六十)

### 10e. Dark Mode Only
No light mode. Reasons:
- Matches the 深夜茶餐廳 aesthetic
- Most HK users use dark mode (high smartphone usage at night)
- Neon accents only work on dark backgrounds
- Simpler to maintain one theme done well

---

## 11. Design Token Summary (Swift Implementation)

All colors and design values should be centralized in a `DesignTokens.swift` file:

```swift
// MARK: - Background
static let bgPrimary = Color(hex: "#111111")
static let bgCard = Color(hex: "#1A1A1A")
static let bgElevated = Color(hex: "#222222")
static let bgDivider = Color(hex: "#2A2A2A")

// MARK: - Neon Accents
static let neonGreen = Color(hex: "#5BFF62")
static let neonAmber = Color(hex: "#FFB547")
static let neonRed = Color(hex: "#FF4757")
static let neonBlue = Color(hex: "#54A0FF")

// MARK: - Text
static let textPrimary = Color.white
static let textSecondary = Color(hex: "#A0A0A0")
static let textTertiary = Color(hex: "#606060")
static let textMuted = Color(hex: "#404040")

// MARK: - Macros
static let macroProtein = Color(hex: "#FF6B6B")
static let macroCarbs = Color(hex: "#FFB74D")
static let macroFat = Color(hex: "#64B5F6")

// MARK: - Spacing
static let spaceXS: CGFloat = 4
static let spaceSM: CGFloat = 8
static let spaceMD: CGFloat = 12
static let spaceLG: CGFloat = 16
static let spaceXL: CGFloat = 20
static let space2XL: CGFloat = 24
static let space3XL: CGFloat = 32
static let space4XL: CGFloat = 40

// MARK: - Radius
static let radiusSM: CGFloat = 8
static let radiusMD: CGFloat = 12
static let radiusLG: CGFloat = 16
static let radiusXL: CGFloat = 20
```

---

## 12. What NOT to Do

1. **No gradients** — Flat colors with neon glow. Gradients feel 2018.
2. **No glassmorphism** — Despite it being trendy, it doesn't match the 茶餐廳 aesthetic. We're gritty, not glossy.
3. **No custom fonts** — PingFang HK is already perfect. Custom Chinese fonts are heavy (10MB+) and often missing Cantonese characters.
4. **No illustrations** — Emojis are our illustration system. They're free, they render perfectly, and they're how HK people actually communicate.
5. **No light mode** — See section 10e.
6. **No skeleton loading screens** — The app is local-first (SwiftData). Data is always available instantly.
7. **No onboarding tooltips/coach marks** — The UI should be self-evident. 茶餐廳 menus don't come with instructions.
8. **No polite microcopy** — Every piece of text is an opportunity to be 寸. "Success!" → "認咗". "Are you sure?" → "真係刪？".
9. **No thin/light font weights** — They're hard to read on dark backgrounds and feel weak. Minimum weight is `.regular`, prefer `.medium` for Chinese.
10. **No pure white backgrounds** — Ever. Even modals and sheets use `bg.primary`.

---

## 13. Accessibility Notes

Being 寸嘴 doesn't mean being exclusionary:

1. **Minimum contrast ratio 4.5:1** for all text against backgrounds
2. **Touch targets minimum 44x44pt** — Apple HIG requirement
3. **Support Dynamic Type** — use `.font(.system(size:))` with `@ScaledMetric` for key sizes
4. **VoiceOver labels** — all interactive elements must have accessibility labels (in Cantonese)
5. **Reduce Motion** — respect `UIAccessibility.isReduceMotionEnabled`, skip neon glow animations
6. **Color is never the only indicator** — pair color with text/icons (e.g., over-limit shows red AND "超標" text)

---

*Version 1.0 — February 2026*
*Designed for Hong Kong people, by Hong Kong people.*
