import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/domain/entries/models/entry.dart';
import 'package:havenote/features/entries/presentation/widgets/entry_card.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';
import 'package:havenote/l10n/app_localizations.dart';

/// A Dismissible widget that wraps an EntryCard and allows swipe-to-delete/restore.
class DismissibleEntry extends ConsumerWidget {
  const DismissibleEntry({
    super.key,
    required this.entry,
    required this.showDeleted,
  });

  final Entry entry;
  final bool showDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(entriesRepositoryProvider);
    final deleted = entry.deletedAt != null;
    final t = S.of(context);
    final cs = Theme.of(context).colorScheme;

    Future<bool> toggle() async {
      try {
        if (deleted) {
          await repo.restore(entry.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.snackRestored),
                action: SnackBarAction(
                  label: t.labelUndo,
                  onPressed: () => repo.softDelete(entry.id),
                ),
              ),
            );
          }
        } else {
          await repo.softDelete(entry.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.snackMovedToDeleted),
                action: SnackBarAction(
                  label: t.labelUndo,
                  onPressed: () => repo.restore(entry.id),
                ),
              ),
            );
          }
        }
        return !showDeleted; // keep in list if viewing deleted
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${t.errorGeneric}: $e')));
        }
        return false;
      }
    }

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(
        color: deleted ? Colors.green : cs.error,
        icon: deleted ? AppIcons.restore : AppIcons.delete,
        alignEnd: true,
      ),
      confirmDismiss: (_) => toggle(),
      child: EntryCard(entry: entry),
    );
  }
}

/// The background widget shown behind the Dismissible.
class _DismissBackground extends StatelessWidget {
  const _DismissBackground({
    required this.color,
    required this.icon,
    this.alignEnd = false,
  });

  final Color color;
  final IconData icon;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
      color: color.withValues(alpha: 0.15),
      child: Icon(icon, color: color, size: AppSizes.iconLG),
    );
  }
}
