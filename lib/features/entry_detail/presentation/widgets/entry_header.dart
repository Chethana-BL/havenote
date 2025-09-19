import 'package:flutter/material.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/domain/entries/models/entry.dart';

class EntryHeader extends StatelessWidget {
  const EntryHeader({super.key, required this.entry});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(entry.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSizes.spaceSM),

        // Mood + tags row
        Wrap(
          spacing: AppSizes.spaceSM,
          runSpacing: AppSizes.spaceSM,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Mood
            if (entry.mood != null)
              Chip(label: Text(entry.mood!, textAlign: TextAlign.center)),

            // Tags
            if (entry.tags.isNotEmpty)
              ...entry.tags.map((t) => Chip(label: Text('#$t'))),
          ],
        ),
      ],
    );
  }
}
