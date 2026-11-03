import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portfolioweb/data/repositories/data_repository.dart';
import 'package:portfolioweb/data/services/portfolio_api_client.dart';
import 'package:portfolioweb/core/config/api_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolioweb/presentation/providers/contact_form_provider.dart';
import 'package:portfolioweb/presentation/providers/portfolio_provider.dart';

Map<String, dynamic> portfolioFixture() => {
  'profile': {
    'id': 1,
    'name': 'Jatin',
    'headline': 'Flutter Developer',
    'bio': 'Developer',
    'location': 'India',
    'available_for_work': true,
  },
  'skills': [],
  'projects': [],
  'experiences': [],
  'education': [],
  'social_links': [],
};

void main() {
  test('API configuration exposes the local and live server URLs', () {
    expect(ApiConfig.localBaseUrl, 'http://127.0.0.1:8000/api/v1');
    expect(ApiConfig.liveBaseUrl, 'http://140.245.23.252:8080/api/v1');
    expect(ApiConfig.baseUrl, ApiConfig.liveBaseUrl);
  });

  test(
    'concurrent sections share one request; clearCache fetches again',
    () async {
      var calls = 0;
      final repository = DataRepository(
        apiClient: PortfolioApiClient(
          client: MockClient((request) async {
            calls++;
            expect(request.url.path, '/api/v1/portfolio');
            return http.Response(jsonEncode(portfolioFixture()), 200);
          }),
        ),
      );
      addTearDown(repository.dispose);
      await Future.wait([
        repository.getPersonalInfo(),
        repository.getSkills(),
        repository.getContactInfo(),
      ]);
      expect(calls, 1);
      repository.clearCache();
      expect((await repository.getPersonalInfo()).name, 'Jatin');
      expect(calls, 2);
    },
  );

  test('failed request is evicted and can be retried', () async {
    var calls = 0;
    final repository = DataRepository(
      apiClient: PortfolioApiClient(
        client: MockClient((_) async {
          return ++calls == 1
              ? http.Response('unavailable', 503)
              : http.Response(jsonEncode(portfolioFixture()), 200);
        }),
      ),
    );
    addTearDown(repository.dispose);
    await expectLater(
      repository.getPersonalInfo(),
      throwsA(isA<PortfolioApiException>()),
    );
    expect((await repository.getPersonalInfo()).name, 'Jatin');
    expect(calls, 2);
  });

  test('blog pagination follows total and maps every published post', () async {
    final offsets = <String>[];
    final repository = DataRepository(
      apiClient: PortfolioApiClient(
        client: MockClient((request) async {
          if (request.url.path.endsWith('/portfolio'))
            return http.Response(jsonEncode(portfolioFixture()), 200);
          final offset = request.url.queryParameters['offset']!;
          offsets.add(offset);
          return http.Response(
            jsonEncode({
              'total': 2,
              'items': [
                {
                  'id': int.parse(offset) + 1,
                  'title': 'Post $offset',
                  'slug': 'post-$offset',
                  'excerpt': 'Excerpt',
                  'content': 'Body',
                  'tags': [],
                  'status': 'published',
                  'published_at': '2026-10-28T12:00:00Z',
                  'created_at': '2026-10-28T12:00:00Z',
                },
              ],
            }),
            200,
          );
        }),
      ),
    );
    addTearDown(repository.dispose);
    expect((await repository.getBlogPosts()).map((post) => post.id), [
      '1',
      '2',
    ]);
    expect(offsets, ['0', '1']);
  });

  test(
    'contact provider posts exact JSON and exposes rate limit error',
    () async {
      final repository = DataRepository(
        apiClient: PortfolioApiClient(
          client: MockClient((request) async {
            expect(request.method, 'POST');
            expect(request.url.path, '/api/v1/contact');
            expect(
              request.headers['Content-Type'],
              contains('application/json'),
            );
            expect(jsonDecode(request.body), {
              'name': 'Visitor',
              'email': 'v@example.com',
              'subject': 'Hello',
              'message': 'A project',
            });
            return http.Response('{"detail":"Rate limit"}', 429);
          }),
        ),
      );
      addTearDown(repository.dispose);
      final container = ProviderContainer(
        overrides: [dataRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      container.listen(contactFormProvider, (_, _) {});
      await container
          .read(contactFormProvider.notifier)
          .submit(
            const ContactFormData(
              name: ' Visitor ',
              email: 'v@example.com',
              subject: 'Hello',
              message: 'A project',
            ),
          );
      expect(
        container.read(contactFormProvider).status,
        ContactFormStatus.error,
      );
      expect(
        container.read(contactFormProvider).errorMessage,
        contains('Too many messages'),
      );
    },
  );

  test('successful contact reaches server once', () async {
    var calls = 0;
    final repository = DataRepository(
      apiClient: PortfolioApiClient(
        client: MockClient((_) async {
          calls++;
          return http.Response('{"message":"Received"}', 201);
        }),
      ),
    );
    addTearDown(repository.dispose);
    await repository.submitContact(
      name: 'Visitor',
      email: 'v@example.com',
      subject: 'Hello',
      message: 'Project',
    );
    expect(calls, 1);
  });

  test('client normalizes base URL and reports validation errors', () async {
    final api = PortfolioApiClient(
      baseUrl: 'https://example.com/api/v1/',
      client: MockClient((request) async {
        expect(request.url.toString(), 'https://example.com/api/v1/contact');
        return http.Response(
          '{"detail":[{"loc":["body","email"],"msg":"Invalid email"}]}',
          422,
        );
      }),
    );
    addTearDown(api.close);
    await expectLater(
      api.post('contact', {}),
      throwsA(
        isA<PortfolioApiException>().having(
          (e) => e.message,
          'message',
          contains('email: Invalid email'),
        ),
      ),
    );
  });

  test('client handles malformed JSON, timeout and network errors', () async {
    for (final handler in <Future<http.Response> Function(http.Request)>[
      (_) async => http.Response('<html>not JSON</html>', 200),
      (_) async => throw TimeoutException('timeout'),
      (_) async => throw http.ClientException('network'),
    ]) {
      final api = PortfolioApiClient(client: MockClient(handler));
      await expectLater(
        api.get('portfolio'),
        throwsA(isA<PortfolioApiException>()),
      );
      api.close();
    }
  });

  test('missing blog returns null but server errors propagate', () async {
    var code = 404;
    final repository = DataRepository(
      apiClient: PortfolioApiClient(
        client: MockClient((_) async => http.Response('{}', code)),
      ),
    );
    addTearDown(repository.dispose);
    expect(await repository.getBlogPostBySlug('missing'), isNull);
    code = 500;
    await expectLater(
      repository.getBlogPostBySlug('missing'),
      throwsA(isA<PortfolioApiException>()),
    );
  });
}
