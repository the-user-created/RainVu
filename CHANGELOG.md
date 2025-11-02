# Changelog

## [1.1.6] - 2025-11-02

### Changed

- **Legal**: Migrated the **Privacy Policy** and **Terms of Service** from in-app documents to our official website. This change ensures that the legal information is always up-to-date and easily accessible. The app's copyright has also been updated.
- **App Store**: Updated the internal App Store ID to ensure features like "Leave a Review" point to the correct listing.

## [1.1.5] - 2025-11-02

### Added

- **Accessibility**: Implemented comprehensive accessibility support for all charts, providing detailed, human-readable descriptions for screen reader users (e.g., VoiceOver, TalkBack).
- **Accessibility**: Added a tooltip to the expandable floating action button on the home screen for better clarity and accessibility.

### Changed

- **UI**: Refactored the analysis links on the **Insights** screen to use standard list tiles, improving layout consistency and tap targets.
- **Accessibility**: Improved semantic labels on the **YTD Summary** card, **Monthly Averages** card, and data entry forms to provide a clearer and more informative experience for screen reader users.
- **Accessibility**: The anomaly deviation threshold slider in **Settings** now provides live, spoken feedback for its selected value.

### Fixed

- **Accessibility**: Corrected a critical issue where the month and year pickers were not navigable with screen readers. They are now fully accessible and support value changes via accessibility actions.
- **Accessibility**: Fixed the screen reader pronunciation of the "JSON" export option to be read as individual letters.
- **Accessibility**: Improved the focus and readability of the legal agreement links during the onboarding process for screen reader users.

## [1.1.4] - 2025-10-27

### Fixed

- **Data Import**: Fixed an issue where CSV import could fail if a rain gauge name contained a comma.
- **Data Entry**: Resolved a display issue with the time picker when adding or editing rainfall entries, ensuring it works correctly with accessibility font sizes.
- **UI**: Corrected the font size of the title on the **Monthly Averages** screen for better visual consistency.

## [1.1.3] - 2025-10-19

### Changed

- **Reviews**: Implemented proper support for app store reviews on iOS and Android platforms.
- **App Sharing**: Updated the app sharing feature to use the store listing links for iOS and Android.
- **Help & Support**: Revised the help and support section to use new email address and provide links to the GitHub repository.

### Fixed

- **Splash**: Fixed a splash screen icon sizing issue on certain Android devices.

## [1.1.2] - 2025-10-17

### Fixed

- **Changelog**: Resolved a layout issue that could cause a crash on the changelog screen.

## [1.1.1] - 2025-10-17

### Added

- **Expandable FAB**: Introduced a new expandable floating action button on the home screen with quick access to **Log Rainfall** and **Add Gauge** actions.

### Changed

- **Manage Gauges**: Replaced the top bar add button with a floating action button for adding new gauges.
- **Gauge List**: Improved the layout of gauge list tiles with better button organization and clearer visual hierarchy.
- **Historical Averages**: Updated the calculation requirements for yearly rainfall averages to require **80% data coverage** for 5, 10, 15, and 20-year periods (previously required only 2 years of data).

### Fixed

- **iOS Keyboard**: Corrected an issue where the numpad action bar did not follow the system theme on iOS devices.

## [1.1.0] - 2025-10-16

### Added
- **Android Beta Release**: RainVu is ready for beta testing on Android.
- **Contextual Help**: Added info sheets on various screens to provide on-demand explanations of features and metrics.

### Changed
- **Data Import/Export**: Significantly improved the reliability of **CSV** and **JSON** imports with robust validation and clear, specific error messages for malformed data.
- **Data Entry**: Enhanced all data entry forms with improved validation (including preventing negative amounts), better focus management, and integrated keyboard actions on iOS for a smoother experience.
- **Insights Dashboard**: Improved the dashboard to gracefully handle cases with no data by showing informative empty state messages.
- **In-App Changelog**: Redesigned the changelog screen with a timeline layout and enhanced markdown support for `inline code` and [links](https://github.com/astraen-dev/RainVu).
- **UI Polish**: Implemented a smoother fade transition on app startup.

### Fixed
- **Seasonal Trends**: Resolved a crash that could occur on the Seasonal Trends screen.
- **Theme**: Eliminated a visual flicker on cards when switching between light and dark themes.

## [1.0.0] - 2025-10-15

### Added

- **Initial Beta Release**: First version of RainVu available for iOS beta testing.
- **Core Rainfall Logging**: Log daily rainfall entries for multiple custom rain gauges.
- **Data Visualization**: View month-to-date and year-to-date totals on the home screen.
- **Historical Analysis**: Explore historical data through various charts and comparison tools, including seasonal trends and year-over-year analysis.
- **Data Portability**: Import and export all your data via CSV and JSON formats.
- **On-Device Storage**: All data is stored privately and securely on your device, no internet connection required for core features.
