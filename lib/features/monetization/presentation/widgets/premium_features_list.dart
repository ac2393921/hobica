import 'package:shadcn_flutter/shadcn_flutter.dart';

class PremiumFeaturesList extends StatelessWidget {
  const PremiumFeaturesList({super.key});

  static const String sectionTitle = 'プレミアム機能';

  static const List<String> features = [
    '習慣・ご褒美 無制限',
    '広告なし',
    'テーマ・デザインカスタマイズ',
    '週/月レポート',
    'データバックアップ',
    'ウィジェット（今後追加）',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(sectionTitle),
            const SizedBox(height: 12),
            for (final feature in features)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(BootstrapIcons.checkLg, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
