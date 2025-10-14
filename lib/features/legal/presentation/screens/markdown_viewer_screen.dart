import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_markdown_plus/flutter_markdown_plus.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/legal/application/legal_providers.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/placeholders.dart";
import "package:shimmer/shimmer.dart";

class MarkdownViewerScreen extends ConsumerWidget {
  const MarkdownViewerScreen({
    required this.title,
    required this.filePath,
    super.key,
  });

  final String title;
  final String filePath;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<String> markdownAsync = ref.watch(
      documentContentProvider(filePath),
    );

    return Scaffold(
      appBar: AppBar(title: Text(title, style: theme.textTheme.titleLarge)),
      body: SafeArea(
        child: markdownAsync.when(
          loading: () => const _LoadingShimmer(),
          error: (final err, final stack) {
            FirebaseCrashlytics.instance.recordError(
              err,
              stack,
              reason: "Failed to load markdown file: $filePath",
            );
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.markdownLoadingError(err.toString()),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          data: (final content) => Scrollbar(
            thumbVisibility: true,
            child: Markdown(data: content, selectable: true),
          ),
        ),
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinePlaceholder(height: 24, width: 200),
            SizedBox(height: 24),
            LinePlaceholder(height: 14),
            SizedBox(height: 8),
            LinePlaceholder(height: 14),
            SizedBox(height: 8),
            LinePlaceholder(height: 14, width: 250),
            SizedBox(height: 24),
            LinePlaceholder(height: 20, width: 150),
            SizedBox(height: 16),
            LinePlaceholder(height: 14),
            SizedBox(height: 8),
            LinePlaceholder(height: 14, width: 280),
            SizedBox(height: 24),
            LinePlaceholder(height: 14),
            SizedBox(height: 8),
            LinePlaceholder(height: 14),
            SizedBox(height: 8),
            LinePlaceholder(height: 14, width: 220),
          ],
        ),
      ),
    );
  }
}
