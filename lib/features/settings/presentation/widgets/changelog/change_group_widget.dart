import "package:flutter/material.dart";
import "package:rain_wise/features/settings/domain/changelog_entry.dart";
import "package:rain_wise/features/settings/presentation/widgets/changelog/change_item_card.dart";

class ChangeGroupWidget extends StatelessWidget {
  const ChangeGroupWidget({required this.group, super.key});

  final ChangeGroup group;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChangeGroupHeader(
          title: group.category.title,
          color: group.category.color,
        ),
        const SizedBox(height: 8),
        ...group.items.map(
          (final item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ChangeItemCard(item: item),
          ),
        ),
      ],
    ),
  );
}

class _ChangeGroupHeader extends StatelessWidget {
  const _ChangeGroupHeader({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
