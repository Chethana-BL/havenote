import 'package:flutter/material.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/l10n/app_localizations.dart';

/// Widget to display when there are no entries in the home screen.
class EmptyHomeState extends StatelessWidget {
  const EmptyHomeState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.note,
              size: AppSizes.iconXL,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSizes.space),
            Text(
              t.emptyHomeTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.spaceSM),
            Text(
              t.emptyHomeBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display when there are no search results in the home screen.
class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.search,
              size: AppSizes.iconXL,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSizes.space),
            Text(
              t.emptySearchTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.spaceSM),
            Text(
              t.emptySearchBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
