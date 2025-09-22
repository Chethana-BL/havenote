import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/entries/presentation/widgets/storage_image_tile.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';
import 'package:havenote/l10n/app_localizations.dart';

/// Widget to display existing images for an entry in the editor.
class EditorExistingImages extends ConsumerWidget {
  const EditorExistingImages({super.key, required this.entryId});
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = S.of(context);
    final entryAsync = ref.watch(entryStreamProvider(entryId));
    final repo = ref.read(entriesRepositoryProvider);

    return entryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (entry) {
        if (entry == null || entry.images.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.labelImagesSaved,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.spaceSM),
            Wrap(
              spacing: AppSizes.spaceSM,
              runSpacing: AppSizes.spaceSM,
              children: [
                for (final img in entry.images)
                  Stack(
                    children: [
                      StorageImageTile(path: img.path),
                      Positioned(
                        right: AppSizes.spaceXS,
                        top: AppSizes.spaceXS,
                        child: Material(
                          color: Colors.black45,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () async {
                              try {
                                await repo.removeImage(
                                  entryId: entry.id,
                                  imagePath: img.path,
                                );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(t.snackImageRemoved)),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${t.errorGeneric}: $e'),
                                  ),
                                );
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(AppSizes.spaceXS),
                              child: Icon(
                                AppIcons.delete,
                                size: AppSizes.iconSM,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
