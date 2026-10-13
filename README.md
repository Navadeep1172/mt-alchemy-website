# MT Alchemy Website

A Flutter (web + mobile) prototype for **MT Alchemy (Kaedae Event Management)**,
built for the INTI **NET4207** coursework. It covers the four core modules from
the brief: the **public marketing site**, the **Learning Management System
(LMS)**, the **online store**, and the **admin / dashboard** area, across **26
routes** and **5 user roles**.

## Running

```bash
flutter pub get
flutter run -d chrome        # run as a web app
# or
flutter build web --release  # production build into build/web
```

Fonts are loaded through `google_fonts` (Fraunces for headings, Inter for body).
A network connection is required the first time; the framework falls back to the
bundled system fonts otherwise.

## Tests

```bash
flutter analyze
flutter test
```

- `test/widget_test.dart` – smoke test for the app shell.
- `test/pages_test.dart` – renders **every** route at desktop (1400x1000),
  tablet (820x1100) and mobile (390x844) and asserts no layout / RenderFlex
  overflow exceptions.

## Coursework requirement mapping

| Requirement | Where it lives |
| --- | --- |
| **Scaffold** | `Shell` in `lib/widgets.dart` – every page is wrapped in a `Scaffold` with `AppBar`, `endDrawer` and a contextual `FloatingActionButton`. |
| **Container** | `Section` (full-width band + `ConstrainedBox` max width) and `Panel` (rounded, bordered card) in `lib/widgets.dart`; both are `Container`s used across all pages. |
| **Form** | Login / Register (`lib/pages/auth.dart`) and Contact (`lib/pages/contact.dart`) use `Form`, `TextFormField`, validators and `GlobalKey<FormState>`. |
| **RadioList** | Account-type selection (`lib/pages/auth.dart`), payment / shipping choice (`lib/pages/store.dart`) and quiz answering (`lib/pages/learning.dart`) use `RadioGroup` + `RadioListTile`. |
| **Routes** | `MaterialApp.routes` named routes in `lib/main.dart` (21 static routes). |
| **Navigator** | `onGenerateRoute` in `lib/main.dart` for argument-carrying routes (`/course`, `/player`, `/quiz`, `/certificate`, `/product`) and `Navigator.pushNamed` throughout (`go()` helper in `lib/widgets.dart`). |
| **Images / visuals** | 31 brand JPEGs in `assets/images/`, wired through `Img` lists in `lib/data.dart` and rendered with `Image.asset`. |

## Project structure

```
lib/
  main.dart        MaterialApp, named routes, onGenerateRoute
  theme.dart       Brand palette + typography (heading/body helpers)
  data.dart        Models + content seed data (courses, products, stories…)
  widgets.dart     Shell/Scaffold, Section/Container, Panel, cards, nav helper
  pages/
    home.dart        Home page
    public.dart      About, Services, Coaching, Organisations, Programmes,
                     Learning Hub, Insights, Impact
    contact.dart     Contact form
    auth.dart        Login + Register
    learning.dart    Course detail, player, quiz, certificate, learner dashboard
    store.dart       Store, product, cart, checkout, order, orders, library
    dashboards.dart  Employer + Admin dashboards
assets/images/     31 extracted brand images
```

## Routes

`/` `/about` `/services` `/coaching` `/organisations` `/programmes`
`/upskilling` `/insights` `/impact` `/contact` `/login` `/register`
`/store` `/cart` `/checkout` `/order` `/myorders` `/library` `/learner`
`/employer` `/admin` plus argument routes `/course` `/player` `/quiz`
`/certificate` `/product`.

## Brand

Deep Blue `#1B2A4A` · Soft Yellow `#FFD166` · Purple `#6C4AB6`, defined in
`lib/theme.dart` (`Brand`, `buildTheme()`).
