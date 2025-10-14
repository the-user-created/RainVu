# RainWise 💧

RainWise is a modern Flutter app for farmers, gardeners, and weather enthusiasts to meticulously log
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
generation, and a feature-first architecture.

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
* `flutter_dotenv`: For managing environment variables (e.g., Firebase keys).
* `file_picker` & `url_launcher`: For file system and external link interactions.
* `build_runner`: To run all code generation tasks.

### Code Style & Linting

* `flutter_lints` and `riverpod_lint` are used with a strict ruleset in `analysis_options.yaml` to
  maintain code quality and consistency.

### Project Structure

The codebase follows a **feature-first** architecture to promote modularity and separation of
concerns.

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
└── main.dart         # App entry point
```

## 🚀 Getting Started

Follow these instructions to set up the project for local development.

### Prerequisites

* Flutter SDK (version specified in `pubspec.yaml`)
* An IDE like VS Code or Android Studio
* An Android Emulator or physical device
* An iOS Simulator or physical device (requires macOS with Xcode)

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/the-user-created/RainWise.git
   cd RainWise
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables:**
   This project uses Firebase for Analytics and Crashlytics, which requires API keys.

* Copy the example environment file:
  ```bash
  cp .env.example .env
  ```
* Open the newly created `.env` file and fill in your Firebase project configuration values. You can
  get these from your Firebase console.

4. **Run code generation:**
   This project heavily relies on code generation. Run the `build_runner` to generate the necessary
   files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Running the App

1. Ensure an emulator/simulator is running or a device is connected.
2. Run the app from your IDE or via the command line:
   ```bash
   flutter run
   ```

## 💻 Development Workflow

To keep development smooth and efficient, please follow these guidelines.

### Code Generation

If you modify any file that uses code generation (e.g., Riverpod providers, Freezed models, Drift
tables), you must re-run the `build_runner`. For continuous development, use the `watch` command:

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
