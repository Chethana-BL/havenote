import 'package:flutter/material.dart';

/// Editor fields: title, body, tags, mood
/// Used in [EditorScreen]

/// Title field for the editor
class TitleField extends StatelessWidget {
  const TitleField({super.key, required this.controller, required this.label});
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: label),
    );
  }
}

/// Body field for the editor
class BodyField extends StatelessWidget {
  const BodyField({super.key, required this.controller, required this.label});
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 8,
      decoration: InputDecoration(labelText: label),
    );
  }
}

/// Tag field for the editor
class TagField extends StatelessWidget {
  const TagField({super.key, required this.controller, required this.label});
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}

/// Mood picker for the editor
class MoodPicker extends StatelessWidget {
  const MoodPicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      hint: Text(label),
      items: const [
        DropdownMenuItem(value: '🙂', child: Text('🙂')),
        DropdownMenuItem(value: '😊', child: Text('😊')),
        DropdownMenuItem(value: '😐', child: Text('😐')),
        DropdownMenuItem(value: '😔', child: Text('😔')),
      ],
      onChanged: onChanged,
    );
  }
}
