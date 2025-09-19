import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:havenote/domain/entries/i_entries_repository.dart';
import 'package:havenote/domain/entries/models/entry.dart';

class FirestoreEntriesRepository implements IEntriesRepository {
  FirestoreEntriesRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _entriesCollection() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('No user');
    }
    return _db.collection('users').doc(uid).collection('entries');
  }

  /// Stream of all entries
  @override
  Stream<List<Entry>> watchEntries() {
    final q = _entriesCollection().orderBy('createdAt', descending: true);
    return q.snapshots().map((s) {
      final list = s.docs.map(Entry.fromDoc).toList();
      return list;
    });
  }

  /// Stream of a single entry by id (nullable if the doc is missing/deleted).
  @override
  Stream<Entry?> watchEntry(String id) {
    return _entriesCollection()
        .doc(id)
        .snapshots()
        .map((d) => d.exists ? Entry.fromDoc(d) : null);
  }

  /// Creates a new entry and returns its id.
  @override
  Future<String> createEntry({
    required String title,
    required String body,
    List<String> tags = const [],
    String? mood,
  }) async {
    final ref = await _entriesCollection().add({
      'title': title,
      'body': body,
      'tags': tags,
      'mood': mood,
      'images': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'deletedAt': null,
    });
    return ref.id;
  }

  /// Updates an existing entry. `createdAt` is not modified; `updatedAt` is set to server timestamp.
  @override
  Future<void> updateEntry(Entry entry) async {
    final data =
        entry.toMap()
          ..remove('createdAt')
          ..['updatedAt'] = FieldValue.serverTimestamp();
    await _entriesCollection().doc(entry.id).update(data);
  }
}
