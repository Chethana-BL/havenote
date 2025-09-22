import 'package:equatable/equatable.dart';

/// Metadata for an image associated with an entry.
class EntryImage extends Equatable {
  factory EntryImage.fromMap(Map<String, dynamic> map) {
    return EntryImage(path: map['path'] as String);
  }
  const EntryImage({required this.path});

  /// Path in Firebase Storage
  /// e.g. /users/{uid}/entries/{entryId}/{imageId}.jpg
  final String path;

  Map<String, dynamic> toMap() => {'path': path};

  @override
  List<Object?> get props => [path];
}
