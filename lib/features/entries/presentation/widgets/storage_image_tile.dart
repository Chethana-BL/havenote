import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';

/// Widget to display an image from storage, handling local files and remote URLs.
class StorageImageTile extends ConsumerWidget {
  const StorageImageTile({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsWeb && path.startsWith('local://')) {
      final file = File(path.replaceFirst('local://', ''));
      return _Framed(child: Image.file(file, fit: BoxFit.cover));
    }

    final urlAsync = ref.watch(storageDownloadUrlProvider(path));

    return urlAsync.when(
      loading: () {
        return const _Framed(
          child: SizedBox(
            width: AppSizes.icon,
            height: AppSizes.icon,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      error: (e, _) {
        Log.e('Image: Error loading storage URL for path=$path: $e');
        return const _Framed(child: Center(child: Text('!')));
      },
      data: (url) {
        return _Framed(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              // Show progress indicator while loading
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// A simple frame around images to ensure consistent sizing and aspect ratio.
class _Framed extends StatelessWidget {
  const _Framed({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
      child: Container(
        width: 128,
        height: 128,
        color: Colors.black12,
        child: child,
      ),
    );
  }
}
