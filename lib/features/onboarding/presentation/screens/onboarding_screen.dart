import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/genres.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/genre_chip.dart';
import '../../../profile/domain/models/user_profile.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';

enum _Gender { female, male, other, preferNotToSay }

extension on _Gender {
  String get wireValue => switch (this) {
    _Gender.female => 'female',
    _Gender.male => 'male',
    _Gender.other => 'other',
    _Gender.preferNotToSay => 'prefer_not_to_say',
  };

  String labelKey() => switch (this) {
    _Gender.female => 'onboarding.genderFemale',
    _Gender.male => 'onboarding.genderMale',
    _Gender.other => 'onboarding.genderOther',
    _Gender.preferNotToSay => 'onboarding.genderPreferNotToSay',
  };
}

/// Post-registration personalization: name, gender, favorite genres —
/// each optional per-step (a step can be skipped), but the flow itself
/// can't be bypassed entirely (see project spec §8.9). PATCHes
/// `/users/me` once at the end with whatever was actually filled in.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _totalSteps = 3;
  int _step = 0;
  bool _isSubmitting = false;

  final _nameController = TextEditingController();
  _Gender? _selectedGender;
  final Set<String> _selectedGenres = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step += 1);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    setState(() => _isSubmitting = true);
    final name = _nameController.text.trim();
    try {
      await ref
          .read(userProfileNotifierProvider.notifier)
          .updateProfile(
            UpdateProfileRequest(
              displayName: name.isEmpty ? null : name,
              gender: _selectedGender?.wireValue,
              favoriteGenres: _selectedGenres.isEmpty ? null : _selectedGenres.toList(),
            ),
          );
    } catch (_) {
      // Onboarding is a soft, skippable flow — a failed PATCH here
      // shouldn't trap the user; they can fill this in later from Profile.
    } finally {
      if (mounted) context.go('/stories');
    }
  }

  @override
  Widget build(BuildContext context) {
    final genres = ref.watch(appConfigProvider).genres;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'onboarding.stepOf'.tr(args: ['${_step + 1}', '$_totalSteps']),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: (_step + 1) / _totalSteps, minHeight: 4),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Motion.screenDuration,
                  child: KeyedSubtree(key: ValueKey(_step), child: _buildStep(context, genres)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton(onPressed: _isSubmitting ? null : _next, child: Text('common.skip'.tr())),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _next,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(_step == _totalSteps - 1 ? 'onboarding.finish'.tr() : 'common.continue'.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, List<GenreConfig> genres) {
    final textTheme = Theme.of(context).textTheme;
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('onboarding.nameTitle'.tr(), style: textTheme.headlineLarge),
            const SizedBox(height: 24),
            TextField(controller: _nameController, decoration: InputDecoration(hintText: 'onboarding.nameHint'.tr())),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('onboarding.genderTitle'.tr(), style: textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text('onboarding.genderOptional'.tr(), style: textTheme.bodyMedium),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final gender in _Gender.values)
                  GenreChip(
                    label: gender.labelKey().tr(),
                    selected: _selectedGender == gender,
                    onTap: () => setState(() => _selectedGender = gender),
                  ),
              ],
            ),
          ],
        );
      case 2:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('onboarding.genresTitle'.tr(), style: textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text('onboarding.genresSubtitle'.tr(), style: textTheme.bodyMedium),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final genre in genres)
                  GenreChip(
                    label: genre.labelKey.tr(),
                    selected: _selectedGenres.contains(genre.id),
                    onTap: () {
                      setState(() {
                        if (!_selectedGenres.remove(genre.id)) {
                          _selectedGenres.add(genre.id);
                        }
                      });
                    },
                  ),
              ],
            ),
          ],
        );
    }
  }
}
