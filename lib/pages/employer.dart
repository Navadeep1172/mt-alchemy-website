import 'package:flutter/material.dart';
import '../app_state.dart';
import '../motion.dart';
import '../session.dart';
import '../theme.dart';
import '../widgets.dart';
import 'dashboards.dart';

/// ---------------------------------------------------------------------------
/// Employer portal pages (employees, assignments, reports).
/// Backed by [AppState] so changes persist.
/// ---------------------------------------------------------------------------
Widget _employer({
  required String title,
  required String subtitle,
  required Widget content,
  List<Widget> actions = const [],
}) =>
    PortalScaffold(
      workspace: session.value?.organization ?? 'ABC Sdn Bhd',
      title: title,
      subtitle: subtitle,
      nav: employerNav,
      actions: actions,
      content: content,
    );

/// ---------------------------------------------------------------------------
/// Employees
/// ---------------------------------------------------------------------------
class EmployerEmployeesPage extends StatelessWidget {
  const EmployerEmployeesPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => _employer(
          title: 'Employees',
          subtitle: 'Add and manage the people you enrol.',
          actions: [
            FilledButton.icon(
                onPressed: () => _addEmployee(context),
                icon: const Icon(Icons.person_add_alt),
                label: const Text('Add Employee')),
          ],
          content: app.employees.isEmpty
              ? Panel(
                  child: Text('No employees yet. Add your first employee.',
                      style: body(15, color: Brand.grey)))
              : Panel(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: body(13,
                          color: Brand.green, weight: FontWeight.w700),
                      dataTextStyle: body(13),
                      columns: const [
                        DataColumn(label: Text('Employee')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('Progress')),
                        DataColumn(label: Text('')),
                      ],
                      rows: [
                        for (final e in app.employees)
                          DataRow(cells: [
                            DataCell(Text(e.name)),
                            DataCell(Text(e.email)),
                            DataCell(Text(e.department)),
                            DataCell(SizedBox(
                              width: 140,
                              child: Row(children: [
                                Expanded(
                                    child: GradientProgressBar(
                                        value: e.completion, height: 6)),
                                const SizedBox(width: 8),
                                Text('${(e.completion * 100).round()}%'),
                              ]),
                            )),
                            DataCell(IconButton(
                              tooltip: 'Remove',
                              icon: const Icon(Icons.delete_outline,
                                  color: Brand.clayDeep),
                              onPressed: () => app.removeEmployee(e.email),
                            )),
                          ]),
                      ],
                    ),
                  ),
                ),
        ),
      );
}

Future<void> _addEmployee(BuildContext context) async {
  final name = TextEditingController();
  final email = TextEditingController();
  final department = TextEditingController(text: 'HR');
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add employee'),
      content: SizedBox(
        width: 420,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(
                labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: department,
            decoration: const InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.apartment_outlined)),
          ),
        ]),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add')),
      ],
    ),
  );
  if (result == true &&
      name.text.trim().isNotEmpty &&
      email.text.trim().isNotEmpty) {
    app.addEmployee(Employee(
      name: name.text.trim(),
      email: email.text.trim(),
      department: department.text.trim(),
    ));
  }
}

/// ---------------------------------------------------------------------------
/// Assign courses
/// ---------------------------------------------------------------------------
class EmployerAssignPage extends StatefulWidget {
  const EmployerAssignPage({super.key});
  @override
  State<EmployerAssignPage> createState() => _EmployerAssignPageState();
}

class _EmployerAssignPageState extends State<EmployerAssignPage> {
  String? _employee;
  String? _course;
  final _due = TextEditingController(text: '30 Nov 2026');

  @override
  void dispose() {
    _due.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final employees = app.employees;
          final courses = app.publishedCourses;
          _employee ??= employees.isEmpty ? null : employees.first.email;
          _course ??= courses.isEmpty ? null : courses.first.id;
          if (_employee != null &&
              !employees.any((e) => e.email == _employee)) {
            _employee = employees.first.email;
          }
          if (_course != null && !courses.any((c) => c.id == _course)) {
            _course = courses.first.id;
          }
          return _employer(
            title: 'Assign Courses',
            subtitle: 'Enrol employees onto a course with a due date.',
            content: Column(children: [
              Panel(
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('New assignment', style: heading(18)),
                  const SizedBox(height: 16),
                  if (employees.isEmpty || courses.isEmpty)
                    Text('Add employees and publish courses first.',
                        style: body(14, color: Brand.grey))
                  else ...[
                    DropdownButtonFormField<String>(
                      initialValue: _employee,
                      isExpanded: true,
                      decoration: const InputDecoration(
                          labelText: 'Employee',
                          prefixIcon: Icon(Icons.person_outline)),
                      items: [
                        for (final e in employees)
                          DropdownMenuItem(
                              value: e.email,
                              child: Text('${e.name} (${e.department})')),
                      ],
                      onChanged: (v) => setState(() => _employee = v),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _course,
                      isExpanded: true,
                      decoration: const InputDecoration(
                          labelText: 'Course',
                          prefixIcon: Icon(Icons.school_outlined)),
                      items: [
                        for (final c in courses)
                          DropdownMenuItem(value: c.id, child: Text(c.title)),
                      ],
                      onChanged: (v) => setState(() => _course = v),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _due,
                      decoration: const InputDecoration(
                          labelText: 'Due date',
                          prefixIcon: Icon(Icons.event_outlined)),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (_employee == null || _course == null) return;
                          app.assignCourse(Assignment(
                            employeeEmail: _employee!,
                            courseId: _course!,
                            due: _due.text.trim(),
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Course assigned')),
                          );
                        },
                        icon: const Icon(Icons.assignment_turned_in_outlined),
                        label: const Text('Assign Course'),
                      ),
                    ),
                  ],
                ]),
              ),
              const SizedBox(height: 20),
              Panel(
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Current assignments', style: heading(18)),
                  const SizedBox(height: 16),
                  if (app.assignments.isEmpty)
                    Text('No courses assigned yet.',
                        style: body(14, color: Brand.grey))
                  else
                    for (final a in app.assignments)
                      _assignmentRow(context, a),
                ]),
              ),
            ]),
          );
        },
      );

  Widget _assignmentRow(BuildContext context, Assignment a) {
    final emp = app.employees
        .where((e) => e.email == a.employeeEmail)
        .cast<Employee?>()
        .firstWhere((e) => true, orElse: () => null);
    final course = app.courseById(a.courseId);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        const Icon(Icons.assignment_ind_outlined, color: Brand.sage),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
              '${emp?.name ?? a.employeeEmail} → ${course?.title ?? a.courseId}',
              style: body(14)),
        ),
        Text('Due ${a.due}', style: body(12.5, color: Brand.grey)),
      ]),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Reports
/// ---------------------------------------------------------------------------
class EmployerReportsPage extends StatelessWidget {
  const EmployerReportsPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final employees = app.employees;
          final depts = <String, List<double>>{};
          for (final e in employees) {
            depts.putIfAbsent(e.department, () => []).add(e.completion);
          }
          final rate = employees.isEmpty
              ? 0.0
              : employees.fold<double>(0, (s, e) => s + e.completion) /
                  employees.length;
          return _employer(
            title: 'Reports',
            subtitle: 'Completion and engagement by department.',
            actions: [
              OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report exported as PDF'))),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export PDF')),
              OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report exported as CSV'))),
                  icon: const Icon(Icons.table_chart_outlined, size: 18),
                  label: const Text('Export CSV')),
            ],
            content: Column(children: [
              CardGrid(children: [
                DashStat('${employees.length}', 'Total employees',
                    Icons.groups_outlined, Brand.sage),
                DashStat('${(rate * 100).round()}%', 'Completion rate',
                    Icons.percent, Brand.success),
                DashStat('${app.assignments.length}', 'Assignments',
                    Icons.assignment_turned_in_outlined, Brand.clayDeep),
              ]),
              const SizedBox(height: 20),
              Panel(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('By department', style: heading(18)),
                      const SizedBox(height: 16),
                      if (depts.isEmpty)
                        Text('No data yet.', style: body(14, color: Brand.grey))
                      else
                        for (final d in depts.entries)
                          Builder(builder: (context) {
                            final avg = d.value.reduce((a, b) => a + b) /
                                d.value.length;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Column(
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
                                              style: body(13,
                                                  color: Brand.green)),
                                        ]),
                                    const SizedBox(height: 6),
                                    GradientProgressBar(value: avg, height: 8),
                                  ]),
                            );
                          }),
                    ]),
              ),
            ]),
          );
        },
      );
}
