import 'package:flutter/material.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/domain/entries/models/entry.dart';
import 'package:havenote/features/entries/presentation/widgets/storage_image_tile.dart';

/// Widget to display a grid of images for an entry.
class EntryImagesGrid extends StatelessWidget {
  const EntryImagesGrid({super.key, required this.entry});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.spaceSM,
      runSpacing: AppSizes.spaceSM,
      children: [
        for (final img in entry.images) StorageImageTile(path: img.path),
      ],
    );
  }
}
