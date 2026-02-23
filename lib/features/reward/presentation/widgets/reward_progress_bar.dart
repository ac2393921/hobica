import 'package:shadcn_flutter/shadcn_flutter.dart';

class RewardProgressBar extends StatelessWidget {
  const RewardProgressBar({
    required this.currentPoints,
    required this.targetPoints,
    super.key,
  });

  static const double _progressTextSpacing = 4;

  final int currentPoints;
  final int targetPoints;

  bool get _isUnlocked => currentPoints >= targetPoints;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = currentPoints.clamp(0, targetPoints).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Progress(
          progress: clampedProgress,
          max: targetPoints.toDouble(),
        ),
        const SizedBox(height: _progressTextSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$currentPoints/${targetPoints}pt'),
            Text(_isUnlocked ? '解禁！' : 'あと${targetPoints - currentPoints}pt'),
          ],
        ),
      ],
    );
  }
}
