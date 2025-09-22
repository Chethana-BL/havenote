import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';
import 'package:havenote/l10n/app_localizations.dart';

/// An IconButton that performs soft-delete or restore action on an entry.
class SoftDeleteRestoreAction extends ConsumerWidget {
  const SoftDeleteRestoreAction({
    super.key,
    required this.entryId,
    required this.deleted,
  });

  final String entryId;
  final bool deleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = S.of(context);
    final repo = ref.read(entriesRepositoryProvider);

    return IconButton(
      icon: Icon(deleted ? AppIcons.restore : AppIcons.delete),
      tooltip: deleted ? t.tooltipRestore : t.tooltipDelete,
      onPressed: () async {
        try {
          if (deleted) {
            await repo.restore(entryId);
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(t.snackRestored)));
            }
          } else {
            await repo.softDelete(entryId);
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(t.snackMovedToDeleted)));
            }
          }
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${t.errorGeneric}: $e')));
        }
      },
    );
  }
}
