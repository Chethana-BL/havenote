import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/data/entries/firestore_entries_repository.dart';
import 'package:havenote/domain/entries/i_entries_repository.dart';
import 'package:havenote/domain/entries/models/entry.dart';

final entriesRepositoryProvider = Provider<IEntriesRepository>((ref) {
  return FirestoreEntriesRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
    FirebaseStorage.instance,
  );
});

/// Stream of entries
final entriesStreamProvider = StreamProvider.autoDispose<List<Entry>>((ref) {
  final repo = ref.watch(entriesRepositoryProvider);
  return repo.watchEntries();
});

/// Single entry by id (nullable if the doc is missing/deleted).
final entryStreamProvider = StreamProvider.autoDispose.family<Entry?, String>((
  ref,
  id,
) {
  final repo = ref.watch(entriesRepositoryProvider);
  return repo.watchEntry(id);
});

/// Resolves a Firebase Storage fullPath to a download URL.
final storageDownloadUrlProvider = FutureProvider.family<String, String>((
  ref,
  path,
) async {
  final refStorage = FirebaseStorage.instance.ref(path);
  return refStorage.getDownloadURL();
});
