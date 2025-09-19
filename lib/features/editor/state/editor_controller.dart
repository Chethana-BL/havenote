import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/domain/entries/models/entry.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';

/// UI-only state for the [EditorScreen] (mood + isSaving).
class EditorState {
  const EditorState({this.mood, this.isSaving = false});

  final String? mood;
  final bool isSaving;

  EditorState copyWith({String? mood, bool? isSaving}) {
    return EditorState(
      mood: mood ?? this.mood,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Controller for the [EditorScreen].
/// Handles mood state and saving (create or update).
class EditorController extends StateNotifier<EditorState> {
  EditorController(this.ref) : super(const EditorState());

  final Ref ref;

  void setMood(String? value) => state = state.copyWith(mood: value);

  Future<String> save({
    String? entryId,
    required String title,
    required String body,
    required List<String> tags,
  }) async {
    if (state.isSaving) return entryId ?? '';
    state = state.copyWith(isSaving: true);
    try {
      final repo = ref.read(entriesRepositoryProvider);

      // Create (no id) or reuse id
      final id =
          entryId ??
          await repo.createEntry(
            title: title,
            body: body,
            tags: tags,
            mood: state.mood,
          );

      // If editing, persist text changes
      if (entryId != null) {
        final entry = Entry(
          id: id,
          title: title,
          body: body,
          tags: tags,
          mood: state.mood,
          // timestamps handled by repo
        );
        await repo.updateEntry(entry);
      }

      return id;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

/// Provider for the [EditorController].
/// Auto-disposes when the Editor screen is popped.
final editorControllerProvider =
    StateNotifierProvider.autoDispose<EditorController, EditorState>(
      (ref) => EditorController(ref),
    );
