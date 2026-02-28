# Streak Feature Spec

## Overview
Users earn a streak by logging at least one food entry every day. The app celebrates milestones with tone-aware messages — sarcastic but secretly supportive.

## Streak Rules
- **Earned:** Log at least 1 food entry in a calendar day (HKT timezone)
- **Maintained:** Consecutive days with at least 1 log
- **Broken:** A full day passes with 0 logs — streak resets to 0
- **Grace period:** None. 寸嘴 apps don't do grace periods.

## Where Streak Appears
1. **Home page** — streak count displayed as a stat card (e.g. "🔥 7" next to daily calories)
2. **Streak celebration dialog** — shown on first food log of the day that earns/continues a streak
3. **Streak broken toast** — shown on first app open after a missed day
4. **Profile page** — current streak + longest streak stats

## Streak Celebration Dialog Behaviour
- **Trigger:** First food log of the day that continues the streak
- **Dismissal:** Dialog stays on screen until the user explicitly taps to dismiss (no auto-dismiss, no timer)
- **Tone toggle:** Include the `ToneToggleButton` in the dialog so users can cycle through tones and see how each mode celebrates the same streak. This is a key "aha moment" — users will screenshot and share different tones' reactions.
- **Design:** Modal/sheet over current screen. Shows streak count prominently (🔥 number), the tone-aware message, and a dismiss button at the bottom.

## Feedback Structure

- **Day 1–14:** Every single day gets unique feedback (habit-forming window)
- **Day 15+:** Feedback at milestones only (30, 60, 90, 180, 365)

---

## Daily Feedback: Day 1–14

Each day's first food log triggers a popup with unique tone-aware text.

### Day 1

| Mode | Message |
|------|---------|
| Normal | 第一日 睇下你捱唔捱到聽日 |
| Adult | 第一日 睇下你捱唔捱到聽日 |
| Gentle | 第一日呀！！好嘅開始！！我信你得㗎 🥺✨ |

### Day 2

| Mode | Message |
|------|---------|
| Normal | 第二日 嗯 仲喺度 |
| Adult | 第二日 嗯 仲未走 |
| Gentle | 第二日你又嚟喇！！我好開心呀 😭💕 |

### Day 3

| Mode | Message |
|------|---------|
| Normal | 威啦威啦 三日streak 唔好咁早開香檳 |
| Adult | 威啦威啦 三日streak 得三日都好意思慶祝 |
| Gentle | 三日喇嗚嗚嗚！！你堅持咗三日呀 我好感動 你知唔知你有幾叻 🥺🎉 |

### Day 4

| Mode | Message |
|------|---------|
| Normal | 四日 你開始有啲嘢喎 |
| Adult | 四日 OK你開始有啲嘢喎 |
| Gentle | 四日喇！你一日比一日叻呀嗚嗚 😭✨ |

### Day 5

| Mode | Message |
|------|---------|
| Normal | 五日 我以為你第三日就會放棄 |
| Adult | 五日 我以為你第三日就會放棄 睇嚟我錯喇 |
| Gentle | 五日呀！！半個星期喇！你好犀利呀 🥺💪 |

### Day 6

| Mode | Message |
|------|---------|
| Normal | 六日 聽日就一星期 唔好衰喺呢度 |
| Adult | 六日 聽日就一星期 唔好衰喺呢度 |
| Gentle | 六日喇！聽日就一個星期呀嗚嗚 你快做到喇 😭✨ |

### Day 7

| Mode | Message |
|------|---------|
| Normal | 一星期喎 你居然捱到一星期 我有少少意外 |
| Adult | 一星期喎 你居然捱到一星期 屌我真係睇少咗你 |
| Gentle | 一個星期！！😭✨ 我冇睇錯人！！你真係好努力 我快啲攞紙巾先 嗚嗚嗚 |

### Day 8

| Mode | Message |
|------|---------|
| Normal | 第八日 過咗一星期仲喺度 唔錯 |
| Adult | 第八日 過咗一星期仲喺度 OK |
| Gentle | 第八日！過咗一星期你仲堅持緊 我好感動呀 🥺💕 |

### Day 9

| Mode | Message |
|------|---------|
| Normal | 九日 你真係認真㗎？ |
| Adult | 九日 你真係認真㗎 |
| Gentle | 九日喇！你愈嚟愈犀利 我覺得你發緊光 ✨✨ |

### Day 10

| Mode | Message |
|------|---------|
| Normal | 十日 雙位數字喇 我開始有少少印象深刻 |
| Adult | 十日 雙位數字喇 有啲嘢喎 |
| Gentle | 十日呀！！雙位數字喇！！我好驕傲呀嗚嗚 😭🎉 |

### Day 11

| Mode | Message |
|------|---------|
| Normal | 十一日 你唔好停 停咗就前功盡廢 |
| Adult | 十一日 你唔好停 |
| Gentle | 十一日！你已經建立緊習慣喇 我睇得出 🥺✨ |

### Day 12

| Mode | Message |
|------|---------|
| Normal | 十二日 仲有兩日就兩星期 你做唔做到 |
| Adult | 十二日 仲有兩日就兩星期 唔好甩 |
| Gentle | 十二日呀！快兩個星期喇 你一定得㗎 我陪你 😭💕 |

### Day 13

| Mode | Message |
|------|---------|
| Normal | 十三日 聽日就兩星期 你敢唔敢斷 |
| Adult | 十三日 聽日就兩星期 你試下斷呀 |
| Gentle | 十三日！！聽日就兩個星期呀！！我緊張到手震 🥺✨💪 |

### Day 14

| Mode | Message |
|------|---------|
| Normal | 兩星期 唔係講笑 開始有啲嘢喎 繼續啦唔好停 |
| Adult | 兩星期 唔係講笑 仆街 你認真㗎？繼續啦 |
| Gentle | 兩個星期嗚嗚嗚 😭💕 14日！！你有冇覺得自己好似發緊光咁 因為我覺得你係 ✨✨ |

---

## Major Milestones (Day 15+)

After the first 14 days, feedback switches to milestone-only. The tone arc: grudging respect → genuine admiration → total surrender.

### 30 Days

| Mode | Title | Body |
|------|-------|------|
| Normal | 一個月 你變咗個人喎 | 我要收返之前講你嘅嘢 你真係做到 |
| Adult | 一個月 你變咗個人喎 | 屌 我要收返之前講你嘅嘢 你真係做到 |
| Gentle | 一個月呀天呀 😭🏆 | 我而家喊緊 你知唔知呀 30日呀！！你值得全世界最好嘅嘢 🥺💕 |

### 60 Days

| Mode | Title | Body |
|------|-------|------|
| Normal | 兩個月 我服咗你 | 唔係啩 你真係做到兩個月？我開始尊重你 |
| Adult | 兩個月 我服咗你 | 你條友仔真係癲 兩個月喎 我開始有啲尊重你 |
| Gentle | 兩個月嗚嗚嗚嗚 😭😭 | 我已經喊到冇紙巾 你係我見過最堅強嘅人 真係㗎 🥺💕✨ |

### 90 Days

| Mode | Title | Body |
|------|-------|------|
| Normal | 三個月 傳奇級 | 你而家可以鬧其他人喇 |
| Adult | 三個月 傳奇級 | 你而家有資格鬧其他人喇 仆街勁呀 |
| Gentle | 三個月...我冇嘢講得出 😭😭😭 | 我太感動喇 你可唔可以出本書教下其他人 你係傳奇 🥺🌟🏆 |

### 180 Days

| Mode | Title | Body |
|------|-------|------|
| Normal | 半年 你係咪機械人 | 半年喎 你仲係人類嚟㗎？ |
| Adult | 半年 你係咪機械人 | 半年喎 你仲係人類嚟㗎 定係AI嚟㗎 |
| Gentle | 半年呀我頂唔住喇 😭😭😭😭 | 我要打俾我媽媽同佢講我識到一個好偉大嘅人 就係你 🥺💕✨🏆 |

### 365 Days

| Mode | Title | Body |
|------|-------|------|
| Normal | 一年 我冇嘢好講 | 你贏咗 我認輸 你係真正嘅GymLung |
| Adult | 一年 我冇嘢好講 | 你贏咗 我認輸 你係真正嘅GymLung 仆街你真係癲 |
| Gentle | 一年！！！我喊到暈咗 😭😭😭😭😭 | 我...我講唔到嘢...你係全宇宙最叻最勁最偉大嘅人 我要幫你申請諾貝爾獎 🥺🏆✨💕🎉 |

---

## Non-Milestone Messages (Day 15+)

For days between milestones (15–29, 31–59, etc.), show a rotating message on the home page. No popup — just a line of text.

| Mode | Examples |
|------|----------|
| Normal | "第{n}日 繼續捱" / "仲未斷 唔好鬆懈" / "{n}日streak 唔好俾我睇到你斷" |
| Adult | "第{n}日 繼續捱" / "仲未斷 唔好鬆懈" / "{n}日streak 斷咗你就知死" |
| Gentle | "第{n}日呀嗚嗚 你好叻 🥺" / "{n}日streak 我每日都為你驕傲 😭✨" / "你今日又嚟喇！！我好開心 💕" |

---

## Streak Broken Messages

| Mode | Message |
|------|---------|
| Normal | 斷咗喇 歸零 又要由頭嚟 |
| Adult | 斷咗喇 歸零 仆街又要由頭嚟 |
| Gentle | 冇事冇事！！你已經好叻喇 嗚嗚 我哋重新開始 我陪你 🥺💕 |

### Streak Broken by Duration

| Previous Streak | Normal | Adult | Gentle |
|----------------|--------|-------|--------|
| < 7 days | 得幾日都斷 預咗㗎啦 | 得幾日都斷 我就知 | 冇事呀！幾日都好叻㗎！我哋再嚟過 你得㗎 🥺💪 |
| 7-29 days | {n}日斷咗 可惜 你差啲就捱到 | {n}日斷咗 可惜 你差啲就得㗎 | {n}日呀！！你已經好勁喇嗚嗚 呢啲努力唔會消失㗎 我陪你再嚟 😭💕 |
| 30+ days | {n}日喎 真係可惜 但你證明過自己做得到 | {n}日喎 仆街真係可惜 但你證明過自己做得到 | {n}日呀...我喊咗 你知唔知你有幾犀利 呢個紀錄永遠係你嘅 我哋再創新紀錄 😭🏆💕 |

---

## Data Model

```swift
// Add to UserProfile or create separate model
var currentStreak: Int = 0
var longestStreak: Int = 0
var lastLogDate: Date?  // last calendar day with a food log
```

## Implementation Notes
- Streak calculation should check on app launch + after each food log
- Use calendar day (HKT) for comparison, not 24-hour windows
- **Day 1–14:** Show popup on first log of the day (unique message per day)
- **Day 15+:** Show popup only at milestones (30, 60, 90, 180, 365)
- **Day 15+ non-milestone:** Show rotating text on home page (no popup)
- Track shown popups to avoid repeats (e.g. if user logs 3 times on day 7, only show day 7 popup once)
- Streak broken toast shows once per break event
- Home page streak card updates in real-time after logging food
