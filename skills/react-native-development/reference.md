# React Native reference (read when needed)

## Expo

- **EAS Update** vs store builds: native module changes require a new binary, not OTA alone.
- Config plugins: validate with `npx expo prebuild` in CI when touching `app.config`.

## Performance

- Memoize row components for heavy lists; stabilize `renderItem` references when profiling shows wasted renders.
- Avoid anonymous functions in list rows when using old architecture and measurable jank.

## Permissions

- Request in context (user action), not at cold start, unless the product already does otherwise.

## Deep linking

- Align path prefixes with `app.json` / native intent filters; test cold start and background open.

## Accessibility

- `accessibilityRole`, `accessibilityLabel` on tappable icons; hitSlop for small targets.
