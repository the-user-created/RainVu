## **RainVu `CHANGELOG.md` Format Specification**

[Common Changelog](https://common-changelog.org/)

### **1. General Rules**

* **File Name:** The file must be named `CHANGELOG.md` and located in the project's root directory.
* **Encoding:** The file must use UTF-8 encoding.
* **Order:** Releases must be listed in reverse chronological order (newest release at the top).
* **Header:** The file must begin with the first-level heading `# Changelog`.

### **2. Release Block**

A release block represents all the changes for a specific version.

* **Format:** `## [{version}] - {YYYY-MM-DD}`
* **Heading Level:** Must be a second-level Markdown heading (`##`).
* **Version:** The version number must be enclosed in square brackets (e.g., `[1.2.0]`). It should
  adhere to Semantic Versioning.
* **Separator:** The version and date must be separated by a single space, a hyphen, and another
  single space (` - `).
* **Date:** The date must be in `YYYY-MM-DD` format.

**Examples:**

```markdown
## [1.2.0] - 2025-11-20
```

**Invalid Examples:**

```markdown
# Incorrect: Missing brackets around version

## 1.2.0 - 2024-08-15

# Incorrect: Missing hyphen separator

## [1.2.0] 2024-08-15

# Incorrect: Incorrect date format

## [1.2.0] - Oct 13, 2025
```

### **3. Change Group**

Within each release block, changes are grouped by category.

* **Format:** `### {Category}`
* **Heading Level:** Must be a third-level Markdown heading (`###`).
* **Allowed Categories:** The category must be one of the following (case-insensitive, but use this
  capitalization for consistency):
    * `Added`
    * `Changed`
    * `Fixed`
    * `Removed`
* **Order:** For readability, it's recommended to order the groups as: `Added`, `Changed`, `Fixed`,
  `Removed`.

**Example:**

```markdown
### Added
```

**Invalid Example:**

```markdown
# Incorrect: Not an allowed category

### Improved
```

### **4. Change Item**

Each item within a change group describes a single, notable change.

* **Format:** `- {Description}`
* **List Style:** Must be an unordered list item, starting with a hyphen and a single space (`- `).
* **Description:** A concise, single-line description of the change.
* **Markdown Support:** The following Markdown formats are supported and will be rendered in the
  app:
* **Bold Text:** Use double asterisks to emphasize text, e.g., `**important**`.
* **Inline Code:** Use single backticks to format text as code, e.g., `` `my_variable` ``.
* **Links:** Use standard Markdown link syntax, e.g., `[link text](https://example.com)`. The link
  will be tappable in the app.
* **Unsupported Formats:** Other Markdown formats like italics (`*text*`), blockquotes, etc., will
  be rendered as plain text.

**Examples:**

```markdown
- Added **new** 'What's New' screen to view app updates.
- Corrected a bug where the `total_rainfall` was miscalculated.
- Added a link to our issue tracker [#19](https://github.com/the-user-created/RainVu/issues/19).
```

**Invalid Examples:**

```markdown
# Incorrect: Uses bullet point instead of hyphen

* A new feature was added.

# Incorrect: Uses unsupported italics markdown

- _Improved_ the UI layout.
```

### **5. Complete Example**

This example demonstrates all the rules working together in a valid `CHANGELOG.md` file.

```markdown
# Changelog

## [1.2.0] - 2025-11-20

### Added

- New **'What's New'** screen to view app updates directly within the settings.
- Added 'Share RainVu' and 'Leave a Review' options to **support development**.

### Changed

- Restructured the Settings screen for **better organization**.
- The `user_preferences` table now includes a `themeMode` setting.

### Fixed

- Corrected a layout issue on the monthly breakdown chart. See
  issue [#19](https://github.com/the-user-created/RainVu/issues/19).
- Resolved a crash related to `null` values during data import.

## [1.1.0] - 2025-09-10

### Changed

- Upgraded **charting library**, which may affect the appearance of historical data.
- Improved performance of the Comparative Analysis tool.

### Fixed

- Resolved an issue where CSV export would fail for **very large datasets**.
- Fixed a bug causing the app to crash on startup for some **Android 14 devices**.

## [1.0.0] - 2025-10-15

### Added

- **Initial release** of RainVu!
```