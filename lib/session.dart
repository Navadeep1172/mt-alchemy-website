import 'package:flutter/foundation.dart';

/// ---------------------------------------------------------------------------
/// Session / authentication state
/// ---------------------------------------------------------------------------
/// The prototype has no server, so the "signed in user" lives in this single
/// [ValueNotifier]. Every screen reads it (via [session]) so the navigation,
/// app bar and dashboards all react to who is logged in and which role they
/// hold. Roles mirror the brief: Guest, Individual Learner, Employer, Trainer
/// and Administrator.
/// ---------------------------------------------------------------------------
enum UserRole {
  guest('Guest'),
  individual('Individual Learner'),
  employer('Employer'),
  trainer('Trainer'),
  administrator('Administrator');

  const UserRole(this.label);
  final String label;

  bool get isStaff =>
      this == UserRole.trainer || this == UserRole.administrator;

  /// The dashboard a role lands on after signing in.
  String get home => switch (this) {
        UserRole.employer => '/employer',
        UserRole.trainer => '/admin',
        UserRole.administrator => '/admin',
        UserRole.individual => '/learner',
        UserRole.guest => '/',
      };
}

class AppUser {
  final String name;
  final String email;
  final UserRole role;
  final String? organization;
  final String phone;
  final String country;

  const AppUser({
    required this.name,
    required this.email,
    required this.role,
    this.organization,
    this.phone = '',
    this.country = 'Malaysia',
  });

  String get firstName {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'there';
    return trimmed.split(RegExp(r'\s+')).first;
  }

  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'MT';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  AppUser copyWith({
    String? name,
    String? email,
    UserRole? role,
    String? organization,
    String? phone,
    String? country,
  }) =>
      AppUser(
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
        organization: organization ?? this.organization,
        phone: phone ?? this.phone,
        country: country ?? this.country,
      );
}

/// The one source of truth for who is signed in.
final ValueNotifier<AppUser?> session = ValueNotifier<AppUser?>(null);

bool get isSignedIn => session.value != null;

void signIn(AppUser user) => session.value = user;

void signOut() => session.value = null;

/// Update the signed-in profile in place (used by the Profile page).
void updateProfile(AppUser user) => session.value = user;
