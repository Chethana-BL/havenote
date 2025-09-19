import 'package:flutter/material.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/domain/entries/models/entry.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({super.key, required this.entry});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO(Owner): Navigate to entry details screen (not implemented yet)
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceSM),
              Text(entry.body, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: AppSizes.space),
              Wrap(
                spacing: AppSizes.spaceSM,
                runSpacing: AppSizes.spaceSM,
                children: [
                  if (entry.mood != null) Chip(label: Text(entry.mood!)),
                  for (final tag in entry.tags) Chip(label: Text('#$tag')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
