import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);
    final email = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.settings),
            onPressed: () => context.push(AppRoute.settings()),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Card(
              elevation: AppSizes.elevation,

              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLG),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: cs.primaryContainer,
                      child: Icon(
                        AppIcons.check,
                        color: cs.onPrimaryContainer,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space),
                    Text(
                      'You’re in',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    if (email != null) ...[
                      const SizedBox(height: AppSizes.spaceXS),
                      Text('Signed in as $email'),
                    ],

                    Chip(
                      label: const Text('Coming soon'),
                      side: BorderSide(color: cs.outlineVariant),
                      backgroundColor: cs.surfaceContainerHighest,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
