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
flutter run -d chrome --web-hostname localhost --web-port 3000 --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
```

The default API address is already `http://127.0.0.1:8000/api/v1`. Include `/api/v1` in overrides; a trailing slash is optional. Restart/rebuild Flutter after changing the address.

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
flutter build web --release --dart-define=API_BASE_URL=https://your-api.example.com/api/v1
```

Use the deployed backend's HTTPS URL and allow the deployed website origin in backend CORS. A remote visitor's `localhost` points to their own computer. For Android emulators use `http://10.0.2.2:8000/api/v1`; physical devices need a reachable backend LAN or HTTPS address and platform network permissions. This integration is verified for Flutter web.

## Checks

```powershell
flutter test
flutter analyze
flutter build web --release
```

The API client uses an injectable `http.Client` for request testing, following the [official package guidance](https://pub.dev/packages/http).
