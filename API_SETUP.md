# Run PortfolioWeb with my_portfolio

The website now reads the Python API instead of bundled demo JSON. Start both processes in separate PowerShell terminals.

## Backend

```powershell
cd 'C:\Jatin\Python Projects\my_portfolio'
.\.venv\Scripts\python.exe -m uvicorn main:app --reload --host 127.0.0.1 --port 8000
```

Use the backend README's migration/setup steps for a fresh database. Do not reseed an existing populated database just to run the frontend.

## Frontend

```powershell
cd 'C:\Jatin\Flutter projects\PortfolioWeb'
flutter pub get
flutter run -d chrome --web-hostname localhost --web-port 3000
```

The API address is controlled in one place: [`lib/core/config/api_config.dart`](lib/core/config/api_config.dart). Set `ApiConfig.environment` to `ApiEnvironment.local` for `http://127.0.0.1:8000/api/v1` or `ApiEnvironment.live` for `http://140.245.23.252:8080/api/v1`. Restart/rebuild Flutter after changing it.

The backend must allow the exact frontend origin in `CORS_ORIGINS`. Its existing local configuration allows `http://localhost:3000`. `http://127.0.0.1:3000` is a different origin. Changing this backend setting requires restarting the API.

## Requests

- `GET /api/v1/portfolio`: profile, skills, projects, experience, education and social links. Sections share a cached request.
- `GET /api/v1/blogs?limit=100&offset=...`: all published blog pages.
- `GET /api/v1/blogs/slug/{slug}`: blog detail.
- `POST /api/v1/contact`: visitor name, email, subject and message. Success means saved to the backend inbox; the backend does not email messages.
- Profile photo and resume links use the URLs returned by the API, resolved against the backend origin.

Project details use the loaded portfolio records. Google Play and App Store links are preserved separately. Missing optional content remains empty; the frontend does not invent skill proficiency or show demo content after a request fails. Education is mapped for repository consumers; the current home layout displays work experience. There is no backend certifications collection.

Errors offer retry and failed requests are not permanently cached. Contact errors preserve the entered values. No admin key or OTP session is required or embedded in the public website. Edit content using the backend's authenticated admin API; `assets/data` contains legacy examples only.

## Deployment

```powershell
flutter build web --release
```

Before building for deployment, set `ApiConfig.environment` to `ApiEnvironment.live` in [`lib/core/config/api_config.dart`](lib/core/config/api_config.dart). A remote visitor's `localhost` points to their own computer. For Android emulators use `http://10.0.2.2:8000/api/v1`; physical devices need a reachable backend LAN or HTTPS address and platform network permissions. This integration is verified for Flutter web.

## Checks

```powershell
flutter test
flutter analyze
flutter build web --release
```

The API client uses an injectable `http.Client` for request testing, following the [official package guidance](https://pub.dev/packages/http).
