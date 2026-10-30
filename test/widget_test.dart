import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portfolioweb/data/repositories/data_repository.dart';
import 'package:portfolioweb/data/services/portfolio_api_client.dart';
import 'package:portfolioweb/presentation/pages/home_page.dart';
import 'package:portfolioweb/presentation/providers/portfolio_provider.dart';
import 'package:portfolioweb/presentation/widgets/common/portfolio_loader.dart';

void main() {
  testWidgets('loader stays visible until the API settles', (tester) async {
    final response = Completer<http.Response>();
    final repository = DataRepository(
      apiClient: PortfolioApiClient(client: MockClient((_) => response.future)),
    );
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dataRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(PortfolioLoader), findsOneWidget);
    response.complete(http.Response('{}', 503));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(PortfolioLoader), findsNothing);
    expect(find.text('Retry'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('portfolio failure displays retry and retries the API', (
    tester,
  ) async {
    var calls = 0;
    final repository = DataRepository(
      apiClient: PortfolioApiClient(
        client: MockClient((_) async {
          calls++;
          return http.Response('{}', 503);
        }),
      ),
    );
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dataRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Failed to load portfolio data'), findsOneWidget);
    expect(calls, 1);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(calls, 2);
    expect(find.text('Retry'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
