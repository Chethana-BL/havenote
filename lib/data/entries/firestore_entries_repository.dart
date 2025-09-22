import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/domain/entries/i_entries_repository.dart';
import 'package:havenote/domain/entries/models/entry.dart';
import 'package:havenote/domain/entries/models/entry_image.dart';
import 'package:uuid/uuid.dart';

/// Firestore implementation of [IEntriesRepository].
/// Each user has their own entries subcollection under /users/{uid}/entries.
/// Images are stored in Firebase Storage under /users/{uid}/entries/{entryId}/{imageId}.jpg

class FirestoreEntriesRepository implements IEntriesRepository {
  FirestoreEntriesRepository(this._db, this._auth, this._storage);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  /// Returns the entries collection for the current user.
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
    return q.snapshots().map((s) => s.docs.map(Entry.fromDoc).toList());
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
    final data = <String, dynamic>{
      'title': entry.title,
      'body': entry.body,
      'tags': entry.tags,
      'mood': entry.mood,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _entriesCollection().doc(entry.id).update(data);
  }

  /// Uploads an image file to Firebase Storage and adds its metadata to the entry.
  @override
  Future<EntryImage> uploadImage({
    required String entryId,
    required File file,
  }) async {
    final uid = _auth.currentUser!.uid;
    final id = const Uuid().v4();
    final imagePath = 'users/$uid/entries/$entryId/$id.jpg';
    final ref = _storage.ref(imagePath);

    try {
      // Upload file
      await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));

      // Create image metadata
      final img = EntryImage(path: imagePath);

      // Add image metadata to entry
      await _entriesCollection().doc(entryId).update({
        'images': FieldValue.arrayUnion([img.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return img;
    } catch (e) {
      // If upload or Firestore update fails, try to delete the uploaded file.
      Log.e('Error uploading image for $entryId: $e');
      try {
        await ref.delete();
      } catch (_) {}
      rethrow;
    }
  }

  @override
  Future<void> removeImage({
    required String entryId,
    required String imagePath,
  }) async {
    // Delete from Storage first
    await _storage.ref(imagePath).delete();

    // Remove image metadata from entry
    await _entriesCollection().doc(entryId).update({
      'images': FieldValue.arrayRemove([EntryImage(path: imagePath).toMap()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
