import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/settings/application/support_provider.dart";
import "package:rain_wise/features/settings/domain/support_ticket.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";

/// A bottom sheet for submitting a support ticket or feedback.
class TicketSheet extends ConsumerStatefulWidget {
  const TicketSheet({
    super.key,
    this.initialCategory,
  });

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

    setState(() => _isLoading = true);
    try {
      final String contactEmail = _emailController.text.trim();
      await ref.read(supportServiceProvider.notifier).submitTicket(
            category: _selectedCategory!,
            description: _descriptionController.text.trim(),
            contactEmail: contactEmail.isNotEmpty ? contactEmail : null,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Thank you! Your feedback has been submitted."),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    InputDecoration buildInputDecoration(
      final String labelText, [
      final String? hintText,
    ]) =>
        InputDecoration(
          labelText: labelText,
          hintText: hintText,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.alternate),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.alternate),
          ),
          filled: true,
          fillColor: theme.secondaryBackground,
        );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Report an Issue / Send Feedback",
              textAlign: TextAlign.center,
              style: theme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Your feedback helps us improve RainWise. Please describe the issue or share your thoughts.",
              textAlign: TextAlign.center,
              style: theme.bodyMedium,
            ),
            const SizedBox(height: 24),
            AppDropdownFormField<TicketCategory>(
              value: _selectedCategory,
              hintText: "Select Category",
              items: TicketCategory.values
                  .map(
                    (final category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.displayName),
                    ),
                  )
                  .toList(),
              onChanged: (final value) =>
                  setState(() => _selectedCategory = value),
              validator: (final value) =>
                  value == null ? "Please select a category" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: buildInputDecoration(
                "Description",
                "Describe the issue or your feedback here...",
              ),
              minLines: 4,
              maxLines: 8,
              validator: (final value) =>
                  (value == null || value.trim().isEmpty)
                      ? "Please enter a description"
                      : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: buildInputDecoration("Your Email (Optional)"),
              keyboardType: TextInputType.emailAddress,
              validator: (final value) {
                if (value != null && value.isNotEmpty && !value.contains("@")) {
                  return "Please enter a valid email address";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 12),
                AppButton(
                  onPressed: _isLoading ? null : _submit,
                  label: "Submit",
                  isLoading: _isLoading,
                  size: AppButtonSize.small,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
