import 'package:flutter/material.dart';

import 'data.dart';
import 'motion.dart';
import 'theme.dart';
import 'pages/auth.dart';
import 'pages/contact.dart';
import 'pages/dashboards.dart';
import 'pages/home.dart';
import 'pages/learning.dart';
import 'pages/public.dart';
import 'pages/store.dart';

void main() => runApp(const MtAlchemyApp());

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
    '/employer': (_) => const EmployerDashboardPage(),
    '/admin': (_) => const AdminDashboardPage(),
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
        final argumentBuilder = argumentBuilders[settings.name];
        if (argumentBuilder != null) {
          return fadeSlideRoute(settings, argumentBuilder(settings.arguments));
        }
        final builder = routeBuilders[settings.name] ?? routeBuilders['/']!;
        return fadeSlideRoute(settings, builder(context));
      },
    );
  }
}