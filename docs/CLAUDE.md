# CaLoMei Project Guidelines

## Project Overview
CaLoMei is a calorie tracker app designed for Hong Kong people. The app's personality is 寸嘴 (sharp-tongued) and 毒舌 (venomous) — it roasts users for eating trash food. Marketing strategy: "This app diu me when I eat trash food".

## Project Structure
- `CaLoMei/` — iOS app (Swift, SwiftUI, SwiftData)
  - `Root/` — App coordinator and navigation
  - `Views/` — All UI views organized by feature
    - `Onboarding/` — Onboarding flow and question pages
    - `Main/` — Main app views (tabs, food log, profile)
  - `Data/` — Models and persistence
    - `Model/` — SwiftData models
  - `Managers/` — Business logic layer
  - `Common/` — Shared UI components and extensions
    - `Extensions/` — Swift extensions (Color, Date, etc.)
    - `Components/` — Reusable UI components (buttons, cards, etc.)

## iOS Performance Patterns & Rules

### SwiftData

**NEVER use explicit `modelContext.save()` on the main context.**
SwiftData auto-saves on main actor. Only use explicit save in background `@ModelActor` contexts.

**Use `fetchLimit` on `@Query` and `FetchDescriptor`** when you only need a subset of results.

**Pass `PersistentIdentifier` (not model objects) across actor boundaries.**

### UI Responsiveness — The Phase Pattern

When a user interaction triggers both UI updates and background work:

**Phase 1 — Synchronous (immediate, minimal):**
Only update the state that SwiftUI needs to re-render.

**Phase 2 — Deferred MainActor (`Task { @MainActor in }`):**
Secondary UI calculations.

**Phase 3 — Background (`Task(priority: .utility)`):**
Analytics, cloud sync, etc. Snapshot SwiftData model data as value types first.

### Language & Tone
- All user-facing strings MUST be in Cantonese (廣東話)
- Use natural Hong Kong Cantonese, not formal written Chinese
- Food items should include common Hong Kong foods (茶餐廳, 街頭小食, etc.)
- **Tone: 寸嘴 / 毒舌 (mean, sarcastic, sharp-tongued)**
  - NEVER be polite — no "歡迎", no "請", no full polite questions
  - Be blunt and direct: "叫咩名" not "你叫咩名？"
  - Roast the user for eating junk food (eating = 罪行/crimes)
  - Use self-deprecating HK humor: "姐係有少少肥咁 少少🤏"
  - Frame calorie limits as 上限 (upper limit), not 目標 (goal)
  - Frame food logging as 認罪 (confessing crimes)
  - Inspired by 小氣簿 app's viral irreverent tone
  - Mean but funny — users should screenshot and share the roasts

### Design System
- Dark theme: background `#151515`, card background `#1E1E1E`
- Primary accent: `#4CAF50` (green for health)
- Secondary accent: `#FF6B00` (orange for energy)
- Font: System font (San Francisco)
- Border radius: 12pt for cards, 8pt for buttons
