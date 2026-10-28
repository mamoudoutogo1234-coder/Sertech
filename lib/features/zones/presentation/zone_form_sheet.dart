import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../domain/models/zone.dart';
import '../../../l10n/app_localizations.dart';
import '../application/zones_providers.dart';

/// Formulaire de création / édition d'une zone, en feuille modale.
///
/// Retourne la zone enregistrée, ou `null` si l'utilisateur annule.
Future<Zone?> showZoneFormSheet(BuildContext context, {Zone? zone}) {
  return showModalBottomSheet<Zone>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _ZoneFormSheet(zone: zone),
  );
}

class _ZoneFormSheet extends ConsumerStatefulWidget {
  final Zone? zone;

  const _ZoneFormSheet({this.zone});

  @override
  ConsumerState<_ZoneFormSheet> createState() => _ZoneFormSheetState();
}

class _ZoneFormSheetState extends ConsumerState<_ZoneFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late bool _isActive;

  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.zone != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.zone?.name ?? '');
    _description = TextEditingController(text: widget.zone?.description ?? '');
    _isActive = widget.zone?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final actions = ref.read(zoneActionsProvider);
      final Zone saved;
      if (_isEditing) {
        saved = await actions.update(
          widget.zone!.copyWith(
            name: _name.text.trim(),
            description: _normalize(_description.text),
            isActive: _isActive,
          ),
        );
      } else {
        saved = await actions.create(
          name: _name.text,
          description: _description.text,
          isActive: _isActive,
        );
      }
      if (mounted) Navigator.of(context).pop(saved);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _normalize(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final insets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.only(bottom: insets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s20,
          AppSpacing.s20,
          AppSpacing.s24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing ? l10n.editZone : l10n.createZone,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.close,
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              TextFormField(
                controller: _name,
                autofocus: !_isEditing,
                textInputAction: TextInputAction.next,
                maxLength: 80,
                decoration: InputDecoration(
                  labelText: l10n.zoneName,
                  hintText: l10n.zoneNameHint,
                  counterText: '',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return l10n.fieldRequired;
                  if (text.length > 80) return l10n.nameTooLong;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _description,
                minLines: 2,
                maxLines: 4,
                maxLength: 240,
                decoration: InputDecoration(
                  labelText: l10n.zoneDescription,
                  hintText: l10n.zoneDescriptionHint,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              SwitchListTile(
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
                title: Text(l10n.zoneIsActive),
                contentPadding: EdgeInsets.zero,
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.s12),
                AppErrorView(
                  message: l10n.actionFailed,
                  technicalDetails: _error,
                  retryLabel: l10n.retry,
                  onRetry: () => setState(() => _error = null),
                ),
              ],
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
