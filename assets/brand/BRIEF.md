# Doctor Hunt — Brand Brief

## What it is
Doctor Hunt is a single-clinic booking app. One Flutter app, two roles:

- **Patient** — finds a doctor, books a slot, manages the booking, rates the doctor.
- **Admin** — manages the clinic's doctors, their availability, and appointments.

Core journey: `Find Doctor → Doctor Details → Book Slot → Manage Booking → Rate Doctor`

## Audience
- Patients of one clinic, Arabic and English speakers, booking from their phone.
- Clinic staff (Admin) managing doctor records and appointment status.

## Promise
Book the right doctor at your clinic in a few taps — clear availability, no double booking,
honest ratings from real completed visits.

## Personality
| Is | Is not |
|---|---|
| Calm, clean, trustworthy | Clinical, cold, or alarming |
| Friendly and direct | Playful or jokey |
| Simple, one clear action per screen | Busy, feature-crowded |

## Voice & copy
- Short, plain sentences. Say what happens next ("Book Now", "Cancel appointment").
- Address the patient directly and warmly ("Hi, {name}").
- Bilingual: every string exists in Arabic (RTL) and English. Never hardcode text.
- Confirm destructive actions (cancel booking, logout) with a clear yes/no.

## Visual identity
- **Logo:** `assets/design/doctor_hunt_logo.png` · splash: `assets/design/splash_logo.png`.
- **Color:** fresh medical green on white — see [Colors.md](Colors.md).
- **Typography:** `Rubik` for everything.

| Style | Size | Weight |
|---|---|---|
| Display | 28 | 700 |
| Page title | 26 | 700 |
| Section title | 20 | 600 |
| Button label | 16 | 600 |
| Label / Action | 15 | 600 |
| Body | 14 | 400 |

- **Shape:** rounded — 12px radius on fields and buttons, 54px button height.
- **Depth:** soft, low-opacity shadows; flat buttons (no elevation).
- **Background:** white, with the soft green blur accents from `splash_background.png`.

## Rules
- One primary (green) action per screen.
- Red is for errors, cancel, and favorites only — never decoration.
- Ratings are always gold stars with `rating · count` (e.g. "4.7 · 24 Reviews").
- Colors and text styles come from `lib/apps/core/theme/app_theme.dart` — no raw hex in widgets.
