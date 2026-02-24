import 'dart:io';

import 'package:shadcn_flutter/shadcn_flutter.dart';

class RewardImageView extends StatelessWidget {
  const RewardImageView({
    required this.imageUri,
    required this.height,
    required this.iconSize,
    super.key,
  });

  final String? imageUri;
  final double height;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (imageUri != null) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: Image.file(
          File(imageUri!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return SizedBox(height: height, child: _buildPlaceholder());
  }

  Widget _buildPlaceholder() {
    return ColoredBox(
      color: const Color(0xFFEEEEEE),
      child: Center(
        child: Icon(BootstrapIcons.gift, size: iconSize),
      ),
    );
  }
}
