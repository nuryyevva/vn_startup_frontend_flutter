import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/features/wallet/data/wallet_repository.dart';
import 'package:nocturne/features/wallet/presentation/providers/wallet_balance_provider.dart';

class _MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  late _MockWalletRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockWalletRepository();
    container = ProviderContainer(overrides: [walletRepositoryProvider.overrideWithValue(repository)]);
  });

  tearDown(() => container.dispose());

  test('loads the balance on first read', () async {
    when(() => repository.getBalance()).thenAnswer((_) async => 1240);

    final result = await container.read(walletBalanceProvider.notifier).refresh().then((_) {
      return container.read(walletBalanceProvider);
    });

    expect(result.value, 1240);
  });

  test('applyOptimisticDelta updates the balance immediately without a network call', () async {
    when(() => repository.getBalance()).thenAnswer((_) async => 100);
    // Reading the notifier triggers its constructor, which already kicks off
    // one refresh() — don't call refresh() again or getBalance() is invoked twice.
    container.read(walletBalanceProvider.notifier);
    await Future<void>.delayed(Duration.zero);

    container.read(walletBalanceProvider.notifier).applyOptimisticDelta(-20);

    expect(container.read(walletBalanceProvider).value, 80);
    verify(() => repository.getBalance()).called(1);
  });

  test('applyOptimisticDelta is a no-op while the balance is still loading', () {
    when(() => repository.getBalance()).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return 100;
    });
    // The constructor already kicked off a refresh(); state is still loading here.

    container.read(walletBalanceProvider.notifier).applyOptimisticDelta(-20);

    expect(container.read(walletBalanceProvider).value, isNull);
  });
}
