import 'package:shadcn_flutter/shadcn_flutter.dart';

class PremiumFeatureItem {
  const PremiumFeatureItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class PremiumFeaturesList extends StatelessWidget {
  const PremiumFeaturesList({this.features = defaultFeatures, super.key});

  static const String sectionTitle = 'プレミアム機能';
  static const String emptyMessage = 'プレミアム機能はありません';

  static const List<PremiumFeatureItem> defaultFeatures = [
    PremiumFeatureItem(
      title: '習慣・ご褒美 無制限',
      description: '習慣とご褒美の登録数制限がなくなります',
      icon: BootstrapIcons.infinity,
    ),
    PremiumFeatureItem(
      title: '広告なし',
      description: 'アプリ内の広告を非表示にします',
      icon: BootstrapIcons.eyeSlash,
    ),
    PremiumFeatureItem(
      title: 'テーマ・デザインカスタマイズ',
      description: '見た目を好みに合わせて変更できます',
      icon: BootstrapIcons.palette,
    ),
    PremiumFeatureItem(
      title: '週/月レポート',
      description: '行動ログを週次・月次で振り返れます',
      icon: BootstrapIcons.graphUp,
    ),
    PremiumFeatureItem(
      title: 'データバックアップ',
      description: 'データをバックアップして復元できます',
      icon: BootstrapIcons.cloudArrowUp,
    ),
    PremiumFeatureItem(
      title: 'ウィジェット（今後追加）',
      description: 'ホーム画面ウィジェット機能を提供予定です',
      icon: BootstrapIcons.phone,
    ),
  ];

  static const double _contentPadding = 16;
  static const double _sectionSpacing = 12;
  static const double _itemSpacing = 8;
  static const double _iconSize = 16;
  static const double _iconTextSpacing = 8;
  static const double _titleDescriptionSpacing = 2;

  final List<PremiumFeatureItem> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(_contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(sectionTitle),
            const SizedBox(height: _sectionSpacing),
            if (features.isEmpty)
              const Text(emptyMessage)
            else
              for (var i = 0; i < features.length; i++) ...[
                _FeatureRow(
                  feature: features[i],
                  mutedForeground: theme.colorScheme.mutedForeground,
                ),
                if (i < features.length - 1)
                  const SizedBox(height: _itemSpacing),
              ],
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature, required this.mutedForeground});

  final PremiumFeatureItem feature;
  final Color mutedForeground;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(feature.icon, size: PremiumFeaturesList._iconSize),
        const SizedBox(width: PremiumFeaturesList._iconTextSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feature.title),
              const SizedBox(
                height: PremiumFeaturesList._titleDescriptionSpacing,
              ),
              Text(
                feature.description,
                style: TextStyle(color: mutedForeground),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
