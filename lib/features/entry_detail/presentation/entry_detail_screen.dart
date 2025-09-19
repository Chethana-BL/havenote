import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';
import 'package:havenote/features/entry_detail/presentation/widgets/entry_header.dart';
import 'package:havenote/l10n/app_localizations.dart';

class EntryDetailScreen extends ConsumerWidget {
  const EntryDetailScreen({super.key, required this.entryId});
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = S.of(context);
    final entryAsync = ref.watch(entryStreamProvider(entryId));

    return entryAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (e, _) => Scaffold(
            appBar: AppBar(title: Text(t.labelEntry)),
            body: Center(child: Text('${t.errorGeneric}: $e')),
          ),
      data: (entry) {
        if (entry == null) {
          return Scaffold(
            appBar: AppBar(title: Text(t.labelEntry)),
            body: Center(child: Text(t.emptyHomeBody)),
          );
        }

        final deleted = entry.deletedAt != null;

        return Scaffold(
          appBar: AppBar(
            title: Text(t.labelEntry),
            actions: [
              IconButton(
                icon: const Icon(AppIcons.edit),
                tooltip: t.tooltipEdit,
                onPressed:
                    deleted
                        ? null
                        : () => context.push(AppRoute.editorEdit(entry.id)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSizes.padding),
            children: [
              // Header: Title + Mood + Tags
              EntryHeader(entry: entry),
              const SizedBox(height: AppSizes.space),

              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.padding),
                  child: SelectableText(
                    entry.body,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
