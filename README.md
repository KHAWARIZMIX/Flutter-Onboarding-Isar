# 👤 Flutter Onboarding Isar

A basic Flutter onboarding app that allows users to create a profile with a name and profile picture. Built using:

- 🧠 **Riverpod** for state management
- 💾 **Isar** for local data persistence
- 📸 **Image Picker** for selecting profile images

---

## 🚀 Features

- Clean and simple onboarding flow
- Profile image selection via gallery
- Local user data storage with Isar
- Responsive and modular code with Riverpod
- Ready-to-use architecture for user-driven apps

---

## 📷 Preview

> _(Add screenshots or a GIF of the onboarding flow here)_

---

## 🛠️ Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/flutter-onboarding-isar.git
cd flutter-onboarding-isar
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate Isar files

```bash
flutter pub run build_runner build
or
dart run build_runner build --delete-conflicting-outputs
```

> ⚠️ Use `build_runner watch` for automatic rebuilds during development.

### 4. Run the app

```bash
flutter run
```

---

## 📦 Dependencies

| Package                           | Purpose                                         |
| --------------------------------- | ----------------------------------------------- |
| `flutter_riverpod`                | State management                                |
| `isar` + `isar_flutter_libs`      | Local NoSQL database                            |
| `image_picker`                    | Pick image from gallery or camera               |
| `intl`                            | Date/time formatting and localization           |
| `path`                            | Utilities for manipulating file paths           |
| `path_provider`                   | Access device directories (e.g. cache, app doc) |
| `build_runner` + `isar_generator` | Code generation for Isar                        |

---

## 📁 Project Structure

```
lib
├── app.dart
├── main.dart
├── model
│   ├── onboarding_model.dart
│   ├── user.dart
│   └── user.g.dart        
├── notfiers
│   └── onboarding_notifier.dart
├── pages
│   ├── bio_input.dart
│   ├── mail_input.dart
│   └── name_input.dart
├── providers
│   └── provider.dart
├── screen
│   ├── home_screen.dart
│   └── onboarding
│       └── profile_setup_screen.dart
├── utility
│   ├── date_format.dart
│   └── image_utils.dart
└── widgets
    └── user_avatar.dart
```
Note: The contents inside the /pages directory are not used by default.
---

## ✅ Requirements

- Flutter SDK (latest stable)
- Dart SDK
- Android Studio or VS Code
- Android or iOS emulator/device

---


## 📄 License

[MIT](LICENSE)
