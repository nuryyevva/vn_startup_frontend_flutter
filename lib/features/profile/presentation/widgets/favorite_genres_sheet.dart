import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/genres.dart';
import '../../../../core/widgets/genre_chip.dart';

/// Multi-select bottom sheet for editing favorite genres — shared by
/// onboarding (via a full step) and the profile screen's "Edit" action.
/// Returns the selected genre ids, or null if dismissed without saving.
Future<Set<String>?> showFavoriteGenresSheet(BuildContext context, {required Set<String> initiallySelected}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _FavoriteGenresSheet(initiallySelected: initiallySelected),
  );
}

class _FavoriteGenresSheet extends StatefulWidget {
  const _FavoriteGenresSheet({required this.initiallySelected});

  final Set<String> initiallySelected;

  @override
  State<_FavoriteGenresSheet> createState() => _FavoriteGenresSheetState();
}

class _FavoriteGenresSheetState extends State<_FavoriteGenresSheet> {
  late final Set<String> _selected = {...widget.initiallySelected};

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('profile.favoriteGenres'.tr(), style: textTheme.headlineLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final genre in kGenres)
                  GenreChip(
                    label: genre.labelKey.tr(),
                    selected: _selected.contains(genre.id),
                    onTap: () {
                      setState(() {
                        if (!_selected.remove(genre.id)) {
                          _selected.add(genre.id);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_selected),
              child: Text('common.save'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
