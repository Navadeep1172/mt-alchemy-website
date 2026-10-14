/// ---------------------------------------------------------------------------
/// Backend integration guide
/// ---------------------------------------------------------------------------
/// MT Alchemy currently runs entirely on-device (see `lib/app_state.dart`).
/// Everything a user does - cart, orders, enrolments, progress, certificates,
/// employees and the admin catalogue - lives in [AppState], which persists to
/// `SharedPreferences` (localStorage on the web).
///
/// [AppState] exposes one seam to move to a real backend: assign
/// `app.remote = MyRemote();`. `AppState` calls [RemoteSource.pull] on start
/// and [RemoteSource.push] after every change, so the UI code never changes.
///
/// ---------------------------------------------------------------------------
/// Option A - Firebase (recommended for Flutter web on GitHub Pages)
/// ---------------------------------------------------------------------------
/// 1. Create a project at https://console.firebase.google.com and add a Web app.
/// 2. Enable Authentication (Email/Password) and Cloud Firestore.
/// 3. Add dependencies:
///      flutter pub add firebase_core firebase_auth cloud_firestore
/// 4. Initialise in `main()`:
///      await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
/// 5. Implement [RemoteSource] against Firestore collections that mirror the
///    entities in `lib/app_state.dart`:
///      users, organizations, courses, lessons, enrolments, progress,
///      certificates, products, orders, order_items, payments, downloads,
///      employees, assignments, testimonials, impact_stories.
/// 6. Replace the login/session logic in `lib/session.dart` with
///    `FirebaseAuth.instance.signInWithEmailAndPassword(...)`.
///
/// ---------------------------------------------------------------------------
/// Option B - Supabase
/// ---------------------------------------------------------------------------
/// 1. Create a project at https://supabase.com and enable Auth.
/// 2. `flutter pub add supabase_flutter`, initialise with your URL + anon key.
/// 3. Create tables matching the AppState entities and implement [RemoteSource]
///    with `client.from('orders').upsert(...)` etc.
///
/// ---------------------------------------------------------------------------
/// Option C - Custom REST API
/// ---------------------------------------------------------------------------
/// Implement [RemoteSource.push] as `POST /state` and [RemoteSource.pull] as
/// `GET /state` against your own server. The JSON shape is the same map used in
/// `AppState._persist`.
///
/// NOTE: a real payment provider (Stripe / Billplz / SenangPay) belongs inside
/// [AppState.placeOrder]; replace the mock status there with the provider's
/// `Successful` / `Failed` / `Pending` result.
library;

export 'app_state.dart' show RemoteSource, NoopRemoteSource;
