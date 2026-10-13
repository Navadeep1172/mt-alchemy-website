import 'package:flutter/material.dart';
import '../data.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets.dart';

/// ---------------------------------------------------------------------------
/// Learning Hub (Upskilling)
/// ---------------------------------------------------------------------------
class LearningHubPage extends StatefulWidget {
  const LearningHubPage({super.key});
  @override
  State<LearningHubPage> createState() => _LearningHubPageState();
}

class _LearningHubPageState extends State<LearningHubPage> {
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    final list = _category == 'All'
        ? courses
        : courses.where((c) => c.category == _category).toList();

    return Shell(children: [
      PageHero(
        eyebrow: 'Learning Hub',
        title: 'Learn. Apply. Grow.',
        subtitle:
            'Learn at your own pace with MT Alchemy courses on emotional intelligence, leadership and well-being.',
        image: Img.hero[0],
        actions: [
          FilledButton(
              onPressed: () => go(context, '/login'),
              child: const Text('Start Learning')),
        ],
      ),
      Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeading('Browse by category'),
          const SizedBox(height: 18),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ChoiceChip(
              label: const Text('All'),
              selected: _category == 'All',
              selectedColor: Brand.purple,
              labelStyle: TextStyle(
                  color: _category == 'All' ? Colors.white : Brand.deepBlue,
                  fontWeight: FontWeight.w600),
              onSelected: (_) => setState(() => _category = 'All'),
            ),
            for (final c in courseCategories)
              ChoiceChip(
                label: Text(c),
                selected: _category == c,
                selectedColor: Brand.purple,
                labelStyle: TextStyle(
                    color: _category == c ? Colors.white : Brand.deepBlue,
                    fontWeight: FontWeight.w600),
                onSelected: (_) => setState(() => _category = c),
              ),
          ]),
          const SizedBox(height: 28),
          CardGrid(children: [for (final c in list) CourseCard(c)]),
        ]),
      ),
      const CtaBand(
          title: 'Start learning today', label: 'Register Now', path: '/register'),
    ]);
  }
}

/// ---------------------------------------------------------------------------
/// Course Detail
/// ---------------------------------------------------------------------------
class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) => Shell(children: [
        Section(
          vertical: 48,
          gradient: const LinearGradient(
            colors: [Brand.deepBlueDark, Brand.deepBlue, Brand.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          child: LayoutBuilder(builder: (context, box) {
            final wide = box.maxWidth >= 900;
            final info = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(course.category),
                const SizedBox(height: 14),
                Text(course.title, style: heading(wide ? 40 : 30, color: Colors.white)),
                const SizedBox(height: 12),
                Text(course.description,
                    style: body(16, color: Colors.white70)),
                const SizedBox(height: 20),
                Wrap(spacing: 18, runSpacing: 8, children: [
                  _meta(Icons.person_outline, course.instructor, light: true),
                  _meta(Icons.schedule, course.duration, light: true),
                  _meta(Icons.signal_cellular_alt, course.level, light: true),
                  _meta(Icons.star, course.rating.toStringAsFixed(1), light: true),
                ]),
              ],
            );
            final buy = Panel(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RM${course.price.toStringAsFixed(0)}',
                      style: heading(30, color: Brand.deepBlue)),
                  const SizedBox(height: 6),
                  Text('One-time purchase',
                      style: body(13, color: Brand.grey)),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/player', arguments: course),
                      child: const Text('Enrol Now'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => go(context, '/cart'),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _bullet('Certificate on completion'),
                  _bullet('Lifetime access'),
                  _bullet('Self-paced learning'),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 3, child: info),
                    const SizedBox(width: 32),
                    SizedBox(width: 300, child: buy),
                  ])
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    info,
                    const SizedBox(height: 28),
                    buy,
                  ]);
          }),
        ),
        Section(
          child: LayoutBuilder(builder: (context, box) {
            final wide = box.maxWidth >= 860;
            final curriculum = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Course curriculum', style: heading(24)),
                const SizedBox(height: 16),
                for (var i = 0; i < course.curriculum.length; i++)
                  _curriculumTile(i + 1, course.curriculum[i]),
              ],
            );
            final objectives = Panel(
              color: Brand.mist,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What you will learn', style: heading(19)),
                  const SizedBox(height: 12),
                  for (final o in course.objectives)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle,
                                size: 18, color: Brand.purple),
                            const SizedBox(width: 8),
                            Expanded(child: Text(o, style: body(14))),
                          ]),
                    ),
                  const SizedBox(height: 10),
                  Divider(color: Brand.line),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.verified_outlined,
                        color: Brand.success, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text('Certificate available',
                            style: body(14, color: Brand.success))),
                  ]),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 3, child: curriculum),
                    const SizedBox(width: 32),
                    SizedBox(width: 320, child: objectives),
                  ])
                : Column(children: [curriculum, const SizedBox(height: 24), objectives]);
          }),
        ),
      ]);

  static Widget _curriculumTile(int n, CurriculumItem c) {
    final icon = switch (c.type) {
      'Video' => Icons.play_circle_outline,
      'Quiz' => Icons.quiz_outlined,
      'PDF' => Icons.picture_as_pdf_outlined,
      _ => Icons.article_outlined,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Brand.line),
      ),
      child: Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: Brand.lavender, borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Text('$n',
              style: body(13, color: Brand.purple, weight: FontWeight.w700)),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(c.title, style: body(14.5, weight: FontWeight.w600))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: Brand.mist, borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 14, color: Brand.grey),
            const SizedBox(width: 4),
            Text(c.type, style: body(11.5, color: Brand.grey)),
          ]),
        ),
      ]),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Course Player  (modular: Video / PDF / Quiz content types)
/// ---------------------------------------------------------------------------
class CoursePlayerPage extends StatefulWidget {
  const CoursePlayerPage({super.key, required this.course});
  final Course course;
  @override
  State<CoursePlayerPage> createState() => _CoursePlayerPageState();
}

class _CoursePlayerPageState extends State<CoursePlayerPage> {
  int _index = 0;
  double _progress = 0.65; // 65% as required by the brief
  final Set<int> _completed = {0, 1, 2};

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final item = widget.course.curriculum[_index];

    final sidebar = Container(
      width: wide ? 300 : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Brand.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Material(
        type: MaterialType.transparency,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Course modules', style: heading(18)),
        const SizedBox(height: 12),
        for (var i = 0; i < widget.course.curriculum.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              _completed.contains(i)
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: _completed.contains(i) ? Brand.success : Brand.grey,
            ),
            title: Text(widget.course.curriculum[i].title,
                style: body(14,
                    weight: i == _index ? FontWeight.w700 : FontWeight.w400)),
            selected: i == _index,
            onTap: () => setState(() => _index = i),
          ),
        ]),
      ),
    );

    final main = Panel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(item.title, style: heading(22))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Brand.lavender, borderRadius: BorderRadius.circular(20)),
            child: Text(item.type,
                style: body(12, color: Brand.purple, weight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 16),
        // Modular learning content area
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Brand.deepBlue,
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
                image: AssetImage(widget.course.image),
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    Color(0x99101B31), BlendMode.darken)),
          ),
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              switch (item.type) {
                'Video' => Icons.play_circle_fill,
                'Quiz' => Icons.quiz,
                'PDF' => Icons.picture_as_pdf,
                _ => Icons.article,
              },
              size: 64,
              color: Brand.softYellow,
            ),
            const SizedBox(height: 10),
            Text('$item.type content loads here',
                style: body(14, color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: 20),
        // Progress
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Course Progress', style: body(14, weight: FontWeight.w600)),
          Text('${(_progress * 100).round()}%',
              style: body(14, color: Brand.purple, weight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        GradientProgressBar(value: _progress, height: 10),
        const SizedBox(height: 20),
        // Previous / Mark Complete / Next
        Wrap(spacing: 12, runSpacing: 12, children: [
          OutlinedButton.icon(
            onPressed: _index > 0 ? () => setState(() => _index--) : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Previous'),
          ),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                _completed.add(_index);
                _progress = (_index + 2) / widget.course.curriculum.length;
                if (_progress > 1) _progress = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lesson marked complete')),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Mark Complete'),
          ),
          OutlinedButton.icon(
            onPressed: _index < widget.course.curriculum.length - 1
                ? () {
                    setState(() {
                      if (widget.course.curriculum[_index].type == 'Quiz') {
                        Navigator.pushNamed(context, '/quiz',
                            arguments: widget.course);
                      } else {
                        _index++;
                      }
                    });
                  }
                : () => Navigator.pushNamed(context, '/certificate',
                    arguments: widget.course),
            icon: const Icon(Icons.chevron_right),
            label: const Text('Next'),
          ),
        ]),
      ]),
    );

    return Shell(children: [
      Section(
        color: Brand.mist,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(widget.course.title, style: heading(24))),
            TextButton.icon(
                onPressed: () => go(context, '/learner'),
                icon: const Icon(Icons.dashboard_outlined),
                label: const Text('Dashboard')),
          ]),
          const SizedBox(height: 20),
          wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  sidebar,
                  const SizedBox(width: 20),
                  Expanded(child: main),
                ])
              : Column(children: [main, const SizedBox(height: 20), sidebar]),
        ]),
      ),
    ]);
  }
}

/// ---------------------------------------------------------------------------
/// Quiz / Assessment
/// ---------------------------------------------------------------------------
class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.course});
  final Course course;
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  static const questions = [
    ('Which pillar of EQ helps you manage impulses?', ['Self-regulation', 'Empathy', 'Motivation', 'Social skills']),
    ('Mindfulness primarily improves...', ['Attention', 'Salary', 'Office design', 'Deadlines']),
    ('Active listening means...', ['Interrupting', 'Fully focusing on the speaker', 'Multitasking', 'Taking notes only']),
  ];
  final Map<int, String> _answers = {};
  bool _submitted = false;
  int _score = 0;

  void _submit() {
    var s = 0;
    for (var i = 0; i < questions.length; i++) {
      if (_answers[i] == questions[i].$2[0]) s++;
    }
    setState(() {
      _score = s;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pct = ((_score / questions.length) * 100).round();
    return Shell(children: [
      Section(
        color: Brand.mist,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Panel(
              padding: const EdgeInsets.all(28),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Knowledge Check', style: heading(24)),
                const SizedBox(height: 4),
                Text(widget.course.title, style: body(14, color: Brand.grey)),
                const SizedBox(height: 20),
                for (var i = 0; i < questions.length; i++) ...[
                  Text('Q${i + 1}. ${questions[i].$1}',
                      style: body(16, weight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  RadioGroup<String>(
                    groupValue: _answers[i],
                    onChanged: (v) {
                      if (!_submitted) setState(() => _answers[i] = v!);
                    },
                    child: Column(children: [
                      for (final opt in questions[i].$2)
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          value: opt,
                          activeColor: Brand.purple,
                          title: Text(opt),
                        ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                ],
                if (_submitted)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Brand.lavender,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Score: $_score / ${questions.length}',
                            style: heading(20)),
                        Text('$pct% correct',
                            style: body(14, color: Brand.grey)),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  FilledButton(
                    onPressed: _submitted
                        ? () => setState(() {
                              _submitted = false;
                              _answers.clear();
                              _score = 0;
                            })
                        : _submit,
                    child: Text(_submitted ? 'Retake Assessment' : 'Submit'),
                  ),
                  if (_submitted)
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/certificate',
                          arguments: widget.course),
                      child: const Text('View Certificate'),
                    ),
                ]),
              ]),
            ),
          ),
        ),
      ),
    ]);
  }
}

/// ---------------------------------------------------------------------------
/// Certificate
/// ---------------------------------------------------------------------------
class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key, required this.course});
  final Course course;
  @override
  Widget build(BuildContext context) => Shell(children: [
        Section(
          color: Brand.mist,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(children: [
                Text('Congratulations!', style: heading(32)),
                const SizedBox(height: 8),
                Text('You have completed ${course.title}.',
                    style: body(15, color: Brand.grey)),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Brand.softYellow, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1A1B2A4A), blurRadius: 30, offset: Offset(0, 12)),
                    ],
                  ),
                  padding: const EdgeInsets.all(36),
                  child: Column(children: [
                    Text('MT Alchemy', style: heading(24, color: Brand.deepBlue)),
                    const SizedBox(height: 4),
                    Text('Certificate of Completion',
                        style: body(14, color: Brand.purple, weight: FontWeight.w600)),
                    const SizedBox(height: 28),
                    Text('Mabel Tan KH', style: heading(38)),
                    const SizedBox(height: 10),
                    Text('has successfully completed',
                        style: body(14, color: Brand.grey)),
                    const SizedBox(height: 6),
                    Text(course.title,
                        textAlign: TextAlign.center, style: heading(20)),
                    const SizedBox(height: 28),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        _field('Completion Date', '13 Oct 2026'),
                        _field('Certificate ID',
                            'MTA-${course.id.toUpperCase()}-0001'),
                        _field('Instructor', course.instructor),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Brand.line),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.qr_code_2, size: 40, color: Brand.deepBlue),
                        const SizedBox(width: 10),
                        Text('Scan to verify', style: body(13, color: Brand.grey)),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 24),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Download Certificate')),
                  OutlinedButton(
                      onPressed: () => go(context, '/learner'),
                      child: const Text('Back to Dashboard')),
                ]),
              ]),
            ),
          ),
        ),
      ]);

  static Widget _field(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: body(11, color: Brand.grey)),
          Text(value, style: body(14, weight: FontWeight.w700)),
        ],
      );
}

Widget _bullet(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        const Icon(Icons.check, size: 16, color: Brand.success),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: body(13.5))),
      ]),
    );

Widget _meta(IconData icon, String text, {bool light = false}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: light ? Brand.softYellow : Brand.purple),
        const SizedBox(width: 6),
        Text(text, style: body(14, color: light ? Colors.white70 : Brand.grey)),
      ],
    );
