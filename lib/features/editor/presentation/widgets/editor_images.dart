import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/editor/state/editor_controller.dart';
import 'package:havenote/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

/// Widget to pick images from gallery and display thumbnails of picked images.
class EditorImages extends ConsumerWidget {
  EditorImages({super.key});

  final _picker = ImagePicker();

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // TODO(Owner): adjust as needed
    );
    if (x == null) return;
    ref.read(editorControllerProvider.notifier).addPicked(File(x.path));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = S.of(context);
    final state = ref.watch(editorControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.picked.isNotEmpty) ...[
          Text(
            t.labelImagesNew,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.space),
          Wrap(
            spacing: AppSizes.spaceSM,
            runSpacing: AppSizes.spaceSM,
            children: [
              for (final f in state.picked)
                _Thumb(
                  file: f,
                  onRemove:
                      () => ref
                          .read(editorControllerProvider.notifier)
                          .removePicked(f),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSizes.space),
        OutlinedButton.icon(
          onPressed: () => _pick(context, ref),
          icon: const Icon(AppIcons.image, size: AppSizes.icon),
          label: Text(t.labelAddImage),
        ),
      ],
    );
  }
}

/// A simple frame around images to ensure consistent sizing and aspect ratio.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.file, required this.onRemove});

  final File file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          child: Container(
            width: 128,
            height: 128,
            color: Colors.black12,
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          right: AppSizes.spaceXS,
          top: AppSizes.spaceXS,
          child: Material(
            color: Colors.black45,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRemove,
              child: const Padding(
                padding: EdgeInsets.all(AppSizes.spaceXS),
                child: Icon(
                  Icons.close,
                  size: AppSizes.icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
