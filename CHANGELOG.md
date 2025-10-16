# Changelog

## [1.1.0] - 2025-10-16

### Added
- **Android Beta Release**: RainVu is now available for beta testing on Android.
- **Contextual Help**: Added info sheets on various screens to provide on-demand explanations of features and metrics.

### Changed
- **Data Import/Export**: Significantly improved the reliability of **CSV** and **JSON** imports with robust validation and clear, specific error messages for malformed data.
- **Data Entry**: Enhanced all data entry forms with improved validation (including preventing negative amounts), better focus management, and integrated keyboard actions on iOS for a smoother experience.
- **Insights Dashboard**: Improved the dashboard to gracefully handle cases with no data by showing informative empty state messages.
- **In-App Changelog**: Redesigned the changelog screen with a timeline layout and enhanced markdown support for `inline code` and [links](https://github.com/the-user-created/RainVu).
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
