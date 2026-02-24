import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/features/wallet/presentation/widgets/wallet_balance_widget.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _testWallet = Wallet(
  id: 1,
  currentPoints: 250,
  updatedAt: DateTime(2026, 2),
);

Future<void> pumpWalletBalanceWidget(
  WidgetTester tester, {
  required WalletBalance Function() notifierFactory,
  bool pump = true,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        walletBalanceProvider.overrideWith(notifierFactory),
      ],
      child: ShadcnApp(
        theme: _testTheme,
        home: const Scaffold(
          child: WalletBalanceWidget(),
        ),
      ),
    ),
  );
  if (pump) await tester.pump();
}

void main() {
  group('WalletBalanceWidget', () {
    testWidgets('ポイント値が "250pt" としてテキスト表示される', (tester) async {
      await pumpWalletBalanceWidget(
        tester,
        notifierFactory: () => _StubWalletBalance(_testWallet),
      );

      expect(find.text('250pt'), findsOneWidget);
    });

    testWidgets('PrimaryBadge が存在する', (tester) async {
      await pumpWalletBalanceWidget(
        tester,
        notifierFactory: () => _StubWalletBalance(_testWallet),
      );

      expect(find.byType(PrimaryBadge), findsOneWidget);
    });

    testWidgets('0pt のとき "0pt" が表示される', (tester) async {
      final zeroWallet = Wallet(
        id: 1,
        currentPoints: 0,
        updatedAt: DateTime(2026, 2),
      );

      await pumpWalletBalanceWidget(
        tester,
        notifierFactory: () => _StubWalletBalance(zeroWallet),
      );

      expect(find.text('0pt'), findsOneWidget);
    });

    testWidgets('ロード中は PrimaryBadge が表示されない', (tester) async {
      await pumpWalletBalanceWidget(
        tester,
        notifierFactory: () => _StubWalletBalance(_testWallet),
        pump: false,
      );

      expect(find.byType(PrimaryBadge), findsNothing);
    });

    testWidgets('エラー時は PrimaryBadge が表示されない', (tester) async {
      await pumpWalletBalanceWidget(
        tester,
        notifierFactory: () => _ErrorWalletBalance(),
      );

      expect(find.byType(PrimaryBadge), findsNothing);
    });
  });
}

class _StubWalletBalance extends WalletBalance {
  _StubWalletBalance(this._wallet);

  final Wallet _wallet;

  @override
  Future<Wallet> build() async => _wallet;
}

class _ErrorWalletBalance extends WalletBalance {
  @override
  Future<Wallet> build() async => throw Exception('wallet error');
}
