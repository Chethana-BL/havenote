import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/features/entries/presentation/widgets/entry_card.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';
import 'package:havenote/features/home/presentation/widgets/empty_states.dart';
import 'package:havenote/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = S.of(context);
    final entriesAsync = ref.watch(entriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.settings),
            onPressed: () => context.push(AppRoute.settings()),
          ),
        ],
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${t.errorGeneric}: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return const EmptyHomeState();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.padding),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.space),
            itemBuilder: (_, i) {
              final entry = entries[i];
              return EntryCard(entry: entry);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoute.editorNew()),
        child: const Icon(AppIcons.add, size: AppSizes.icon),
      ),
    );
  }
}
