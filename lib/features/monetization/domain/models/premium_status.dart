import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_status.freezed.dart';
part 'premium_status.g.dart';

@freezed
class PremiumStatus with _$PremiumStatus {
  const factory PremiumStatus({
    required int id,
    @Default(false) bool isPremium,
    DateTime? premiumExpiresAt,
    String? purchaseToken,
    required DateTime updatedAt,
  }) = _PremiumStatus;

  factory PremiumStatus.fromJson(Map<String, dynamic> json) =>
      _$PremiumStatusFromJson(json);
}
