import 'package:shadcn_flutter/shadcn_flutter.dart';

class HabitStreakIndicator extends StatelessWidget {
  const HabitStreakIndicator({
    required this.streakDays,
    super.key,
  });

  static const double _iconSize = 16;
  static const double _iconTextSpacing = 4;

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(BootstrapIcons.fire, size: _iconSize),
        const SizedBox(width: _iconTextSpacing),
        Text('$streakDays日連続'),
      ],
    );
  }
}
