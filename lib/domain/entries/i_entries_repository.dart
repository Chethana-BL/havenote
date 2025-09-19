import 'package:havenote/domain/entries/models/entry.dart';

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
}
