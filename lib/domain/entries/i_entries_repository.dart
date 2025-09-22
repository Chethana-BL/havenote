import 'dart:io';
import 'package:havenote/domain/entries/models/entry.dart';
import 'package:havenote/domain/entries/models/entry_image.dart';

abstract class IEntriesRepository {
  /// Stream of all entries
  Stream<List<Entry>> watchEntries();

  /// Stream of a single entry by id (nullable if the doc is missing/deleted).
  Stream<Entry?> watchEntry(String id);

  /// Creates a new entry and returns its id.
  Future<String> createEntry({
    required String title,
    required String body,
    List<String> tags = const [],
    String? mood,
  });

  /// Partial or full update; repo guarantees `updatedAt` server timestamp.
  Future<void> updateEntry(Entry entry);

  /// Uploads an image file to Firebase Storage and adds its metadata to the entry.
  Future<EntryImage> uploadImage({required String entryId, required File file});

  /// Removes image metadata from the entry and deletes the file from Storage.
  Future<void> removeImage({
    required String entryId,
    required String imagePath,
  });
}
