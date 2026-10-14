import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data.dart';
import '../motion.dart';
import '../session.dart';
import '../theme.dart';
import '../widgets.dart';

/// ---------------------------------------------------------------------------
/// Portal navigation (shared by every logged-in portal)
/// ---------------------------------------------------------------------------
const learnerNav = <NavItem>[
  NavItem('/learner', 'Dashboard', Icons.dashboard_outlined),
  NavItem('/mylearning', 'My Learning', Icons.school_outlined),
  NavItem('/certificates', 'Certificates', Icons.workspace_premium_outlined),
  NavItem('/myorders', 'My Orders', Icons.receipt_long_outlined),
  NavItem('/library', 'Digital Products', Icons.cloud_download_outlined),
  NavItem('/profile', 'Profile', Icons.person_outline),
];

const employerNav = <NavItem>[
  NavItem('/employer', 'Dashboard', Icons.dashboard_outlined),
  NavItem('/employer/employees', 'Employees', Icons.groups_outlined),
  NavItem('/employer/assign', 'Assign Courses', Icons.assignment_turned_in_outlined),
  NavItem('/employer/reports', 'Reports', Icons.insights_outlined),
  NavItem('/store', 'Purchase', Icons.shopping_bag_outlined),
  NavItem('/profile', 'Profile', Icons.person_outline),
];

const adminNav = <NavItem>[
  NavItem('/admin', 'Dashboard', Icons.dashboard_outlined),
  NavItem('/admin/users', 'Users', Icons.people_outline),
  NavItem('/admin/organizations', 'Organizations', Icons.apartment_outlined),
  NavItem('/admin/courses', 'Courses', Icons.school_outlined),
  NavItem('/admin/assessments', 'Assessments', Icons.quiz_outlined),
  NavItem('/admin/certificates', 'Certificates', Icons.workspace_premium_outlined),
  NavItem('/admin/products', 'Products', Icons.inventory_2_outlined),
  NavItem('/admin/orders', 'Orders', Icons.receipt_long_outlined),
  NavItem('/admin/payments', 'Payments', Icons.payments_outlined),
  NavItem('/admin/content', 'Content', Icons.article_outlined),
  NavItem('/admin/reports', 'Reports', Icons.insights_outlined),
  NavItem('/admin/settings', 'Settings', Icons.settings_outlined),
];

/// ---------------------------------------------------------------------------
/// PortalScaffold - the professional shell used by every dashboard/portal.
/// It replaces the old non-interactive sidebar: every navigation item is now a
/// real link with an active state, and the header carries the page title, a
/// signed-in user chip and quick actions.
/// ---------------------------------------------------------------------------
class PortalScaffold extends StatelessWidget {
  final String workspace;
  final String title;
  final String subtitle;
  final List<NavItem> nav;
  final Widget content;
  final List<Widget> actions;
  const PortalScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.nav,
    required this.content,
    this.workspace = 'MT Alchemy',
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 1024;
    final sidebar = _PortalSidebar(workspace: workspace, nav: nav);
    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PortalHeader(title: title, subtitle: subtitle, actions: actions),
        const SizedBox(height: 22),
        content,
      ],
    );

    return Shell(children: [
      Section(
        color: Brand.mist,
        vertical: 34,
        child: wide
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                sidebar,
                const SizedBox(width: 24),
                Expanded(child: main),
              ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [sidebar, const SizedBox(height: 22), main]),
      ),
    ]);
  }
}

class _PortalHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> actions;
  const _PortalHeader({
    required this.title,
    required this.subtitle,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: heading(28)),
        const SizedBox(height: 4),
        Text(subtitle, style: body(14, color: Brand.grey)),
      ],
    );
    if (actions.isEmpty) return text;
    return LayoutBuilder(builder: (context, box) {
      final wide = box.maxWidth >= 640;
      return wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: text),
                Wrap(spacing: 10, runSpacing: 10, children: actions),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text,
                const SizedBox(height: 14),
                Wrap(spacing: 10, runSpacing: 10, children: actions),
              ],
            );
    });
  }
}

class _PortalSidebar extends StatelessWidget {
  final String workspace;
  final List<NavItem> nav;
  const _PortalSidebar({required this.workspace, required this.nav});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 1024;
    final route = ModalRoute.of(context)?.settings.name;

    return Container(
      width: wide ? 264 : double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Brand.forestDark, Brand.greenDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x222A2A24), blurRadius: 26, offset: Offset(0, 12)),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _UserCard(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(workspace.toUpperCase(),
                  style: body(11,
                          color: Brand.sageLight, weight: FontWeight.w700)
                      .copyWith(letterSpacing: 1.6)),
            ),
            for (final item in nav)
              _PortalNavTile(item: item, active: item.path == route),
            const SizedBox(height: 12),
            Divider(color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 4),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.logout, size: 20, color: Brand.clay),
              title: Text('Sign out',
                  style: body(14,
                      color: Colors.white70, weight: FontWeight.w600)),
              onTap: () {
                signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (r) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: session,
      builder: (context, user, _) {
        if (user == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Brand.clay, Brand.clayDeep],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(user.initials,
                  style: heading(15, color: Brand.ink, weight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: body(14,
                          color: Colors.white, weight: FontWeight.w700)),
                  Text(user.role.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: body(11.5, color: Brand.sageLight)),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}

class _PortalNavTile extends StatefulWidget {
  final NavItem item;
  final bool active;
  const _PortalNavTile({required this.item, required this.active});

  @override
  State<_PortalNavTile> createState() => _PortalNavTileState();
}

class _PortalNavTileState extends State<_PortalNavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final on = widget.active || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () {
          if (!widget.active) go(context, widget.item.path);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          decoration: BoxDecoration(
            color: widget.active
                ? Colors.white.withValues(alpha: 0.14)
                : _hover
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 3,
              height: 20,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: widget.active ? Brand.clay : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Icon(widget.item.icon,
                size: 20,
                color: widget.active
                    ? Brand.clay
                    : on
                        ? Colors.white
                        : Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: body(14,
                    color: Colors.white,
                    weight: widget.active ? FontWeight.w700 : FontWeight.w500),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// KPI tile used across the dashboards.
class DashStat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  final String? delta;
  const DashStat(this.value, this.label, this.icon, this.color,
      {super.key, this.delta});

  @override
  Widget build(BuildContext context) => HoverLift(
        glow: color,
        cursorClick: false,
        child: Panel(
          child: Row(children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedCount(value, style: heading(22)),
                    Text(label, style: body(12.5, color: Brand.grey)),
                  ]),
            ),
            if (delta != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Brand.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(delta!,
                    style: body(11.5,
                        color: Brand.success, weight: FontWeight.w700)),
              ),
          ]),
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Learner Dashboard
/// ---------------------------------------------------------------------------
class LearnerDashboardPage extends StatelessWidget {
  const LearnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final name = session.value?.firstName ?? 'Learner';
          final enrolled = app.enrolledCourses;
          final inProgress =
              enrolled.where((c) => !app.isCompleted(c.id)).length;
          final completed = enrolled.where((c) => app.isCompleted(c.id)).length;
          return PortalScaffold(
            title: 'Welcome back, $name',
            subtitle: 'Your learning at a glance.',
            nav: learnerNav,
            actions: [
              FilledButton.icon(
                  onPressed: () => go(context, '/upskilling'),
                  icon: const Icon(Icons.explore_outlined),
                  label: const Text('Browse courses')),
            ],
            content:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CardGrid(children: [
                DashStat('${enrolled.length}', 'Courses enrolled',
                    Icons.school_outlined, Brand.sage),
                DashStat('$inProgress', 'In progress', Icons.timelapse,
                    Brand.clayDeep),
                DashStat('$completed', 'Completed', Icons.verified_outlined,
                    Brand.success),
                DashStat('${app.certifiedCourses.length}', 'Certificates',
                    Icons.workspace_premium_outlined, Brand.green),
              ]),
              const SizedBox(height: 20),
              Panel(
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                        child: Text('Continue learning', style: heading(20))),
                    TextButton(
                        onPressed: () => go(context, '/mylearning'),
                        child: const Text('View all')),
                  ]),
                  const SizedBox(height: 16),
                  if (enrolled.isEmpty)
                    Text('You have not enrolled in any courses yet.',
                        style: body(14, color: Brand.grey))
                  else
                    for (final c in enrolled.take(2))
                      _courseProgress(context, c),
                ]),
              ),
              const SizedBox(height: 20),
              CardGrid(children: [
                Panel(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Achievements', style: heading(18)),
                        const SizedBox(height: 12),
                        if (app.certifiedCourses.isEmpty)
                          _row(Icons.emoji_events_outlined,
                              'Complete a course to earn a certificate')
                        else
                          for (final c in app.certifiedCourses.take(3))
                            _row(Icons.workspace_premium,
                                'Certificate: ${c.title}'),
                      ]),
                ),
                Panel(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recent orders', style: heading(18)),
                        const SizedBox(height: 12),
                        if (app.orders.isEmpty)
                          _row(Icons.shopping_bag_outlined,
                              'No orders yet - visit the store')
                        else
                          for (final o in app.orders.take(3))
                            _row(
                                o.hasPhysical
                                    ? Icons.local_shipping
                                    : Icons.cloud_download_outlined,
                                '${o.id} · RM${o.total.toStringAsFixed(0)} · ${o.status}'),
                        TextButton(
                            onPressed: () => go(context, '/myorders'),
                            child: const Text('View all orders')),
                      ]),
                ),
              ]),
            ]),
          );
        },
      );

  static Widget _courseProgress(BuildContext context, Course c) {
    final progress = app.progressFor(c.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(c.image, width: 64, height: 64, fit: BoxFit.cover),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(c.title,
                      overflow: TextOverflow.ellipsis,
                      style: body(14.5, weight: FontWeight.w600))),
              const SizedBox(width: 8),
              Text('${(progress * 100).round()}%',
                  style: body(13, color: Brand.green, weight: FontWeight.w700)),
            ]),
            const SizedBox(height: 6),
            GradientProgressBar(value: progress, height: 8),
          ]),
        ),
        const SizedBox(width: 14),
        FilledButton(
          style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          onPressed: () =>
              Navigator.pushNamed(context, '/player', arguments: c),
          child: Text(progress >= 1 ? 'Review' : 'Continue'),
        ),
      ]),
    );
  }

  static Widget _row(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon, size: 18, color: Brand.sage),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: body(14))),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Employer / Corporate Dashboard
/// ---------------------------------------------------------------------------
class EmployerDashboardPage extends StatelessWidget {
  const EmployerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final employees = app.employees;
          final active = employees.where((e) => e.completion > 0).length;
          final rate = employees.isEmpty
              ? 0.0
              : employees.fold<double>(0, (s, e) => s + e.completion) /
                  employees.length;

          // Group completion by department.
          final depts = <String, List<double>>{};
          for (final e in employees) {
            depts.putIfAbsent(e.department, () => []).add(e.completion);
          }

          return PortalScaffold(
            workspace: session.value?.organization ?? 'ABC Sdn Bhd',
            title: 'Employer Dashboard',
            subtitle: 'Manage your people, courses and reporting.',
            nav: employerNav,
            actions: [
              FilledButton.icon(
                  onPressed: () => go(context, '/employer/employees'),
                  icon: const Icon(Icons.person_add_alt),
                  label: const Text('Add Employee')),
              OutlinedButton.icon(
                  onPressed: () => go(context, '/employer/assign'),
                  icon: const Icon(Icons.assignment_turned_in_outlined),
                  label: const Text('Assign Course')),
            ],
            content:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CardGrid(children: [
                DashStat('${employees.length}', 'Total employees',
                    Icons.groups_outlined, Brand.sage),
                DashStat('$active', 'Active learners', Icons.school_outlined,
                    Brand.green),
                DashStat('${app.assignments.length}', 'Courses assigned',
                    Icons.menu_book_outlined, Brand.clayDeep),
                DashStat('${(rate * 100).round()}%', 'Completion rate',
                    Icons.percent, Brand.success),
              ]),
              const SizedBox(height: 20),
              Panel(
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                        child:
                            Text('Employee learning status', style: heading(20))),
                    TextButton(
                        onPressed: () => go(context, '/employer/employees'),
                        child: const Text('Manage')),
                  ]),
                  const SizedBox(height: 12),
                  if (employees.isEmpty)
                    Text('No employees added yet.',
                        style: body(14, color: Brand.grey))
                  else
                    _employeeTable(employees),
                ]),
              ),
              const SizedBox(height: 20),
              Panel(
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Learning reports by department', style: heading(20)),
                      OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Report exported as PDF')),
                            );
                          },
                          icon: const Icon(Icons.picture_as_pdf_outlined,
                              size: 18),
                          label: const Text('Export PDF')),
                      OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Report exported as CSV')),
                            );
                          },
                          icon: const Icon(Icons.table_chart_outlined, size: 18),
                          label: const Text('Export CSV')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (final d in depts.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Builder(builder: (context) {
                        final avg =
                            d.value.reduce((a, b) => a + b) / d.value.length;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(d.key,
                                        style: body(13.5,
                                            weight: FontWeight.w600)),
                                    Text('${(avg * 100).round()}%',
                                        style:
                                            body(13, color: Brand.green)),
                                  ]),
                              const SizedBox(height: 6),
                              GradientProgressBar(value: avg, height: 8),
                            ]);
                      }),
                    ),
                ]),
              ),
            ]),
          );
        },
      );

  static Widget _employeeTable(List<Employee> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: body(13, color: Brand.green, weight: FontWeight.w700),
        dataTextStyle: body(13),
        columns: const [
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Department')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Progress')),
          DataColumn(label: Text('Status')),
        ],
        rows: [
          for (final e in employees)
            DataRow(cells: [
              DataCell(Text(e.name)),
              DataCell(Text(e.department)),
              DataCell(Text(_courseFor(e.email))),
              DataCell(SizedBox(
                width: 120,
                child: Row(children: [
                  Expanded(child: GradientProgressBar(value: e.completion, height: 6)),
                  const SizedBox(width: 8),
                  Text('${(e.completion * 100).round()}%'),
                ]),
              )),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: e.completion >= 1
                      ? Brand.success.withValues(alpha: 0.14)
                      : Brand.clay.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(e.completion >= 1 ? 'Completed' : 'In Progress',
                    style: body(11.5,
                        weight: FontWeight.w600,
                        color: e.completion >= 1
                            ? Brand.success
                            : Brand.green)),
              )),
            ]),
        ],
      ),
    );
  }

  static String _courseFor(String email) {
    for (final a in app.assignments) {
      if (a.employeeEmail == email) {
        return app.courseById(a.courseId)?.title ?? a.courseId;
      }
    }
    return '—';
  }
}

/// ---------------------------------------------------------------------------
/// Admin / Trainer Portal
/// ---------------------------------------------------------------------------
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTrainer = session.value?.role == UserRole.trainer;
    final nav = isTrainer
        ? const <NavItem>[
            NavItem('/admin', 'Trainer Home', Icons.dashboard_outlined),
            NavItem('/admin/courses', 'My Courses', Icons.school_outlined),
            NavItem('/admin/materials', 'Materials', Icons.folder_outlined),
            NavItem('/admin/learners', 'Learners', Icons.groups_outlined),
            NavItem('/profile', 'Profile', Icons.person_outline),
          ]
        : adminNav;

    return PortalScaffold(
      workspace: isTrainer ? 'Trainer Studio' : 'Admin Portal',
      title: isTrainer ? 'Trainer Dashboard' : 'Platform Overview',
      subtitle: isTrainer
          ? 'Your assigned courses, materials and learner monitoring.'
          : 'Everything across users, courses, store and reporting.',
      nav: nav,
      actions: [
        FilledButton.icon(
            onPressed: () => go(context, '/admin/courses'),
            icon: const Icon(Icons.add),
            label: Text(isTrainer ? 'New Module' : 'Create Course')),
      ],
      content: ListenableBuilder(
        listenable: app,
        builder: (context, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardGrid(children: [
                DashStat('1,240', 'Users', Icons.people_outline, Brand.sage,
                    delta: '+32'),
                DashStat('18', 'Organizations', Icons.apartment_outlined,
                    Brand.green),
                DashStat('${app.courses.length}', 'Courses',
                    Icons.school_outlined, Brand.clayDeep),
                DashStat('${app.products.length}', 'Products',
                    Icons.inventory_2_outlined, Brand.success),
              ]),
              const SizedBox(height: 20),
              CardGrid(children: [
                Panel(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Course management', style: heading(18)),
                        const SizedBox(height: 12),
                        const _Step('Draft', Brand.grey),
                        const _Step('Published', Brand.sage),
                        const _Step('Archived', Brand.green),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                            onPressed: () => go(context, '/admin/courses'),
                            icon: const Icon(Icons.add),
                            label: const Text('Create Course')),
                      ]),
                ),
                Panel(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Product management', style: heading(18)),
                        const SizedBox(height: 12),
                        const _Step('Add product', Brand.grey),
                        const _Step('Set price & stock', Brand.sage),
                        const _Step('Publish', Brand.green),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                            onPressed: () => go(context, '/admin/products'),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product')),
                      ]),
                ),
                Panel(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order management', style: heading(18)),
                        const SizedBox(height: 12),
                        const _Step('Pending', Brand.grey),
                        const _Step('Paid', Brand.clayDeep),
                        const _Step('Shipped', Brand.sage),
                        const _Step('Delivered', Brand.success),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                            onPressed: () => go(context, '/admin/orders'),
                            icon: const Icon(Icons.list_alt),
                            label: Text(
                                'View Orders (${app.orders.length})')),
                      ]),
                ),
              ]),
            ]),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String label;
  final Color color;
  const _Step(this.label, this.color);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: body(14))),
        ]),
      );
}
