import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/features/home/state/home_filters.dart';
import 'package:havenote/l10n/app_localizations.dart';

/// Search field widget for the home screen.
class HomeSearchField extends ConsumerStatefulWidget {
  const HomeSearchField({super.key});

  @override
  ConsumerState<HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends ConsumerState<HomeSearchField> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(homeFiltersProvider).query; // initial value
    _controller.addListener(() => setState(() {})); // to update suffixIcon
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(() => setState(() {}));
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      ref.read(homeFiltersProvider.notifier).setQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final hasText = _controller.text.isNotEmpty;

    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(AppIcons.search),
        hintText: t.hintSearch,
        suffixIcon:
            hasText
                ? IconButton(
                  tooltip: t.actionClear,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _onChanged('');
                  },
                )
                : null,
      ),
    );
  }
}
