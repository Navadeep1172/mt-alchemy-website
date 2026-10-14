import 'package:flutter/material.dart';

import 'app_state.dart';
import 'data.dart';
import 'motion.dart';
import 'theme.dart';
import 'pages/account.dart';
import 'pages/admin.dart';
import 'pages/auth.dart';
import 'pages/contact.dart';
import 'pages/dashboards.dart';
import 'pages/employer.dart';
import 'pages/home.dart';
import 'pages/learning.dart';
import 'pages/public.dart';
import 'pages/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await app.load();
  runApp(const MtAlchemyApp());
}

class MtAlchemyApp extends StatelessWidget {
  const MtAlchemyApp({super.key});

  /// Named routes (Flutter routing) - the source of truth for the prototype.
  static final Map<String, WidgetBuilder> routeBuilders = {
    '/': (_) => const HomePage(),
    '/about': (_) => const AboutPage(),
    '/services': (_) => const ServicesPage(),
    '/coaching': (_) => const CoachingPage(),
    '/organisations': (_) => const OrganisationsPage(),
    '/programmes': (_) => const ProgrammesPage(),
    '/upskilling': (_) => const LearningHubPage(),
    '/insights': (_) => const InsightsPage(),
    '/impact': (_) => const ImpactPage(),
    '/contact': (_) => const ContactPage(),
    '/login': (_) => const LoginPage(),
    '/register': (_) => const RegisterPage(),
    '/store': (_) => const StorePage(),
    '/cart': (_) => const CartPage(),
    '/checkout': (_) => const CheckoutPage(),
    '/order': (_) => const OrderConfirmationPage(),
    '/myorders': (_) => const MyOrdersPage(),
    '/library': (_) => const DigitalLibraryPage(),
    '/learner': (_) => const LearnerDashboardPage(),
    '/mylearning': (_) => const MyLearningPage(),
    '/certificates': (_) => const CertificatesPage(),
    '/profile': (_) => const ProfilePage(),
    '/employer': (_) => const EmployerDashboardPage(),
    '/employer/employees': (_) => const EmployerEmployeesPage(),
    '/employer/assign': (_) => const EmployerAssignPage(),
    '/employer/reports': (_) => const EmployerReportsPage(),
    '/admin': (_) => const AdminDashboardPage(),
    '/admin/users': (_) => const AdminUsersPage(),
    '/admin/organizations': (_) => const AdminOrganizationsPage(),
    '/admin/courses': (_) => const AdminCoursesPage(),
    '/admin/assessments': (_) => const AdminAssessmentsPage(),
    '/admin/certificates': (_) => const AdminCertificatesPage(),
    '/admin/products': (_) => const AdminProductsPage(),
    '/admin/orders': (_) => const AdminOrdersPage(),
    '/admin/payments': (_) => const AdminPaymentsPage(),
    '/admin/content': (_) => const AdminContentPage(),
    '/admin/reports': (_) => const AdminReportsPage(),
    '/admin/settings': (_) => const AdminSettingsPage(),
    '/admin/materials': (_) => const AdminMaterialsPage(),
    '/admin/learners': (_) => const AdminLearnersPage(),
  };

  /// Routes that carry a model argument. Called via
  /// `Navigator.pushNamed(context, '/course', arguments: course)`.
  static final Map<String, Widget Function(Object?)> argumentBuilders = {
    '/course': (a) =>
        CourseDetailPage(course: a is Course ? a : courses.first),
    '/player': (a) =>
        CoursePlayerPage(course: a is Course ? a : courses.first),
    '/quiz': (a) => QuizPage(course: a is Course ? a : courses.first),
    '/certificate': (a) =>
        CertificatePage(course: a is Course ? a : courses.first),
    '/product': (a) =>
        ProductDetailPage(product: a is Product ? a : products.first),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MT Alchemy',
      debugShowCheckedModeBanner: false,
      theme: buildTheme().copyWith(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          for (final platform in TargetPlatform.values)
            platform: const FadeSlidePageTransitionsBuilder(),
        }),
      ),

      // ---- Routing ----
      // Every page is pushed through [fadeSlideRoute] so the whole app shares
      // one animated transition (fade + rise), including the argument routes.
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final name = settings.name ?? '/';
        final argumentBuilder = argumentBuilders[name];
        if (argumentBuilder != null) {
          return fadeSlideRoute(settings, argumentBuilder(settings.arguments));
        }
        final builder = routeBuilders[name];
        if (builder != null) return fadeSlideRoute(settings, builder(context));
        // Portal sub-routes (e.g. /employer/reports, /admin/users) resolve to
        // their parent overview screen so every sidebar link is a real link.
        if (name.startsWith('/admin')) {
          return fadeSlideRoute(settings, const AdminDashboardPage());
        }
        if (name.startsWith('/employer')) {
          return fadeSlideRoute(settings, const EmployerDashboardPage());
        }
        return fadeSlideRoute(settings, routeBuilders['/']!(context));
      },
    );
  }
}