import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';

final rewardRepositoryProvider = Provider<RewardRepository>(
  (_) => MockRewardRepository(),
);
