import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/settings/application/support_provider.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

// TODO: should be updated to use choice chips for category selection and change text based on which button the user used to get here.

/// A bottom sheet for submitting a support ticket or feedback.
class TicketSheet extends ConsumerStatefulWidget {
  const TicketSheet({super.key, this.initialCategory});

  final TicketCategory? initialCategory;

  @override
  ConsumerState<TicketSheet> createState() => _TicketSheetState();
}

class _TicketSheetState extends ConsumerState<TicketSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();

  TicketCategory? _selectedCategory;
  bool _isLoading = false;

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
            category: _selectedCategory!,
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

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InteractiveSheet(
      title: Text(l10n.ticketSheetTitle),
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
            Text(l10n.ticketSheetDescription, style: textTheme.bodyMedium),
            const SizedBox(height: 24),
            AppDropdownFormField<TicketCategory>(
              value: _selectedCategory,
              hintText: l10n.ticketSheetCategoryHint,
              items: TicketCategory.values
                  .map(
                    (final category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.displayName(l10n)),
                    ),
                  )
                  .toList(),
              onChanged: (final value) =>
                  setState(() => _selectedCategory = value),
              validator: (final value) =>
                  value == null ? l10n.ticketSheetCategoryValidation : null,
            ),
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
