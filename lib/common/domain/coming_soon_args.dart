// ignore_for_file: comment_references
/// A data class to hold arguments for the [ComingSoonScreen].
///
/// This allows for type-safe and structured data passing via GoRouter's `extra`
/// parameter, making the screen's content configurable from the call site.
class ComingSoonScreenArgs {
  const ComingSoonScreenArgs({
    this.pageTitle,
    this.headline,
    this.message,
  });
  /// The title to display in the [AppBar].
  final String? pageTitle;

  /// The main headline to display on the screen.
  final String? headline;

  /// The descriptive message to display below the headline.
  final String? message;
}
