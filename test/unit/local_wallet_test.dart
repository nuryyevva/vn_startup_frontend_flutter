import 'package:flutter_test/flutter_test.dart';
import 'package:nocturne/core/network/error_mapper.dart';
import 'package:nocturne/features/offline/data/local_store.dart';
import 'package:nocturne/features/offline/data/local_wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('a new wallet starts with the starting balance', () async {
    SharedPreferences.setMockInitialValues({});
    final wallet = LocalWallet(LocalStore(await SharedPreferences.getInstance()));

    expect(await wallet.getBalance(), LocalWallet.startingBalance);
    await wallet.debit(10);
    expect(await wallet.getBalance(), LocalWallet.startingBalance - 10);
  });

  test('a wallet from an older build is brought to the starting balance once', () async {
    SharedPreferences.setMockInitialValues({'offline.v1.wallet.balance': 31175});
    final prefs = await SharedPreferences.getInstance();

    expect(await LocalWallet(LocalStore(prefs)).getBalance(), LocalWallet.startingBalance);
    await LocalWallet(LocalStore(prefs)).debit(50);
    expect(await LocalWallet(LocalStore(prefs)).getBalance(), LocalWallet.startingBalance - 50);
  });

  test('getting more diamonds is coming soon', () async {
    SharedPreferences.setMockInitialValues({});
    final wallet = LocalWallet(LocalStore(await SharedPreferences.getInstance()));

    expect(() => wallet.devGrant(100), throwsA(isA<TopUpUnavailableException>()));
    expect(await wallet.getBalance(), LocalWallet.startingBalance);
  });
}
