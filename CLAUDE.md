# TaxLien.online Flutter App - Development Guide

## Build Commands
- **Install dependencies:** `flutter pub get`
- **Run app (dev):** `flutter run`
- **Generate localization:** `flutter gen-l10n`
- **Run build runner:** `dart run build_runner build --delete-conflicting-outputs`
- **Release APK:** `flutter build apk --release`
- **Release App Bundle:** `flutter build appbundle --release`
- **Release iOS:** `flutter build ios --release`

## Test Commands
- **Run all tests:** `flutter test`
- **Run specific test:** `flutter test test/path_to_test.dart`
- **Coverage:** `flutter test --coverage`

## Environment Configuration
The app uses `flutter_dotenv`.
1. Copy `.env.example` to `.env`
2. Update values in `.env`
3. Ensure `.env` is listed in `pubspec.yaml` assets.

## CI/CD
- GitHub Actions configuration: `.github/workflows/`
- GitLab CI configuration: `.gitlab-ci.yml`
- Fastlane configuration: `fastlane/`

## Project Structure
- `lib/core/config/`: API and environment configuration.
- `lib/services/`: Business logic and API clients.
- `lib/screens/`: UI screens.
- `lib/widgets/`: Reusable UI components.
- `lib/features/`: Complex feature modules.
