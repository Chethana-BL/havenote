import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/domain/entries/models/entry.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';

/// UI-only state for the Home screen (search).
class HomeFiltersState {
  const HomeFiltersState({this.query = '', this.showDeleted = false});

  final String query;
  final bool showDeleted;

  HomeFiltersState copyWith({String? query, bool? showDeleted}) {
    return HomeFiltersState(
      query: query ?? this.query,
      showDeleted: showDeleted ?? this.showDeleted,
    );
  }
}

/// StateNotifier to manage [HomeFiltersState].
class HomeFiltersController extends StateNotifier<HomeFiltersState> {
  HomeFiltersController() : super(const HomeFiltersState());

  void setQuery(String value) =>
      state = state.copyWith(query: value.trim().toLowerCase());

  void toggleShowDeleted() =>
      state = state.copyWith(showDeleted: !state.showDeleted);
}

/// Provider for [HomeFiltersController] and its state.
final homeFiltersProvider =
    StateNotifierProvider<HomeFiltersController, HomeFiltersState>(
      (ref) => HomeFiltersController(),
    );

/// Combines entries stream with UI filters into a single AsyncValue.
final filteredEntriesProvider = Provider.autoDispose<AsyncValue<List<Entry>>>((
  ref,
) {
  final filters = ref.watch(homeFiltersProvider);
  final entriesAsync = ref.watch(entriesStreamProvider(filters.showDeleted));

  return entriesAsync.whenData((entries) {
    final q = filters.query;
    if (q.isEmpty) return entries;

    // Simple search: title or body contains the query (case insensitive).
    // TODO(Owner): improve with tags, mood, date, etc.
    return entries
        .where((e) => ('${e.title}\n${e.body}').toLowerCase().contains(q))
        .toList(growable: false);
  });
});
