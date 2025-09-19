import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  Entry({
    required this.id,
    required this.title,
    required this.body,
    this.tags = const [],
    this.mood,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final String? mood;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'tags': tags,
      'mood': mood,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  static Entry fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final created = data['createdAt'];
    final updated = data['updatedAt'];
    final deleted = data['deletedAt'];

    return Entry(
      id: doc.id,
      title: (data['title'] as String? ?? '').trim(),
      body: (data['body'] as String? ?? '').trim(),
      tags: (data['tags'] as List<dynamic>? ?? []).cast<String>(),
      mood: data['mood'] as String?,
      createdAt: created is Timestamp ? created.toDate() : null,
      updatedAt: updated is Timestamp ? updated.toDate() : null,
      deletedAt: deleted is Timestamp ? deleted.toDate() : null,
    );
  }

  Entry copyWith({
    String? title,
    String? body,
    List<String>? tags,
    String? mood,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Entry(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
