import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data.dart';
import '../motion.dart';
import '../session.dart';
import '../theme.dart';
import '../widgets.dart';
import 'dashboards.dart';

/// ---------------------------------------------------------------------------
/// My Learning - enrolled / in-progress / completed courses
/// ---------------------------------------------------------------------------
class MyLearningPage extends StatefulWidget {
  const MyLearningPage({super.key});
  @override
  State<MyLearningPage> createState() => _MyLearningPageState();
}

class _MyLearningPageState extends State<MyLearningPage> {
  String _tab = 'All';

  List<Course> get _enrolled => app.enrolledCourses;

  List<Course> get _list => switch (_tab) {
        'In Progress' =>
          _enrolled.where((c) => app.progressFor(c.id) < 1).toList(),
        'Completed' => _enrolled.where((c) => app.isCompleted(c.id)).toList(),
        _ => _enrolled,
      };

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => _build(context),
      );

  Widget _build(BuildContext context) => PortalScaffold(
        title: 'My Learning',
        subtitle: 'Track your enrolled, in-progress and completed courses.',
        nav: learnerNav,
        actions: [
          FilledButton.icon(
              onPressed: () => go(context, '/upskilling'),
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Find a course')),
        ],
        content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final t in ['All', 'In Progress', 'Completed'])
              ChoiceChip(
                label: Text(t),
                selected: _tab == t,
                selectedColor: Brand.green,
                labelStyle: TextStyle(
                    color: _tab == t ? Colors.white : Brand.green,
                    fontWeight: FontWeight.w600),
                onSelected: (_) => setState(() => _tab = t),
              ),
          ]),
          const SizedBox(height: 22),
          if (_list.isEmpty)
            Panel(
              child: Row(children: [
                const Icon(Icons.school_outlined, color: Brand.sage),
                const SizedBox(width: 12),
                Expanded(
                    child: Text('No courses in this view yet.',
                        style: body(15, color: Brand.grey))),
                TextButton(
                    onPressed: () => go(context, '/upskilling'),
                    child: const Text('Browse the Learning Hub')),
              ]),
            )
          else
            Column(children: [
              for (final c in _list)
                _courseRow(context, c, app.progressFor(c.id)),
            ]),
        ]),
      );

  Widget _courseRow(BuildContext context, Course c, double p) {
    final done = p >= 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Panel(
        child: LayoutBuilder(builder: (context, box) {
          final wide = box.maxWidth >= 620;
          final info = Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(c.image,
                  width: 92, height: 92, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                      child: Text(c.title, style: heading(18), maxLines: 2,
                          overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  _statusChip(done ? 'Completed' : 'In Progress'),
                ]),
                const SizedBox(height: 6),
                Text('${c.category} · ${c.instructor} · ${c.duration}',
                    style: body(12.5, color: Brand.grey)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                      child: GradientProgressBar(value: p, height: 8)),
                  const SizedBox(width: 10),
                  Text('${(p * 100).round()}%',
                      style:
                          body(13, color: Brand.green, weight: FontWeight.w700)),
                ]),
              ]),
            ),
          ]);
          final cta = FilledButton.icon(
            onPressed: () => go(context, '/player'),
            icon: Icon(done ? Icons.replay : Icons.play_arrow),
            label: Text(done ? 'Review' : 'Continue'),
          );
          return wide
              ? Row(children: [
                  Expanded(child: info),
                  const SizedBox(width: 16),
                  cta,
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  info,
                  const SizedBox(height: 14),
                  SizedBox(width: double.infinity, child: cta),
                ]);
        }),
      ),
    );
  }

  static Widget _statusChip(String label) {
    final done = label == 'Completed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (done ? Brand.success : Brand.clay).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: body(11.5,
              color: done ? Brand.success : Brand.green,
              weight: FontWeight.w700)),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Certificates - list of earned certificates with view + download
/// ---------------------------------------------------------------------------
class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  // courseId -> completion date shown on the certificate card.
  static const _earned = <String, String>{
    'mind102': '13 Oct 2026',
    'eq101': '02 Sep 2026',
  };

  @override
  Widget build(BuildContext context) {
    final earned = courses.where((c) => _earned.containsKey(c.id)).toList();
    return PortalScaffold(
      title: 'Certificates',
      subtitle: 'View, verify and download your MT Alchemy certificates.',
      nav: learnerNav,
      actions: [
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.verified_outlined, size: 18),
            label: const Text('Verify a certificate')),
      ],
      content: earned.isEmpty
          ? Panel(
              child: Text('Complete a course to earn your first certificate.',
                  style: body(15, color: Brand.grey)))
          : CardGrid(children: [
              for (final c in earned) _certificateCard(context, c),
            ]),
    );
  }

  Widget _certificateCard(BuildContext context, Course c) => Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Brand.forestDark, Brand.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.workspace_premium,
                      color: Brand.clay, size: 26),
                  const Spacer(),
                  Text('MTA-${c.id.toUpperCase()}-0001',
                      style: body(11, color: Colors.white54)),
                ]),
                Text('Certificate of Completion',
                    style: body(12, color: Brand.sageLight)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(c.title, style: heading(18), maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text('Awarded ${_earned[c.id]} · ${c.instructor}',
              style: body(12.5, color: Brand.grey)),
          const SizedBox(height: 16),
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/certificate',
                  arguments: c),
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('View'),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Download'),
            ),
          ]),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Profile - view and edit account details
/// ---------------------------------------------------------------------------
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _org;
  String _country = 'Malaysia';
  UserRole _role = UserRole.individual;

  @override
  void initState() {
    super.initState();
    final u = session.value;
    _name = TextEditingController(text: u?.name ?? '');
    _email = TextEditingController(text: u?.email ?? '');
    _phone = TextEditingController(text: u?.phone ?? '');
    _org = TextEditingController(text: u?.organization ?? '');
    _country = u?.country ?? 'Malaysia';
    _role = u?.role ?? UserRole.individual;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _org.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  String? _validEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim());
    return ok ? null : 'Invalid email format';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    updateProfile(AppUser(
      name: _name.text.trim(),
      email: _email.text.trim(),
      role: _role,
      organization: _org.text.trim().isEmpty ? null : _org.text.trim(),
      phone: _phone.text.trim(),
      country: _country,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: 'Profile',
        subtitle: 'Manage your personal details and account security.',
        nav: learnerNav,
        content: LayoutBuilder(builder: (context, box) {
          final wide = box.maxWidth >= 860;
          final form = Panel(
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Personal details', style: heading(20)),
                const SizedBox(height: 18),
                _field(_name, 'Full name', Icons.person_outline, _required),
                _field(_email, 'Email address', Icons.email_outlined,
                    _validEmail,
                    keyboard: TextInputType.emailAddress),
                _field(_phone, 'Phone', Icons.phone_outlined, null,
                    keyboard: TextInputType.phone),
                if (_role == UserRole.employer)
                  _field(_org, 'Organization', Icons.apartment_outlined, null),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: _country,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: 'Country', prefixIcon: Icon(Icons.public)),
                  items: [
                    for (final c in countries)
                      DropdownMenuItem(value: c, child: Text(c)),
                  ],
                  onChanged: (v) => setState(() => _country = v!),
                ),
                const SizedBox(height: 22),
                Text('Security', style: heading(20)),
                const SizedBox(height: 16),
                _field(TextEditingController(), 'New password', Icons.lock_outline,
                    null, obscure: true),
                _field(TextEditingController(), 'Confirm password',
                    Icons.lock_reset_outlined, null, obscure: true),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save changes')),
                ),
              ]),
            ),
          );

          final side = Panel(
            color: Brand.forestDark,
            child: ValueListenableBuilder<AppUser?>(
              valueListenable: session,
              builder: (context, user, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Brand.clay, Brand.clayDeep]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(user?.initials ?? 'MT',
                        style: heading(24,
                            color: Brand.ink, weight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 16),
                  Text(user?.name ?? 'Guest',
                      style: heading(20, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(user?.role.label ?? 'Guest',
                      style: body(13, color: Brand.sageLight)),
                  const SizedBox(height: 18),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 12),
                  _sideRow(Icons.verified_user_outlined, 'Role-based access'),
                  _sideRow(Icons.workspace_premium_outlined,
                      '${app.certifiedCourses.length} certificates'),
                  _sideRow(Icons.school_outlined,
                      '${app.enrolledCourses.length} courses enrolled'),
                  const SizedBox(height: 8),
                  Text(user?.email ?? '—',
                      style: body(12.5, color: Colors.white54)),
                ],
              ),
            ),
          );

          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 3, child: form),
                  const SizedBox(width: 20),
                  SizedBox(width: 300, child: side),
                ])
              : Column(children: [form, const SizedBox(height: 20), side]);
        }),
      );

  Widget _field(TextEditingController controller, String label, IconData icon,
          String? Function(String?)? validator,
          {TextInputType? keyboard, bool obscure = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          obscureText: obscure,
          decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
          validator: validator,
        ),
      );

  static Widget _sideRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon, size: 18, color: Brand.clay),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: body(13.5, color: Colors.white70))),
        ]),
      );
}
