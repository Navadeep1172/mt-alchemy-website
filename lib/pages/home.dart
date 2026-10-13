import 'package:flutter/material.dart';
import '../data.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell(children: [
      // ---- Hero (Container with gradient) ----
      PageHero(
        eyebrow: 'People development consultancy',
        title:
            'Elevate your value: Master human intelligence in a rapidly evolving AI-driven world.',
        subtitle:
            'Work with us, upskill with us and shop - one human-centred platform for Emotional Intelligence, Leadership Development, Team Engagement and Workplace Well-being.',
        image: Img.hero[0],
        actions: [
          FilledButton.icon(
            onPressed: () => go(context, '/coaching'),
            icon: const Icon(Icons.self_improvement),
            label: const Text("I'm an Individual"),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54)),
            onPressed: () => go(context, '/organisations'),
            icon: const Icon(Icons.apartment_outlined),
            label: const Text("I'm an Employer"),
          ),
        ],
      ),

      // ---- Animated keyword ticker ----
      Container(
        width: double.infinity,
        color: Brand.deepBlueDark,
        child: Marquee(
          separator: const Icon(Icons.auto_awesome,
              size: 15, color: Brand.softYellowDeep),
          items: [
            for (final k in const [
              'Emotional Intelligence',
              'Leadership Development',
              'Team Engagement',
              'Workplace Well-being',
              'Executive Coaching',
              'Assessments',
              'Keynotes',
              'Facilitation',
            ])
              Text(k, style: heading(20, color: Colors.white)),
          ],
        ),
      ),

      // ---- What we do ----
      Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeading('What we do',
              intro:
                  'Human-centred programmes for individuals, teams and organisations.'),
          const SizedBox(height: 28),
          CardGrid(
            children: [for (final s in services) ServiceCard(s)],
          ),
        ]),
      ),

      // ---- Transformation pathway ----
      Section(
        color: Brand.mist,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeading('How we work',
              intro:
                  'A four-step transformation pathway - the alchemy behind every engagement.'),
          const SizedBox(height: 28),
          const JourneyStrip(),
        ]),
      ),

      // ---- Upskilling ----
      Section(
        color: Brand.lavender,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                  child: SectionHeading('Upskilling - learn at your own pace.',
                      intro: 'Featured courses from the MT Alchemy Learning Hub.')),
              TextButton(
                  onPressed: () => go(context, '/upskilling'),
                  child: const Text('View all courses')),
            ],
          ),
          const SizedBox(height: 28),
          CardGrid(
            children: [for (final c in courses.take(3)) CourseCard(c)],
          ),
        ]),
      ),

      // ---- Corporate solutions ----
      Section(
        child: LayoutBuilder(builder: (context, box) {
          final wide = box.maxWidth >= 860;
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Corporate solutions', color: Brand.purple),
              const SizedBox(height: 14),
              Text('Develop your people. Strengthen your organization.',
                  style: heading(30)),
              const SizedBox(height: 14),
              Text(
                  'From leadership development and emotional intelligence to team '
                  'effectiveness and well-being assessments - we build programmes around your workforce, culture and goals.',
                  style: body(16, color: Brand.grey)),
              const SizedBox(height: 22),
              FilledButton(
                  onPressed: () => go(context, '/organisations'),
                  child: const Text('For Organizations')),
            ],
          );
          final image = ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(Img.banner,
                height: wide ? 300 : 200, width: double.infinity, fit: BoxFit.cover),
          );
          return wide
              ? Row(children: [
                  Expanded(child: content),
                  const SizedBox(width: 40),
                  Expanded(child: image),
                ])
              : Column(children: [content, const SizedBox(height: 24), image]);
        }),
      ),

      // ---- Store ----
      Section(
        color: Brand.mist,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                  child: SectionHeading('Store',
                      intro: 'Selected digital and physical products.')),
              TextButton(
                  onPressed: () => go(context, '/store'),
                  child: const Text('Visit store')),
            ],
          ),
          const SizedBox(height: 28),
          CardGrid(
            children: [for (final p in products.take(3)) ProductCard(p)],
          ),
        ]),
      ),

      // ---- Impact + testimonials ----
      Section(
        gradient: const LinearGradient(
          colors: [Brand.deepBlue, Brand.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Column(children: [
          const Eyebrow('Our impact'),
          const SizedBox(height: 16),
          AnimatedCount('1,100+', style: heading(64, color: Colors.white)),
          Text('participants impacted across corporate, education, youth, NGO and community work.',
              textAlign: TextAlign.center,
              style: body(16, color: Colors.white70)),
          const SizedBox(height: 36),
          CardGrid(
            minWidth: 300,
            children: [
              for (final t in testimonials)
                HoverLift(
                  glow: Brand.softYellow,
                  cursorClick: false,
                  child: Panel(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderColor: Colors.white24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.format_quote, color: Brand.softYellow),
                        const SizedBox(height: 12),
                        Text('“${t.$1}”',
                            style: body(15, color: Colors.white, height: 1.6)),
                        const SizedBox(height: 14),
                        Text('- ${t.$2}',
                            style: body(13, color: Brand.softYellow)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ]),
      ),

      const CtaBand(),
    ]);
  }
}
