import 'package:flutter/material.dart';

import 'data.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MT Alchemy',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),

      // ---- Named routes (Flutter routing) ----
      initialRoute: '/',
      routes: {
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
      },

      // ---- Routes that carry arguments (Course / Product models) ----
      // Navigator.pushNamed(context, '/course', arguments: course)
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case '/course':
            return _route(
                settings,
                CourseDetailPage(
                    course: args is Course ? args : courses.first));
          case '/player':
            return _route(
                settings,
                CoursePlayerPage(
                    course: args is Course ? args : courses.first));
          case '/quiz':
            return _route(
                settings,
                QuizPage(course: args is Course ? args : courses.first));
          case '/certificate':
            return _route(
                settings,
                CertificatePage(
                    course: args is Course ? args : courses.first));
          case '/product':
            return _route(
                settings,
                ProductDetailPage(
                    product: args is Product ? args : products.first));
          default:
            return _route(settings, const HomePage());
        }
      },
    );
  }

  static MaterialPageRoute _route(RouteSettings settings, Widget page) =>
      MaterialPageRoute(builder: (_) => page, settings: settings);
}
