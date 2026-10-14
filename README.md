# MT Alchemy Website

**Live site: https://navadeep1172.github.io/mt-alchemy-website/**

A Flutter (web + mobile) prototype for **MT Alchemy (Kaedae Event Management)**,
built for the INTI **NET4207** coursework. It covers the four core modules from
the brief: the **public marketing site**, the **Learning Management System
(LMS)**, the **online store**, and the **admin / dashboard** area, across **26
routes** and **5 user roles**.

## Viewing the site

The prototype is deployed to GitHub Pages and can be opened directly in any
browser (no install required):

**https://navadeep1172.github.io/mt-alchemy-website/**

## Running locally

```bash
flutter pub get
flutter run -d chrome        # run as a web app
# or
flutter build web --release  # production build into build/web
```

## Deploying updates

After changing the code, publish the new build to the `gh-pages` branch:

```powershell
powershell -ExecutionPolicy Bypass -File tool\deploy_gh_pages.ps1 `
    -RepoUrl https://github.com/Navadeep1172/mt-alchemy-website.git
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
| **Routes** | Named routes in `lib/main.dart` (`routeBuilders` map, 21 static routes). |
| **Navigator** | `onGenerateRoute` in `lib/main.dart` for argument-carrying routes (`/course`, `/player`, `/quiz`, `/certificate`, `/product`) and `Navigator.pushNamed` throughout (`go()` helper in `lib/widgets.dart`). |
| **Images / visuals** | 31 brand JPEGs in `assets/images/`, wired through `Img` lists in `lib/data.dart` and rendered with `Image.asset`. |

## Motion & interaction design

The interface is deliberately animated; every effect lives in `lib/motion.dart`.

The motion is deliberately restrained so the site reads as a professional
consultancy rather than a demo reel:

| Effect | Where it appears |
| --- | --- |
| `Reveal` – scroll-triggered fade + rise with stagger | every `Section`, `CardGrid` child and `SectionHeading` |
| `HoverLift` / `HoverZoom` – faint lift, slow image zoom | course, product, story, service cards, stats |
| `AnimatedBackdrop` – softly drifting aurora wash | hero bands, CTA band, drawer header |
| `Marquee` – slow capability ticker | home page |
| `AnimatedCount` | impact figure and dashboard KPIs |
| `GradientText` – faint green-to-clay sheen | hero heading |
| `GradientProgressBar` | course and dashboard progress |
| `DrawBar` – clay rule that draws itself in | every `SectionHeading` |
| `fadeSlideRoute` – gentle fade + rise | page transition for every route |
| reading-progress accent bar, nav underline | `Shell` |

All looping motion honours the OS "reduce motion" accessibility setting
(`MediaQuery.disableAnimations`). `test/pages_test.dart` mutes tickers with
`TickerMode(enabled: false)` for deterministic layout assertions across every
route and breakpoint, while `test/animation_test.dart` runs the animations with
fixed pumps to prove they never throw.

## Project structure

```
lib/
  main.dart        MaterialApp, named routes, onGenerateRoute + transitions
  theme.dart       Brand palette, typography, animated button styles
  motion.dart      Animation system (reveal, hover, aurora, marquee, count…)
  data.dart        Models + content seed data (courses, products, stories…)
  widgets.dart     Shell/Scaffold, Section/Container, Panel, cards, nav helper
  session.dart     Auth/session state + roles (Guest, Individual, Employer,
                   Trainer, Administrator)
  pages/
    home.dart        Home page
    public.dart      About, Services, Coaching, Organisations, Programmes,
                     Learning Hub, Insights, Impact
    contact.dart     Contact form
    auth.dart        Login (with role selection) + Register
    learning.dart    Course detail, player, quiz (4 question types), certificate
    account.dart     My Learning, Certificates, Profile (signed-in learner)
    store.dart       Store, product, cart, checkout, order, orders, library
    dashboards.dart  PortalScaffold + Learner / Employer / Admin dashboards
assets/images/     31 extracted brand images
```

## Routes

`/` `/about` `/services` `/coaching` `/organisations` `/programmes`
`/upskilling` `/insights` `/impact` `/contact` `/login` `/register`
`/store` `/cart` `/checkout` `/order` `/myorders` `/library` `/learner`
`/mylearning` `/certificates` `/profile` `/employer` `/admin` plus argument
routes `/course` `/player` `/quiz` `/certificate` `/product`.

## Roles, sign-in and portals

Sign-in is role-based (`lib/session.dart`). The Login page lets you pick a role;
Register creates an Individual or Employer account. After signing in the app bar
swaps the Login button for an account menu, and the shared `PortalScaffold`
(`lib/pages/dashboards.dart`) gives every portal a working, active-aware sidebar:

| Role | Lands on | Portal |
| --- | --- | --- |
| Individual Learner | `/learner` | Dashboard, My Learning, Certificates, My Orders, Digital Products, Profile |
| Employer | `/employer` | Dashboard, Employees, Assign Courses, Reports, Purchase, Profile |
| Trainer | `/admin` | Trainer home, courses, materials, learners, profile |
| Administrator | `/admin` | Full admin (users, orgs, courses, products, orders, payments, reports, settings) |

## Brand

Forest `#1E3226` · Green `#2F6B4F` · Clay `#C97B4A` · Sage `#7E9B87` on a warm
ivory canvas (`paper #FCFAF6`, `mist #F8F5EF`, `sageTint #EDF3EC`), defined in
`lib/theme.dart` (`Brand`, `buildTheme()`). Forest anchors headings and dark
bands, green carries the consultancy voice and primary actions, clay marks
calls to action and accents, and sage is reserved for progress and secondary
detail. Small text colours were chosen to keep AA contrast on their
backgrounds.
