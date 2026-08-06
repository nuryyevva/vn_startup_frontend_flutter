import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/features/auth/data/auth_repository.dart';
import 'package:nocturne/features/auth/domain/models/auth_user.dart';
import 'package:nocturne/features/auth/presentation/providers/auth_state_provider.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late ProviderContainer container;

  const user = AuthUser(id: 'u1', email: 'a@example.com', role: 'user');

  setUp(() {
    repository = _MockAuthRepository();
  });

  tearDown(() => container.dispose());

  ProviderContainer buildContainer() {
    return ProviderContainer(overrides: [authRepositoryProvider.overrideWithValue(repository)]);
  }

  test('bootstraps to authenticated when a session is already stored', () async {
    when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
    container = buildContainer();
    container.read(authStateProvider); // trigger notifier creation so bootstrap starts

    await Future<void>.delayed(Duration.zero);

    expect(container.read(authStateProvider).status, AuthStatus.authenticated);
  });

  test('bootstraps to unauthenticated when there is no stored session', () async {
    when(() => repository.hasStoredSession()).thenAnswer((_) async => false);
    container = buildContainer();
    container.read(authStateProvider); // trigger notifier creation so bootstrap starts

    await Future<void>.delayed(Duration.zero);

    expect(container.read(authStateProvider).status, AuthStatus.unauthenticated);
  });

  test('login moves state to authenticated with the returned user', () async {
    when(() => repository.hasStoredSession()).thenAnswer((_) async => false);
    when(() => repository.login('a@example.com', 'password123')).thenAnswer((_) async => user);
    container = buildContainer();
    await Future<void>.delayed(Duration.zero);

    await container.read(authStateProvider.notifier).login('a@example.com', 'password123');

    final state = container.read(authStateProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user, user);
  });

  test('signOut clears the session and moves state to unauthenticated', () async {
    when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
    when(() => repository.logout()).thenAnswer((_) async {});
    container = buildContainer();
    await Future<void>.delayed(Duration.zero);

    await container.read(authStateProvider.notifier).signOut();

    expect(container.read(authStateProvider).status, AuthStatus.unauthenticated);
    verify(() => repository.logout()).called(1);
  });

  test('continueAsGuest moves state to guest without calling the repository', () {
    when(() => repository.hasStoredSession()).thenAnswer((_) async => false);
    container = buildContainer();

    container.read(authStateProvider.notifier).continueAsGuest();

    expect(container.read(authStateProvider).status, AuthStatus.guest);
  });
}
