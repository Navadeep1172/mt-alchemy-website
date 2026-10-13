import 'package:flutter/material.dart';
import '../data.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets.dart';

/// ---------------------------------------------------------------------------
/// Shared dashboard layout (Container-based sidebar + content)
/// ---------------------------------------------------------------------------
class _Dashboard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<NavItem> nav;
  final Widget content;
  const _Dashboard({
    required this.title,
    required this.subtitle,
    required this.nav,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 980;
    final sidebar = Container(
      width: wide ? 250 : double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Brand.teal,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(title, style: heading(20, color: Brand.amber)),
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < nav.length; i++)
            Reveal(
              delay: Duration(milliseconds: i * 40),
              offset: const Offset(24, 0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Material(
                  color: i == 0
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    dense: true,
                    leading: Icon(nav[i].icon,
                        size: 20,
                        color: i == 0 ? Brand.amber : Colors.white70),
                    title: Text(nav[i].label,
                        style: body(14,
                            color: Colors.white,
                            weight:
                                i == 0 ? FontWeight.w700 : FontWeight.w400)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return Shell(children: [
      Section(
        color: Brand.mist,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(subtitle, style: heading(28)),
          const SizedBox(height: 20),
          wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  sidebar,
                  const SizedBox(width: 20),
                  Expanded(child: content),
                ])
              : Column(children: [sidebar, const SizedBox(height: 20), content]),
        ]),
      ),
    ]);
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _Stat(this.value, this.label, this.icon, this.color);
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
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                AnimatedCount(value, style: heading(22)),
                Text(label, style: body(12.5, color: Brand.grey)),
              ]),
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
  static const _nav = [
    NavItem('/learner', 'Dashboard', Icons.dashboard_outlined),
    NavItem('/upskilling', 'My Learning', Icons.school_outlined),
    NavItem('/certificate', 'Certificates', Icons.workspace_premium_outlined),
    NavItem('/myorders', 'My Orders', Icons.receipt_long_outlined),
    NavItem('/library', 'My Digital Products', Icons.cloud_download_outlined),
    NavItem('/login', 'Profile', Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) => _Dashboard(
        title: 'MT Alchemy',
        subtitle: 'Welcome, Navadeep',
        nav: _nav,
        content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CardGrid(children: [
            const _Stat('3', 'Courses enrolled', Icons.school_outlined, Brand.aqua),
            const _Stat('2', 'In progress', Icons.timelapse, Brand.amberDeep),
            const _Stat('1', 'Completed', Icons.verified_outlined, Brand.success),
            const _Stat('6.5h', 'Learning hours', Icons.access_time, Brand.teal),
          ]),
          const SizedBox(height: 20),
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Continue learning', style: heading(20)),
              const SizedBox(height: 16),
              for (final c in courses.take(2)) _courseProgress(context, c),
            ]),
          ),
          const SizedBox(height: 20),
          CardGrid(children: [
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Achievements', style: heading(18)),
                const SizedBox(height: 12),
                _row(Icons.workspace_premium, 'Certificate: Mindfulness at Work'),
                _row(Icons.local_fire_department, '7-day learning streak'),
              ]),
            ),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('My Orders', style: heading(18)),
                const SizedBox(height: 12),
                _row(Icons.check_circle, '#MA1001 · RM120 · Paid'),
                _row(Icons.local_shipping, '#MA1002 · RM85 · Shipped'),
                TextButton(
                    onPressed: () => go(context, '/myorders'),
                    child: const Text('View all orders')),
              ]),
            ),
          ]),
        ]),
      );

  static Widget _courseProgress(BuildContext context, Course c) {
    const progress = 0.65;
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
              Text('65%',
                  style: body(13, color: Brand.teal, weight: FontWeight.w700)),
            ]),
            const SizedBox(height: 6),
            const GradientProgressBar(value: progress, height: 8),
          ]),
        ),
        const SizedBox(width: 14),
        FilledButton(
          style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          onPressed: () =>
              Navigator.pushNamed(context, '/player', arguments: c),
          child: const Text('Continue'),
        ),
      ]),
    );
  }

  static Widget _row(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon, size: 18, color: Brand.aqua),
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
  static const _nav = [
    NavItem('/employer', 'Dashboard', Icons.dashboard_outlined),
    NavItem('/employer', 'Employees', Icons.groups_outlined),
    NavItem('/programmes', 'Assign Courses', Icons.assignment_turned_in_outlined),
    NavItem('/employer', 'Reports', Icons.insights_outlined),
    NavItem('/store', 'Purchase', Icons.shopping_bag_outlined),
  ];

  @override
  Widget build(BuildContext context) => _Dashboard(
        title: 'ABC Sdn Bhd',
        subtitle: 'Employer Dashboard',
        nav: _nav,
        content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CardGrid(children: [
            const _Stat('120', 'Total employees', Icons.groups_outlined, Brand.aqua),
            const _Stat('78', 'Active learners', Icons.school_outlined, Brand.teal),
            const _Stat('12', 'Courses assigned', Icons.menu_book_outlined, Brand.amberDeep),
            const _Stat('64%', 'Completion rate', Icons.percent, Brand.success),
          ]),
          const SizedBox(height: 20),
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(
                onPressed: () {}, icon: const Icon(Icons.person_add), label: const Text('Add Employee')),
            OutlinedButton.icon(
                onPressed: () => go(context, '/programmes'),
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Assign Course')),
          ]),
          const SizedBox(height: 20),
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Employee learning status', style: heading(20)),
              const SizedBox(height: 16),
              _employeeTable(),
            ]),
          ),
          const SizedBox(height: 20),
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Learning reports', style: heading(20)),
                  OutlinedButton(onPressed: () {}, child: const Text('Export PDF')),
                  OutlinedButton(onPressed: () {}, child: const Text('Export CSV')),
                ],
              ),
              const SizedBox(height: 16),
              for (final d in const [
                ('HR', 0.80),
                ('Finance', 0.65),
                ('Sales', 0.55),
                ('Operations', 0.72),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(d.$1, style: body(13.5, weight: FontWeight.w600)),
                      Text('${(d.$2 * 100).round()}%',
                          style: body(13, color: Brand.teal)),
                    ]),
                    const SizedBox(height: 6),
                    GradientProgressBar(value: d.$2, height: 8),
                  ]),
                ),
            ]),
          ),
        ]),
      );

  static Widget _employeeTable() {
    const data = [
      ('Employee A', 'HR', 'EQ Fundamentals', 0.80, 'In Progress'),
      ('Employee B', 'Finance', 'Leadership', 1.0, 'Completed'),
      ('Employee C', 'Sales', 'Communication', 0.45, 'In Progress'),
      ('Employee D', 'Operations', 'Well-being', 1.0, 'Completed'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: body(13, color: Brand.teal, weight: FontWeight.w700),
        dataTextStyle: body(13),
        columns: const [
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Department')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Progress')),
          DataColumn(label: Text('Status')),
        ],
        rows: [
          for (final e in data)
            DataRow(cells: [
              DataCell(Text(e.$1)),
              DataCell(Text(e.$2)),
              DataCell(Text(e.$3)),
              DataCell(SizedBox(
                width: 120,
                child: Row(children: [
                  Expanded(child: GradientProgressBar(value: e.$4, height: 6)),
                  const SizedBox(width: 8),
                  Text('${(e.$4 * 100).round()}%'),
                ]),
              )),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: e.$5 == 'Completed'
                      ? Brand.success.withValues(alpha: 0.14)
                      : Brand.amber.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(e.$5,
                    style: body(11.5,
                        weight: FontWeight.w600,
                        color: e.$5 == 'Completed'
                            ? Brand.success
                            : Brand.teal)),
              )),
            ]),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Admin Portal
/// ---------------------------------------------------------------------------
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});
  static const _nav = [
    NavItem('/admin', 'Dashboard', Icons.dashboard_outlined),
    NavItem('/admin', 'Users', Icons.people_outline),
    NavItem('/admin', 'Organizations', Icons.apartment_outlined),
    NavItem('/admin', 'Courses', Icons.school_outlined),
    NavItem('/admin', 'Assessments', Icons.quiz_outlined),
    NavItem('/admin', 'Certificates', Icons.workspace_premium_outlined),
    NavItem('/admin', 'Products', Icons.inventory_2_outlined),
    NavItem('/admin', 'Orders', Icons.receipt_long_outlined),
    NavItem('/admin', 'Payments', Icons.payments_outlined),
    NavItem('/admin', 'Content', Icons.article_outlined),
    NavItem('/admin', 'Reports', Icons.insights_outlined),
    NavItem('/admin', 'Settings', Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) => _Dashboard(
        title: 'Admin Portal',
        subtitle: 'Platform Overview',
        nav: _nav,
        content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CardGrid(children: [
            const _Stat('1,240', 'Users', Icons.people_outline, Brand.aqua),
            const _Stat('18', 'Organizations', Icons.apartment_outlined, Brand.teal),
            const _Stat('24', 'Courses', Icons.school_outlined, Brand.amberDeep),
            const _Stat('RM42k', 'Revenue', Icons.payments_outlined, Brand.success),
          ]),
          const SizedBox(height: 20),
          CardGrid(children: [
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Course management', style: heading(18)),
                const SizedBox(height: 12),
                _step('Draft', Brand.grey),
                _step('Published', Brand.aqua),
                _step('Archived', Brand.teal),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Create Course')),
              ]),
            ),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Product management', style: heading(18)),
                const SizedBox(height: 12),
                _step('Add product', Brand.grey),
                _step('Set price & stock', Brand.aqua),
                _step('Publish', Brand.teal),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product')),
              ]),
            ),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Order management', style: heading(18)),
                const SizedBox(height: 12),
                _step('Pending', Brand.grey),
                _step('Paid', Brand.amberDeep),
                _step('Shipped', Brand.aqua),
                _step('Delivered', Brand.success),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.list_alt),
                    label: const Text('View Orders')),
              ]),
            ),
          ]),
        ]),
      );

  static Widget _step(String label, Color color) => Padding(
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
