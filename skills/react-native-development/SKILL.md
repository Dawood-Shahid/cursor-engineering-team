---
name: react-native-development
description: React Native/Expo feature checklist—secure tokens, lists, navigation, and native boundaries. Use when implementing or changing mobile screens, navigation, or native integrations.
---

# React Native feature development

## Before coding
- Detect **Expo** vs bare RN (`app.json`, `expo` in dependencies).
- Follow existing navigation (Expo Router, React Navigation, etc.)—do not introduce a second pattern.
- Use the project's server-state layer (often TanStack Query); use Zustand only for client UI state if the project already does.

## Implementation checks
- Tokens: prefer `expo-secure-store` or Keychain/Keystore patterns—never AsyncStorage for refresh tokens unless the project already mandates it.
- Lists: `FlatList`/`SectionList` with `keyExtractor`, sensible `windowSize`; avoid mapping huge arrays in `ScrollView`.
- Images: size assets; use the project's cached image component if present.
- Android back: handle hardware back when using modals or nested stacks.
- Native changes: prefer Expo config plugins over hand-editing `android/`/`ios/` unless bare workflow requires it.
- Reanimated: keep worklets off the JS thread for animations already using Reanimated in the repo.

## Finish
- Typecheck and lint.
- Verify one Android and one iOS path when behavior differs (permissions, safe area, back).

## Deep reference
- Performance, OTA, and platform quirks: [reference.md](reference.md)
