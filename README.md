# RainWise - Advanced Rainfall Tracking & Analytics

**RainWise** is a comprehensive mobile application built with Flutter, designed for farmers,
gardeners, and weather enthusiasts to meticulously log, track, and analyze rainfall data from
multiple custom rain gauges.

## Table of Contents

- [About The Project](#about-the-project)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Structure Overview](#project-structure-overview)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Setup](#setup)
    - [Environment Variables](#environment-variables)
    - [Firebase Setup](#firebase-setup)
- [Running the App](#running-the-app)
- [Build Process](#build-process)
- [Development Workflow](#development-workflow)
- [Code Style & Linting](#code-style--linting)

## About The Project

In agriculture, gardening, and environmental monitoring, accurate rainfall data is crucial for
making informed decisions. RainWise provides a powerful, user-friendly platform to replace manual
notebooks and spreadsheets, offering instant insights and historical analysis at your fingertips.

**What does RainWise do?**

* **Lets you log every drop:** Easily record rainfall measurements from any number of rain gauges
  you own.
* **Shows you the big picture:** Visualize your data through intuitive charts and an interactive map
  to understand trends and patterns.
* **Helps you analyze the past:** Dive deep into historical data with monthly breakdowns, seasonal
  pattern analysis, and year-over-year comparisons.
* **Puts you in control:** Manage your rain gauges, export your data for external use, and set up
  custom notifications to stay on top of your data logging.

Our mission is to empower you with the tools to transform raw rainfall data into actionable
intelligence, turning guesswork into data-driven strategy.

## Key Features

* 📊 **Log & Manage Data Effortlessly**: Quickly log rainfall entries with amount, date, and time.
  Add, edit, and manage multiple rain gauges, each with an optional location for map-based
  visualization.

* 📈 **Powerful Insights & Analytics**: A dedicated dashboard to uncover trends. Analyze key metrics
  like MTD and YTD totals, explore monthly trends, compare yearly data side-by-side, and identify
  seasonal patterns and anomalies.

* 🗺️ **Interactive Rainfall Map**: Visualize recent rainfall entries on an interactive map. See
  where it rained the most and get a geographical overview of your data points.

* 📤 **Data Export & Import**: Take control of your data by exporting it to CSV, PDF, or JSON formats
  for use in other applications. Easily import data from previous records.

* 🔔 **Customizable Notifications**: Stay consistent with your data logging.

* 🔒 **Secure & Private**: Your data is your own, stored locally on your device.

## Tech Stack

* **Framework**: Flutter
* **Language**: Dart
* **State Management**: Riverpod (with `riverpod_generator`)
* **Routing**: GoRouter
* **Backend & Cloud Services**: Firebase
    * **Analytics**: Firebase Analytics[
    * **Crash Reporting**: Firebase Crashlytics]()
* **Local Storage**:
    * `shared_preferences` for app settings and user preferences.
    * (Future) Local database like `Isar` or `Drift` for robust offline capabilities.
* **UI & Charting**:
    * `fl_chart` / `syncfusion_flutter_charts`: For detailed and interactive data visualizations.
    * `flutter_animate`: For declarative, easy-to-use animations.
    * `google_maps_flutter`: For the interactive map feature.
* **Utilities & Tooling**:
    * `freezed`, `json_serializable`: For robust, immutable data models.
    * `intl`: For date and number formatting.
    * `flutter_dotenv`: For managing environment variables.
    * `url_launcher`: For opening external links.
    * `file_picker`: For data import functionality.
* **Linting**: `flutter_lints` and `riverpod_lint` with a comprehensive ruleset.

For a full list of dependencies, see the [`pubspec.yaml`](pubspec.yaml) file.

## Project Structure Overview

The project follows a **feature-first** architecture, promoting modularity and separation of
concerns. This structure is a work-in-progress.

```markdown
.
├── android/ # Android native project
├── ios/ # iOS native project
├── assets/ # Static assets (images, fonts, jsons, etc.)
├── lib/ # Main Flutter application code
│ ├── core/ # Shared app-wide logic and services
│ │ ├── config/ # AppSettings model and notifier
│ │ ├── data/ # Shared data sources (Firebase, Local DB)
│ │ ├── navigation/ # GoRouter setup, routes, and navigation shell
│ │ ├── services/ # Cross-cutting services (e.g., connectivity)
│ │ ├── ui/ # App shell with bottom navigation
│ │ └── utils/ # Shared utilities and extensions
│ ├── features/ # Feature-specific modules
│ │ ├── [feature_name]/ # Each feature is a self-contained unit
│ │ │ ├── application/ # Business logic, services, Riverpod providers
│ │ │ ├── data/ # Repositories and data sources for the feature
│ │ │ ├── domain/ # Models, entities, and contracts (e.g., using Freezed)
│ │ │ └── presentation/ # UI (screens, widgets, animations)
│ ├── main.dart # App entry point
│ └── shared/ # Widgets and models shared by multiple features
├── .env.example # Template for environment variables
├── pubspec.yaml # Flutter dependencies and project metadata
└── README.md # This file
```

## Getting Started

Follow these instructions to set up the project locally for development.

### Prerequisites

* Flutter SDK (Channel stable, version compatible with `sdk` in `pubspec.yaml`)
* An IDE like VS Code (with Flutter extension) or Android Studio.
* An Android Emulator or physical device.
* An iOS Simulator or physical device (requires macOS with Xcode).

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/the-user-created/RainWise.git
   cd RainWise
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

### Environment Variables

This project uses `flutter_dotenv` to manage environment variables for Firebase and other services.

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
2. Open the `.env` file and fill in the required Firebase API keys and configuration values. You can
   get these from your Firebase project console.
   ```env
   # .env
   # Android
   androidApiKey="AIza..."
   androidAppId="1:..."
   # iOS
   iosApiKey="AIza..."
   iosAppId="1:..."
   # Common
   messagingSenderId="..."
   projectId="..."
   storageBucket="..."
   measurementId="G-..."
   ```

**Do NOT commit the `.env` file to the repository.**

## Running the App

1. Ensure an emulator/simulator is running or a physical device is connected.
2. Run the app from your IDE or using the command line:
   ```bash
   flutter run
   ```

## Build Process

* **Code Generation (Riverpod, Freezed, etc.):**
  If you make changes to files that use code generation (e.g., Riverpod providers with `@riverpod`,
  models with `@freezed`), run the build runner:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
  For continuous generation during development:
  ```bash
  dart run build_runner watch --delete-conflicting-outputs
  ```

* **Building APKs/App Bundles:**
    * For a debug APK: `flutter build apk --debug`
    * For a release App Bundle: `flutter build appbundle --release` (ensure you have set up signing
      configurations in `android/app/build.gradle`).

## Development Workflow

We use a simple branching model:

* `main`: Represents the latest stable, production-ready version.
* `develop`: The primary branch for ongoing development and integration of new features. All feature
  branches are merged into `develop`.
* **Feature Branches**: For new features or bug fixes, create a branch from `develop`.
    * Naming: `feat/descriptive-name` or `fix/issue-description`.

All tasks, bugs, and feature requests are tracked as **Issues** on GitHub. Create **Pull Requests (
PRs)** from feature branches to merge into `develop`.

## Code Style & Linting

* This project uses a strict set of linting rules defined in `analysis_options.yaml`, leveraging
  `flutter_lints` and `riverpod_lint`.
* Format your code using `dart format .` before committing.
* Run `flutter analyze` to check for any linting issues.
* Adhere to the principles of Effective Dart.

## Performance & Optimizations

This project is built with a strong focus on performance to ensure a smooth, responsive user
experience. We adhere to Flutter's best practices for building efficient applications.

### Core Principles

* **Targeting 60-120fps**: The application is architected to achieve a smooth 60fps on standard
  devices and 120fps on capable hardware.
* **Profile Mode Profiling**: All performance testing and analysis are conducted on a **physical
  device** in **profile mode**. Debug mode builds are not representative of final release
  performance due to added overhead for hot reload and debugging checks.

### Efficient Widget Building

We follow key principles to ensure widget build times are minimal:

* **Minimizing `build()` Cost**: Expensive or repetitive work is kept out of `build()` methods.
  Large widgets are decomposed into smaller, specialized widgets to localize rebuilds via
  `setState()`.
* **`const` Widgets**: `const` constructors are used extensively. This allows Flutter to cache
  widget instances and short-circuit the rebuild process, significantly boosting performance.
* **Lazy Loading Lists & Grids**: For long or infinite lists, we use builder constructors (e.g.,
  `ListView.builder`) to ensure only visible items are built and rendered, conserving CPU and memory
  resources.

### Rendering Optimizations

To maintain a smooth raster thread and avoid GPU-related jank, we focus on:

* **Impeller by Default**: We leverage Impeller, Flutter's modern rendering engine. It pre-compiles
  a simpler, smaller set of shaders during the engine build, eliminating runtime shader compilation
  jank, which is often a source of stutter on the first run of an animation.
* **Avoiding Costly Operations**: We use expensive operations like `Opacity`, clipping, and methods
  that trigger `saveLayer()` sparingly. These can create offscreen buffers and disrupt the GPU's
  rendering pipeline. When possible, effects like opacity are applied directly to individual
  elements (e.g., using a semi-transparent color) rather than wrapping a large widget subtree.

### Concurrency with Isolates

For heavy computations that could block the main UI thread and cause jank—such as parsing large data
files or intensive data processing—we offload the work to background **isolates**.

* Isolates run in their own memory space, allowing them to perform complex tasks concurrently
  without freezing the UI. We use the simple `Isolate.run()` or `compute()` functions for one-off
  background tasks.

### App Size Management

A small app size is crucial for faster downloads and a better user onboarding experience.

* **Size Analysis**: We regularly analyze our app's composition using the
  `flutter build --analyze-size` command and the **App Size tool** in DevTools.
* **Asset Optimization**: All assets, especially images, are compressed to reduce their size without
  significant quality loss. Unused resources are diligently removed.
* **Deferred Components**: For features or large assets not required at startup, we plan to use
  deferred components. This allows parts of the app to be downloaded on-demand, reducing the initial
  install size.

### Profiling Tools

We use **Flutter DevTools** as our primary tool for performance analysis.

* The **Performance View** helps diagnose jank by providing a frame-by-frame analysis of the UI and
  raster threads.
* The **Performance Overlay** gives a quick, in-app glance at thread performance.
* The **Widget Rebuild Profiler** in the IDE helps us identify and eliminate unnecessary widget
  rebuilds.
