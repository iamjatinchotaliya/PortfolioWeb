import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolioweb/presentation/providers/hero_provider.dart';

void main() {
  testWidgets('Hero text rotates every three seconds and wraps around', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(heroProvider, (_, _) {});
    addTearDown(subscription.close);

    expect(subscription.read(), 0);
    await tester.pump(const Duration(milliseconds: 2999));
    expect(subscription.read(), 0);
    await tester.pump(const Duration(milliseconds: 1));
    expect(subscription.read(), 1);
    await tester.pump(const Duration(seconds: 3));
    expect(subscription.read(), 2);
    await tester.pump(const Duration(seconds: 3));
    expect(subscription.read(), 3);
    await tester.pump(const Duration(seconds: 3));
    expect(subscription.read(), 0);
    container.dispose();
  });

  testWidgets('Hero timer is disposed when unused and restarts from first text', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(heroProvider, (_, _) {});

    await tester.pump(const Duration(seconds: 3));
    expect(subscription.read(), 1);
    subscription.close();
    await tester.pump(const Duration(milliseconds: 1));
    expect(container.exists(heroProvider), isFalse);

    // A timer left running after disposal would try to update a disposed notifier.
    await tester.pump(const Duration(seconds: 12));
    expect(tester.takeException(), isNull);

    final newSubscription = container.listen(heroProvider, (_, _) {});
    addTearDown(newSubscription.close);
    expect(newSubscription.read(), 0);
    await tester.pump(const Duration(seconds: 3));
    expect(newSubscription.read(), 1);
    container.dispose();
  });
}
