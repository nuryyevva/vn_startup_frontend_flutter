import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Displays only `remaining`, exactly as sent by the server — never a
/// client-side countdown or decrement. Renders nothing for `limit_type ==
/// 'none'` or before the server has told us a number yet (project spec
/// §8.5: "клиент никогда не является источником истины по лимитам").
class SessionLimitBadge extends StatelessWidget {
  const SessionLimitBadge({super.key, required this.limitType, required this.remaining});

  final String limitType;
  final int? remaining;

  @override
  Widget build(BuildContext context) {
    if (limitType == 'none' || remaining == null) return const SizedBox.shrink();
    final colors = context.colors;
    final label = limitType == 'time'
        ? 'dialog.remainingSeconds'.tr(args: ['$remaining'])
        : 'dialog.remainingMessages'.tr(args: ['$remaining']);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.border),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
