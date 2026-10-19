# Doctor Hunt — Colors

Source of truth: `AppColors` in `lib/apps/core/theme/app_theme.dart`.
Use the token name in code, never the hex value.

## Brand
| Token | Hex | Use |
|---|---|---|
| `primary` | `#0EBE7E` | Main brand green — primary buttons, links, active states |
| `primaryDark` | `#07A86E` | Pressed / emphasis on primary |
| `primaryLight` | `#E8FBF6` | Tinted backgrounds, chips, selected cards |
| `secondary` | `#07D9AD` | Accent teal, gradients |

## Surfaces
| Token | Hex | Use |
|---|---|---|
| `background` | `#FFFFFF` | Screen background |
| `surface` | `#FFFFFF` | Cards, fields, sheets |
| `surfaceMuted` | `#F1F4F6` | Skeleton loaders, muted blocks |
| `mapPlaceholder` | `#E2EAF0` | Map / image placeholder |

## Text
| Token | Hex | Use |
|---|---|---|
| `textStrong` | `#222B45` | Strongest headings |
| `textMain` | `#333333` | Titles, labels, main text |
| `textSecondary` | `#677294` | Body text, hints |
| `textMuted` | `#8A94A6` | Captions, meta info |

## Lines & states
| Token | Hex | Use |
|---|---|---|
| `outline` | `#E5E7EB` | Field borders, dividers |
| `outlineSoft` | `#E5E9EB` | Subtle card borders |
| `dateOutline` | `#E8E8E8` | Booking date/slot chips |
| `disabled` | `#C9D5E8` | Disabled controls |

## Feedback
| Token | Hex | Light | Use |
|---|---|---|---|
| `success` | `#0EBE7E` | `#E8FBF6` | Booking confirmed, completed |
| `error` | `#FF4848` | `#FFEBEE` | Errors, cancel actions |
| `warning` | `#F57C00` | `#FFF3E0` | Warnings |

## Accents
| Token | Hex | Use |
|---|---|---|
| `rating` | `#FFB800` | Rating stars |
| `favorite` | `#FF003A` | Favorite heart (alias of `attention`) |
| `switchActive` | `#10C98B` | Active toggle switch |
| `menuGradientStart → End` | `#6F7FA1 → #536184` | Side menu gradient |
| `settingsPasswordBadge` | `#EB5757` | Settings: password icon |
| `settingsNotificationBadge` | `#219653` | Settings: notifications icon |
| `settingsPrivacyBadge` | `#F2994A` | Settings: privacy icon |
| `googleBlue` | `#4285F4` | Google sign-in only |

## Shadows (black, low opacity)
| Token | ARGB | Use |
|---|---|---|
| `shadowFaint` | `#06000000` | Barely-there lift |
| `shadowSubtle` | `#08000000` | Small chips |
| `shadowSoft` | `#0A000000` | Soft containers |
| `shadowCard` | `#0C000000` | Cards |
| `shadowControl` | `#0F000000` | Buttons / controls |
| `shadowNavigation` | `#12000000` | Bottom navigation |
| `shadowElevated` | `#14000000` | Raised surfaces |
| `shadowImage` | `#18000000` | Doctor images |
| `shadowSnackbar` | `#1A000000` | Snackbars |
| `shadowStrong` | `#24000000` | Dialogs |
| `boxShadow` | `#140EBE7E` | Green-tinted glow under primary elements |

## Rules
- Green leads: one `primary` action per screen; everything else neutral.
- Red (`error`, `favorite`) only for errors, cancellation, and favorites.
- Body text on white uses `textSecondary`; headings use `textMain`.
- Need a new color? Add it to `AppColors` first, then document it here.
