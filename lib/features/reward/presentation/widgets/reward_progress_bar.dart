import 'package:shadcn_flutter/shadcn_flutter.dart';

class RewardProgressBar extends StatelessWidget {
  const RewardProgressBar({
    required this.currentPoints,
    required this.targetPoints,
    super.key,
  });

  final int currentPoints;
  final int targetPoints;

  double get _progressValue =>
      targetPoints == 0 ? 1.0 : (currentPoints / targetPoints).clamp(0.0, 1.0);

  bool get _isUnlocked => currentPoints >= targetPoints;

  String get _statusText => _isUnlocked
      ? '解禁！'
      : 'あと ${targetPoints - currentPoints} pt';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: _progressValue),
        const SizedBox(height: 4),
        Text(_statusText),
      ],
    );
  }
}
