import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/editor/presentation/widgets/editor_existing_images.dart';
import 'package:havenote/features/editor/presentation/widgets/editor_fields.dart';
import 'package:havenote/features/editor/presentation/widgets/editor_images.dart';
import 'package:havenote/features/editor/state/editor_controller.dart';
import 'package:havenote/features/entries/state/entries_providers.dart';
import 'package:havenote/l10n/app_localizations.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key, this.entryId});
  final String? entryId;

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _tag = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Prefill for edit mode
    if (widget.entryId != null) {
      ref
          .read(entriesRepositoryProvider)
          .watchEntry(widget.entryId!)
          .first
          .then((e) {
            if (!mounted || e == null) return;
            _title.text = e.title;
            _body.text = e.body;
            if (e.tags.isNotEmpty) _tag.text = e.tags.first;
            ref.read(editorControllerProvider.notifier).setMood(e.mood);
          });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _tag.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final t = S.of(context);
    final ctl = ref.read(editorControllerProvider.notifier);

    final safeTitle =
        _title.text.trim().isEmpty ? t.labelUntitled : _title.text.trim();
    final body = _body.text.trim();
    final tags =
        _tag.text.trim().isEmpty
            ? const <String>[]
            : <String>[_tag.text.trim()];

    try {
      await ctl.save(
        entryId: widget.entryId,
        title: safeTitle,
        body: body,
        tags: tags,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${t.errorGeneric}: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final editorState = ref.watch(editorControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entryId == null ? t.labelNewEntry : t.labelEditEntry,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.padding),
        children: [
          TitleField(controller: _title, label: t.labelTitle),
          const SizedBox(height: AppSizes.spaceSM),
          BodyField(controller: _body, label: t.labelBody),
          const SizedBox(height: AppSizes.spaceSM),
          Row(
            children: [
              MoodPicker(
                value: editorState.mood,
                onChanged:
                    (v) =>
                        ref.read(editorControllerProvider.notifier).setMood(v),
                label: t.labelMood,
              ),
              const SizedBox(width: AppSizes.spaceSM),
              Expanded(child: TagField(controller: _tag, label: t.labelTag)),
            ],
          ),

          // Existing images (edit mode)
          if (widget.entryId != null) ...[
            const SizedBox(height: AppSizes.space),
            EditorExistingImages(entryId: widget.entryId!),
          ],

          // Images picker + thumbnails
          EditorImages(),

          const SizedBox(height: AppSizes.spaceLG),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: editorState.isSaving ? null : _onSave,
              icon:
                  editorState.isSaving
                      ? const SizedBox(
                        height: AppSizes.iconSM,
                        width: AppSizes.iconSM,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(AppIcons.check),
              label: Text(t.actionSave),
            ),
          ),
        ],
      ),
    );
  }
}
