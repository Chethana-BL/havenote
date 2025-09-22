# Havenote — Offline-First Personal Journal (WIP)

> Write daily entries, attach photos, tag moods — even offline. Data syncs when you’re back online.

## Overview
**Havenote** is personal journal. Write entries, add photos, and tag moods—everything works offline and syncs automatically when back online.

- Entries with title/body, mood, tags
- Add photos from gallery; images stored in Firebase Storage
- Soft delete (Recently Deleted) with restore
- Debounced search on Home; toggle to show/hide deleted
- Clean Architecture + Riverpod + GoRouter
- Material 3 theming (light/dark), EN/DE localization

Firebase used: **Auth**, **Firestore** (offline persistence), **Storage**.

## Implemented so far
- **Auth (email & password)**: sign up, sign in, sign out  
- **Verify email**: resend + “I’ve verified” check  
- **Forgot password**: reset link  
- **Routing**: GoRouter with guards; Splash handles first navigation
- **Settings**: theme mode (system/light/dark), edit display name, sign out, delete account
- **Entries**
  - Repository: Firestore (offline-first), Storage for images
  - Home: list of entries, **debounced search**, **show deleted** toggle
  - List swipe: **soft delete/restore** with Undo snackbar
  - Detail: title/body, mood, tags, **images grid**
  - Editor: create/edit (title, body, mood, single tag), **pick & upload images**
- **Architecture**: Clean Architecture + Riverpod providers  
- **UI**: Sign In, Sign Up, Verify Email, Forgot Password, Home (placeholder card)  
- **Theming**: Material 3 (light/dark)  
- **Localization**: `en` and `de` for current strings  
- **Logging**: lightweight `Log` facade

## Roadmap
- Offline-first journaling (entries with photos & mood tags)
- Auto-sync when online
- Cloud backup & device restore
- E2E encryption demo (local + Firestore)
- Nice home/dashboard + calendar view

## Tech Stack
- **Flutter** (Material 3)
- **Riverpod** (state)
- **GoRouter** (navigation)
- **Firebase**: Auth, Firestore, Storage
- **Intl/ARB** (localization)

## Project Structure
```
lib
├─ app/           # router, theme, constants
├─ core/          # logger
├─ data/          # Firebase implementations
├─ domain/        # interfaces/contracts
├─ features/      # feature UI + state (auth, home, splash, …)
├─ l10n/          # localization (ARB + generated)
├─ services/      # Firebase init
└─ main.dart
```

## Getting Started

### 1) Prerequisites
- Flutter (stable)
- A Firebase project (iOS / Android apps created)

### 2) Configure Firebase
```bash
flutterfire configure
```
This generates `lib/firebase_options.dart`.

### 3) Run
```bash
flutter pub get
flutter run
```

## Dev Tips

Analyze & Test:
```bash
make check
```

Localization:
- Edit `l10n/app_en.arb` and `l10n/app_de.arb`
- Rebuild via your IDE or build scripts (if configured)
