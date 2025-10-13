## **RainWise `CHANGELOG.md` Format Specification**

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
* **Markdown Support:**
    * **Supported:** You can use `**bold**` text by enclosing it in double asterisks. This is the
      only supported Markdown format.
    * **Not Supported:** Italics (`*text*`), links (`[text](url)`), inline code (`code`), etc., will
      be rendered as plain text.
* **Stripped Content:** Any text at the very end of a line that is enclosed in parentheses (e.g.,
  `(by @user)`, `(#123)`) will be **completely removed** by the parser. Do not use parentheses for
  descriptive text at the end of a line.

**Examples:**

```markdown
- Added **new** 'What's New' screen to view app updates.
- Corrected a **minor layout issue** on the monthly breakdown chart.
```

**Invalid Examples:**

```markdown
# Incorrect: Uses bullet point instead of hyphen

* A new feature was added.

# Incorrect: Uses parentheses at the end, which will be stripped

- Fixed a bug. (This was a critical issue)

# The app will only display: "Fixed a bug."
```

### **5. Complete Example**

This example demonstrates all the rules working together in a valid `CHANGELOG.md` file.

```markdown
# Changelog

## [1.2.0] - 2025-11-20

### Added

- New **'What's New'** screen to view app updates directly within the settings.
- Added 'Share RainWise' and 'Leave a Review' options to **support development**.

### Changed

- Restructured Settings screen for **better organization**.
- Moved App Reset functionality into the 'Help & Feedback' screen.

### Fixed

- Corrected a minor layout issue on the **monthly breakdown chart**.

## [1.1.0] - 2025-09-10

### Changed

- Upgraded **charting library**, which may affect the appearance of historical data.
- Improved performance of the Comparative Analysis tool.

### Fixed

- Resolved an issue where CSV export would fail for **very large datasets**.
- Fixed a bug causing the app to crash on startup for some **Android 14 devices**.

## [1.0.0] - 2025-10-15

### Added

- **Initial release** of RainWise!
```