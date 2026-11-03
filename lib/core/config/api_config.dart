enum ApiEnvironment { local, live }

class ApiConfig {
  ApiConfig._();

  // Change only this value when switching between local and live API servers.
  static const environment = ApiEnvironment.live;

  static const localBaseUrl = 'http://127.0.0.1:8000/api/v1';
  static const liveBaseUrl = 'http://140.245.23.252:8080/api/v1';

  static const baseUrl = environment == ApiEnvironment.local
      ? localBaseUrl
      : liveBaseUrl;
}
