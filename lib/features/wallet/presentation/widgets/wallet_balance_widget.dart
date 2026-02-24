import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class WalletBalanceWidget extends ConsumerWidget {
  const WalletBalanceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletBalanceProvider);
    return walletAsync.when(
      data: (wallet) => PrimaryBadge(
        child: Text('${wallet.currentPoints}pt'),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
