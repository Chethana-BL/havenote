import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/domain/entries/models/entry.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';

/// UI-only state for the [EditorScreen] (for mood, isSaving & picked images).
class EditorState {
  const EditorState({
    this.mood,
    this.isSaving = false,
    this.picked = const <File>[],
  });

  final String? mood;
  final bool isSaving;
  final List<File> picked;

  EditorState copyWith({String? mood, bool? isSaving, List<File>? picked}) {
    return EditorState(
      mood: mood ?? this.mood,
      isSaving: isSaving ?? this.isSaving,
      picked: picked ?? this.picked,
    );
  }
}

class EditorController extends StateNotifier<EditorState> {
  EditorController(this.ref) : super(const EditorState());

  final Ref ref;

  void setMood(String? value) => state = state.copyWith(mood: value);

  void addPicked(File file) =>
      state = state.copyWith(picked: [...state.picked, file]);

  void removePicked(File file) =>
      state = state.copyWith(
        picked: state.picked.where((f) => f.path != file.path).toList(),
      );

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

      // If editing, persist text changes (images handled below)
      if (entryId != null) {
        final entry = Entry(
          id: id,
          title: title,
          body: body,
          tags: tags,
          mood: state.mood,
          images: const [],
          // timestamps handled by repo; values here are ignored on update
        );
        await repo.updateEntry(entry);
      }

      // Upload newly picked images
      for (final f in state.picked) {
        await repo.uploadImage(entryId: id, file: f);
      }

      // Clear picked queue after successful save
      state = state.copyWith(picked: const []);
      return id;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

final editorControllerProvider =
    StateNotifierProvider.autoDispose<EditorController, EditorState>(
      (ref) => EditorController(ref),
    );
