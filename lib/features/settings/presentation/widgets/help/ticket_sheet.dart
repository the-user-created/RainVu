import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/settings/application/support_provider.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_choice_chips.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

/// A bottom sheet for submitting a support ticket or feedback.
class TicketSheet extends ConsumerStatefulWidget {
  const TicketSheet({required this.initialCategory, super.key});

  final TicketCategory initialCategory;

  @override
  ConsumerState<TicketSheet> createState() => _TicketSheetState();
}

class _TicketSheetState extends ConsumerState<TicketSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();

  late TicketCategory _selectedCategory;
  bool _isLoading = false;
  bool _categoryHasError = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final AppLocalizations l10n = AppLocalizations.of(context);

    setState(() => _isLoading = true);
    try {
      final String contactEmail = _emailController.text.trim();
      await ref
          .read(supportServiceProvider.notifier)
          .submitTicket(
            category: _selectedCategory,
            description: _descriptionController.text.trim(),
            contactEmail: contactEmail.isNotEmpty ? contactEmail : null,
          );

      showSnackbar(l10n.ticketSheetSuccessMessage, type: MessageType.success);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      showSnackbar(l10n.ticketSheetErrorMessage(e), type: MessageType.error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  ({String title, String description}) _getHeaderForCategory(
    final AppLocalizations l10n,
  ) {
    switch (_selectedCategory) {
      case TicketCategory.bugReport:
        return (
          title: l10n.helpReportBugTitle,
          description: l10n.helpReportBugSubtitle,
        );
      case TicketCategory.featureRequest:
        return (
          title: l10n.helpSuggestIdeaTitle,
          description: l10n.helpSuggestIdeaSubtitle,
        );
      case TicketCategory.generalFeedback:
      case TicketCategory.other:
        return (
          title: _selectedCategory.displayName(l10n),
          description: l10n.ticketSheetDescription,
        );
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    final ({String title, String description}) header = _getHeaderForCategory(
      l10n,
    );

    return InteractiveSheet(
      title: Text(header.title),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancelButtonLabel),
        ),
        const SizedBox(width: 12),
        AppButton(
          onPressed: _isLoading ? null : _submit,
          label: l10n.ticketSheetSubmitButton,
          isLoading: _isLoading,
          size: AppButtonSize.small,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(header.description, style: textTheme.bodyMedium),
            const SizedBox(height: 24),
            AppChoiceChips<TicketCategory>(
              selectedValue: _selectedCategory,
              onSelected: (final value) {
                setState(() {
                  _selectedCategory = value;
                  if (_categoryHasError) {
                    _categoryHasError = false;
                  }
                });
              },
              options: TicketCategory.values
                  .map(
                    (final category) => ChipOption(
                      value: category,
                      label: category.displayName(l10n),
                    ),
                  )
                  .toList(),
            ),
            if (_categoryHasError) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  l10n.ticketSheetCategoryValidation,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.ticketSheetDescriptionLabel,
                hintText: l10n.ticketSheetDescriptionHint,
                alignLabelWithHint: true,
                filled: true,
                fillColor: colorScheme.surface,
              ),
              minLines: 4,
              maxLines: 8,
              validator: (final value) =>
                  (value == null || value.trim().isEmpty)
                  ? l10n.ticketSheetDescriptionValidation
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: l10n.ticketSheetEmailLabel,
                alignLabelWithHint: true,
                filled: true,
                fillColor: colorScheme.surface,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (final value) {
                if (value != null && value.isNotEmpty && !value.contains("@")) {
                  return l10n.ticketSheetEmailValidation;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
