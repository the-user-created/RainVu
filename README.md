# RainVu 💧

RainVu is a modern Flutter app for farmers, gardeners, and weather enthusiasts to meticulously log
rainfall from multiple custom gauges. It transforms raw data into actionable insights through
powerful charts and historical analysis, all while keeping user data private and on-device.

## ✨ Key Features

* **📊 Data Logging & Management**:
    * Quickly log rainfall entries with amount, date, and associated gauge.
    * Add, edit, and manage multiple custom rain gauges.
    * View all historical entries in a clean, organized list.

* **📈 Powerful Analytics & Insights**:
    * Visualize data with charts for Month-to-Date (MTD) and Year-to-Date (YTD) totals.
    * Analyze monthly trends, seasonal patterns, and year-over-year comparisons.
    * Dive deep into daily breakdowns for any given month.

* **🔄 Data Portability**:
    * Export all your data to CSV or JSON formats for backup or external analysis.
    * Import data from a previously exported file to restore or merge records.

* **🔒 Secure & Private**:
    * All rainfall data is stored securely and locally on the user's device using a relational
      database.
    * No cloud account or internet connection is required for core functionality.

## 🛠️ Tech Stack & Architecture

This project is built with a modern, scalable Flutter stack emphasizing type-safety, code
generation, and a feature-first architecture with distinct environments for development and
production.

### Core Technologies

* **Framework**: Flutter & Dart
* **State Management**: Riverpod with `riverpod_generator` for compile-safe providers.
* **Routing**: GoRouter with `go_router_builder` for type-safe, declarative navigation.
* **Local Storage**:
    * **Drift (Moor)**: For reactive, persistent storage of relational data (gauges, entries).
    * **shared_preferences**: For simple key-value storage of user settings.
* **Telemetry**:
    * **Firebase Analytics**: For anonymized usage metrics.
    * **Firebase Crashlytics**: For crash reporting.
* **Data Models**: `freezed` for immutable data classes and unions.
* **UI & Visualization**:
    * `fl_chart` for creating beautiful and interactive charts.
    * `flutter_animate` for declarative and easy-to-use animations.

### Utility Packages

* `json_serializable`: For robust JSON serialization/deserialization.
* `intl`: For internationalization and date/number formatting.
* `file_picker` & `url_launcher`: For file system and external link interactions.
* `build_runner`: To run all code generation tasks.

### Code Style & Linting

* `flutter_lints` and `riverpod_lint` are used with a strict ruleset in `analysis_options.yaml` to
  maintain code quality and consistency.

### Project Structure

The codebase follows a **feature-first** architecture and uses separate entry points for different
build environments (flavors).

```
lib/
├── core/
│   ├── data/         # Shared data sources (Drift DB, SharedPreferences)
│   ├── navigation/   # GoRouter configuration and routes
│   ├── ui/           # App-wide UI (themes, navigation shell)
│   └── utils/        # Shared utilities and extensions
│
├── features/
│   ├── [feature_name]/
│   │   ├── application/  # Business logic & Riverpod providers
│   │   ├── data/         # Feature-specific repositories
│   │   ├── domain/       # Models and entities (often with Freezed)
│   │   └── presentation/ # UI (screens, widgets)
│   └── ...
│
├── shared/
│   ├── domain/       # Domain models shared across multiple features
│   └── widgets/      # Reusable widgets (buttons, dialogs, etc.)
│
├── main_common.dart  # Shared app initialization logic
├── main_dev.dart     # Entry point for the 'dev' flavor
└── main_prod.dart    # Entry point for the 'prod' flavor
```

## 🚀 Getting Started

Follow these instructions to set up the project for local development.

### Prerequisites

* Flutter SDK (version specified in `pubspec.yaml`)
* An IDE like Android Studio or VS Code
* An Android Emulator or physical device
* An iOS Simulator or physical device (requires macOS with Xcode)
* [Firebase CLI](https://firebase.google.com/docs/cli#install_the_firebase_cli) installed and
  authenticated (`firebase login`).
* Java Development Kit (JDK) to use `keytool`.

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/the-user-created/RainVu.git
   cd RainVu
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase:**
   This project uses Firebase for Analytics and Crashlytics, configured separately for `dev` and
   `prod` environments (flavors). To run the app, you must set up your own Firebase projects.

    * Create two Firebase projects in the [Firebase Console](https://console.firebase.google.com/):
      one for development (e.g., `my-rainvu-dev`) and one for production (e.g., `my-rainvu-prod`).
    * Enable Analytics and Crashlytics in both projects.
    * For each project, register an Android and an iOS app, making sure to use the correct
      package/bundle IDs:
        * **Development:** `com.emberworks.rainvu.dev` (for both iOS and Android)
        * **Production:** `com.emberworks.rainvu` (for both iOS and Android)
    * Run the `flutterfire configure` commands below, replacing the `--project` value with your own
      Firebase project IDs. This will generate the necessary `firebase_options_*.dart` files and
      native configuration files.

   **Configure Development Firebase:**
   ```bash
   flutterfire configure \
     --project=<YOUR_DEV_PROJECT_ID> \
     --out=lib/firebase_options_dev.dart \
     --ios-bundle-id=com.emberworks.rainvu.dev \
     --android-package-name=com.emberworks.rainvu.dev \
     --ios-out=ios/Runner/Firebase/dev/GoogleService-Info.plist \
     --android-out=android/app/src/dev/google-services.json
   ```

   **Configure Production Firebase:**
   ```bash
   flutterfire configure \
     --project=<YOUR_PROD_PROJECT_ID> \
     --out=lib/firebase_options_prod.dart \
     --ios-bundle-id=com.emberworks.rainvu \
     --android-package-name=com.emberworks.rainvu \
     --ios-out=ios/Runner/Firebase/prod/GoogleService-Info.plist \
     --android-out=android/app/src/prod/google-services.json
   ```

4. **Set up Android App Signing:**
   To build a release version of the Android app, you need to configure an upload keystore.

    1. **Generate an Upload Keystore:**
       If you don't have one, create a keystore using the following `keytool` command. It will
       prompt you for passwords and other information. Remember the passwords you choose.
       ```bash
       keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
       ```

    2. **Move the Keystore:**
       Place the generated `upload-keystore.jks` file inside the `android/` directory of the
       project.

    3. **Configure Signing Properties:**
       In the `android/` directory, you will find a template file named `key.properties.example`.
        * Create a copy of this file and rename it to `key.properties`.
        * Open `key.properties` and fill in the passwords and alias you chose when generating the
          keystore.

       **Note:** The `key.properties` file is already listed in `.gitignore` and must **never** be
       committed to version control.

5. **Run code generation:**
   This project heavily relies on code generation. Run `build_runner` to generate the necessary
   files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## 💻 Development Workflow

The app is configured with two environments, called "flavors": `dev` and `prod`. You must specify
which flavor you want to run or build.

### Running the App (Flavors)

Ensure an emulator/simulator is running or a device is connected.

* **To run the `dev` flavor:**
  This version connects to your development Firebase project, has a `.dev` suffix in its application
  ID, and displays a "DEBUG" banner.
  ```bash
  flutter run --flavor dev -t lib/main_dev.dart
  ```

* **To run the `prod` flavor:**
  This version connects to your production Firebase project and behaves as the release version
  would.
  ```bash
  flutter run --flavor prod -t lib/main_prod.dart
  ```

### Building for Release

* **To build an Android App Bundle for production:**
  After completing the app signing setup, run:
  ```bash
  flutter build appbundle --flavor prod -t lib/main_prod.dart
  ```
* **To build an iOS App for production:**
  ```bash
  flutter build ipa --flavor prod -t lib/main_prod.dart
  ```

### Code Generation

If you modify any file that uses code generation (e.g., Riverpod providers, Freezed models, Drift
tables), you must re-run `build_runner`. For continuous development, use the `watch` command:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

This will automatically regenerate files whenever you save a change.

### Localization

The localization workflow involves several steps to keep the `app_en.arb` file clean and up-to-date.

1. **Remove unused keys (Optional)**:
   ```bash
   dart pub global run remove_unused_localizations_keys
   ```
2. **Sort keys and generate metadata (Optional)**:
   ```bash
   arb_utils generate-meta lib/l10n/app_en.arb
   arb_utils sort lib/l10n/app_en.arb
   ```
3. **Generate Dart localization files:**
   ```bash
   flutter gen-l10n
   ```

### Generating OSS Licenses

This project uses `dart_pubspec_licenses` to generate a list of open-source licenses for display
within the app. After adding or updating packages, run the following command:

```bash
dart run dart_pubspec_licenses:generate
```

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
