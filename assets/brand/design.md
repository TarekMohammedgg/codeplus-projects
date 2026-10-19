# Doctor Hunt — Design Guide (Demo Video)

Use this file when editing the app's demo video.
Based on [BRIEF.md](BRIEF.md) (brand, voice, rules) and [Colors.md](Colors.md) (palette).
If anything here conflicts with those two files, they win.

## 1. Story
The video follows the patient journey, one scene per step, then a short Admin part:

| # | Scene | Screen(s) | Caption (en / ar) | Lucide icon |
|---|---|---|---|---|
| 1 | Intro | Splash | Find your doctor. Book in seconds. / لاقي دكتورك واحجز في ثواني | `stethoscope` |
| 2 | Find | Home, Doctors | Search by name or specialty / ابحث بالاسم أو التخصص | `search` |
| 3 | Details | Doctor Details | Real ratings from real visits / تقييمات حقيقية من زيارات حقيقية | `star` |
| 4 | Book | Booking date → slot | Pick a day, pick a slot / اختار اليوم والميعاد | `calendar-days`, `clock` |
| 5 | Confirm | Booking review → success | Booked. No double booking. / تم الحجز بدون تعارض | `calendar-check` |
| 6 | Manage | Appointments | Upcoming, completed, cancelled / القادمة، المكتملة، الملغاة | `calendar-clock` |
| 7 | Rate | Rate Doctor | Rate your doctor after the visit / قيّم دكتورك بعد الزيارة | `star` |
| 8 | Admin | Doctors List, Availability | The clinic manages it all / العيادة بتدير كل حاجة | `shield-check` |
| 9 | Outro | Logo + tagline | Doctor Hunt | `stethoscope` |

Only show features that exist in the app (see `AGENTS.md` scope). No chat, payments, online consultation, etc.

## 2. Format
| | Value |
|---|---|
| Main | 1080×1920 (9:16) — reels / stories |
| Alt | 1920×1080 (16:9) — phone mockup centered, caption on the side |
| FPS | 30 |
| Length | 45–60s (~5s per scene) |
| Safe area | 96px top/bottom, 64px sides — keep captions inside |

## 3. Colors (from Colors.md)
| Role | Token | Hex |
|---|---|---|
| Background | `background` / `primaryLight` | `#FFFFFF` / `#E8FBF6` |
| Brand / highlight | `primary` | `#0EBE7E` |
| Gradient | `primary → secondary` | `#0EBE7E → #07D9AD` |
| Headline text | `textStrong` | `#222B45` |
| Sub text | `textSecondary` | `#677294` |
| Stars | `rating` | `#FFB800` |
| Cancel / error only | `error` | `#FF4848` |

Rules: white or `primaryLight` backgrounds, green for highlights, red only for the cancel moment.

## 4. Typography
Font: `Rubik` (supports Arabic + English).

| Element | Size (1080w) | Weight | Color |
|---|---|---|---|
| Headline caption | 64 | 700 | `textStrong` |
| Sub caption | 40 | 400 | `textSecondary` |
| Highlight word | same as line | 700 | `primary` |
| Outro tagline | 56 | 600 | `primary` |

- Max 2 lines per caption, ~6 words per line.
- Arabic captions are RTL and right-aligned; English left-aligned. Don't mix both in one line.

## 5. Icons — Lucide only
Library: https://lucide.dev/icons/ — no other icon set.

- Stroke width `2`, rounded caps/joins (Lucide default).
- Size: 72px next to captions, 48px inside badges.
- Color: `primary` on white, `white` on a `primary` circle badge.
- Use the icon names in the story table; extra ones if needed:

| Meaning | Icon |
|---|---|
| Doctor | `stethoscope` |
| Search | `search` |
| Specialty filter | `list-filter` |
| Favorite | `heart` |
| Rating | `star` |
| Date | `calendar-days` |
| Time slot | `clock` |
| Booked | `calendar-check` |
| Cancelled | `calendar-x` |
| Clinic location | `map-pin` |
| Fee | `wallet` |
| Profile | `user-round` |
| Settings | `settings` |
| Language | `languages` |
| Notifications | `bell` |
| Admin | `shield-check` |
| Done / success | `circle-check` |

## 6. Layout
- Phone mockup: centered, ~70% of frame height, corner radius 48, `shadowElevated` shadow.
- Caption block: above the phone (9:16) or beside it (16:9), with its icon in front of the headline.
- Spacing on an 8px grid; corners 12px for cards/chips (matches the app).
- Background accent: soft green blur shapes like `assets/design/splash_background.png`.

## 7. Motion
| Element | Animation | Duration | Easing |
|---|---|---|---|
| Scene change | Slide + fade | 400ms | ease-in-out |
| Caption in | Fade up 24px | 300ms | ease-out |
| Icon in | Scale 0.8 → 1 | 250ms | ease-out |
| Tap highlight | Green ripple circle (`primary` 30%) | 300ms | ease-out |
| Success | `circle-check` pop + light confetti in `primary`/`secondary` | 600ms | spring |

- Calm pace — one action per scene, no fast cuts.
- Show real taps (ripple) on the button that moves the journey forward.

## 8. Audio
- Light, upbeat, soft instrumental; no heavy beats.
- Soft click on taps, short chime on booking success.

## 9. Assets
| Asset | Path |
|---|---|
| Logo | `assets/design/doctor_hunt_logo.png` |
| Splash logo | `assets/design/splash_logo.png` |
| Background accent | `assets/design/splash_background.png` |
| Success illustration | `assets/design/thanks.png` |
| Screens | Record from the real app (same build, same seed data) |

## 10. Checklist before export
- [ ] Every scene uses only colors from Colors.md.
- [ ] Every icon is from Lucide.
- [ ] Captions inside the safe area, max 2 lines, Rubik.
- [ ] Arabic version is RTL and checked for typos.
- [ ] No out-of-scope feature appears on screen.
- [ ] Real doctor/patient data is replaced with demo data.
