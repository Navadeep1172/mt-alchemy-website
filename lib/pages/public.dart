import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

/// ---------------------------------------------------------------------------
/// About MT Alchemy
/// ---------------------------------------------------------------------------
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(children: [
        const PageHero(
          eyebrow: 'About MT Alchemy',
          title: 'A human-centred approach to development',
          subtitle:
              'MT Alchemy is a people-development consultancy working with individuals, teams and organisations to shift mindsets, behaviours and team culture.',
        ),
        Section(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Who we are',
                intro:
                    'We don\'t just run activities. We shift mindsets, behaviours, and team culture.'),
            const SizedBox(height: 28),
            CardGrid(children: [
              _about('Who We Are', Icons.favorite_border,
                  'A people-development consultancy specialising in emotional intelligence, leadership development, team engagement and workplace well-being.'),
              _about('Vision', Icons.visibility_outlined,
                  'To elevate human intelligence in a rapidly evolving AI-driven world - one person, one team at a time.'),
              _about('Mission', Icons.flag_outlined,
                  'To design and deliver human-centred programmes that build self-awareness, empathy and resilient workplace cultures.'),
            ]),
          ]),
        ),
        Section(
          color: Brand.aquaTint,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Our approach'),
            const SizedBox(height: 28),
            CardGrid(children: [
              _about('Our Approach', Icons.route_outlined,
                  'Every programme starts with understanding people - then we co-design, deliver and measure.'),
              _about('Why EQ Matters', Icons.lightbulb_outline,
                  'As AI takes over tasks, emotional intelligence becomes the human advantage that drives teams.'),
              _about('Our Impact', Icons.insights_outlined,
                  '1,100+ participants impacted across corporate, education, youth, NGO and community programmes.'),
            ]),
          ]),
        ),
        Section(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Founder & team'),
            const SizedBox(height: 28),
            LayoutBuilder(builder: (context, box) {
              final wide = box.maxWidth >= 760;
              final founder = Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(Img.portraits[0],
                          height: 240, width: double.infinity, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 16),
                    Text('Mabel Tan KH', style: heading(22)),
                    const SizedBox(height: 4),
                    Text('Founder | EQ Coach | HRDC Certified Trainer',
                        style: body(14, color: Brand.teal, weight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Text(
                        'Mabel founded MT Alchemy to bring a deeply human approach to people development, blending emotional intelligence, mindfulness and leadership coaching.',
                        style: body(14, color: Brand.grey)),
                  ],
                ),
              );
              final team = Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Our Team', style: heading(22)),
                    const SizedBox(height: 12),
                    Text(
                        'Our trainers and facilitators bring empathy, energy and years of experience to every programme. They design around your people, not a script.',
                        style: body(14.5, color: Brand.grey)),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(Img.portraits[1],
                          height: 200, width: double.infinity, fit: BoxFit.cover),
                    ),
                  ],
                ),
              );
              return wide
                  ? Row(children: [
                      Expanded(child: founder),
                      const SizedBox(width: 20),
                      Expanded(child: team),
                    ])
                  : Column(children: [founder, const SizedBox(height: 20), team]);
            }),
          ]),
        ),
        const CtaBand(label: 'Work With MT Alchemy'),
      ]);

  static Widget _about(String title, IconData icon, String text) => Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: Brand.aqua, size: 30),
          const SizedBox(height: 14),
          Text(title, style: heading(19)),
          const SizedBox(height: 8),
          Text(text, style: body(14, color: Brand.grey)),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Services for Corporates
/// ---------------------------------------------------------------------------
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(children: [
        const PageHero(
          eyebrow: 'Services',
          title: 'Programmes that develop people',
          subtitle:
              'Explore what we offer for organisations. Each service explains what it is and who it is for.',
        ),
        Section(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Service directory'),
            const SizedBox(height: 28),
            CardGrid(
              children: [for (final s in services) ServiceCard(s, showCta: true)],
            ),
          ]),
        ),
        const CtaBand(label: 'Get a Free Consultation'),
      ]);
}

/// ---------------------------------------------------------------------------
/// Individual Coaching
/// ---------------------------------------------------------------------------
class CoachingPage extends StatelessWidget {
  const CoachingPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(children: [
        PageHero(
          eyebrow: 'Individual Coaching',
          title: 'Grow with a coach beside you',
          subtitle:
              'One-to-one coaching for people navigating work, relationships and personal growth.',
          image: Img.hero[1],
          actions: [
            FilledButton(
                onPressed: () => go(context, '/contact'),
                child: const Text('Book a Coaching Session')),
          ],
        ),
        Section(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Who individual coaching is for',
                intro:
                    'Professionals, leaders, career changers and anyone seeking clarity and growth.'),
            const SizedBox(height: 28),
            CardGrid(children: [
              _focus('Career guidance', Icons.work_outline,
                  'Clarity on direction and next steps.'),
              _focus('Career transitions', Icons.swap_horiz,
                  'Support through change and new roles.'),
              _focus('Relationships', Icons.people_outline,
                  'Communicate and connect with confidence.'),
              _focus('Personal development', Icons.self_improvement,
                  'Build habits and emotional resilience.'),
            ]),
          ]),
        ),
        Section(
          color: Brand.aquaTint,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('How it works'),
            const SizedBox(height: 28),
            CardGrid(children: [
              _focus('1. Book', Icons.looks_one_outlined,
                  'Choose a session that fits your schedule.'),
              _focus('2. Meet', Icons.looks_two_outlined,
                  'Discuss your goals with your coach.'),
              _focus('3. Grow', Icons.looks_3_outlined,
                  'Practise, reflect and track your progress.'),
            ]),
          ]),
        ),
        const CtaBand(title: 'Ready to begin?', label: 'Book a Coaching Session'),
      ]);

  static Widget _focus(String title, IconData icon, String text) => Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: Brand.aqua, size: 28),
          const SizedBox(height: 14),
          Text(title, style: heading(18)),
          const SizedBox(height: 8),
          Text(text, style: body(14, color: Brand.grey)),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Organisations (main corporate landing page)
/// ---------------------------------------------------------------------------
class OrganisationsPage extends StatelessWidget {
  const OrganisationsPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(children: [
        PageHero(
          eyebrow: 'For Organisations',
          title: 'Build emotionally intelligent leaders and resilient workplace cultures',
          subtitle:
              'Develop your people, strengthen your organisation and create a culture where teams thrive.',
          image: Img.hero[2],
          actions: [
            FilledButton(
                onPressed: () => go(context, '/contact'),
                child: const Text('Talk to MT Alchemy')),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54)),
                onPressed: () => go(context, '/programmes'),
                child: const Text('Browse Programmes')),
          ],
        ),
        Section(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Organisational challenges we address',
                intro: 'The people problems that quietly cost organisations the most.'),
            const SizedBox(height: 28),
            CardGrid(children: [
              _challenge('Employee burnout', Icons.battery_alert),
              _challenge('Rising stress', Icons.monitor_heart_outlined),
              _challenge('Communication breakdowns', Icons.forum_outlined),
              _challenge('Team conflicts', Icons.groups_outlined),
              _challenge('Leadership gaps', Icons.trending_down),
              _challenge('Low engagement & turnover', Icons.sentiment_dissatisfied_outlined),
            ]),
          ]),
        ),
        Section(
          color: Brand.aquaTint,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Our solutions'),
            const SizedBox(height: 28),
            CardGrid(
                children: [for (final s in services) ServiceCard(s, showCta: true)]),
          ]),
        ),
        const CtaBand(label: 'Talk to MT Alchemy'),
      ]);

  static Widget _challenge(String title, IconData icon) => Panel(
        child: Row(children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                color: Brand.aquaTint, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Brand.aqua),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: heading(16))),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Corporate Programmes
/// ---------------------------------------------------------------------------
class ProgrammesPage extends StatelessWidget {
  const ProgrammesPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(children: [
        const PageHero(
          eyebrow: 'Corporate Programmes',
          title: 'Browse programmes for your team',
          subtitle:
              'Public programmes have a fixed price. Corporate programmes are customised and priced on request.',
        ),
        Section(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Featured programmes',
                intro:
                    'Each programme lists its objectives, audience, duration and delivery mode.'),
            const SizedBox(height: 28),
            for (final c in courses.take(4)) ...[
              _programme(context, c),
              const SizedBox(height: 16),
            ],
          ]),
        ),
        const CtaBand(label: 'Request a Quote'),
      ]);

  Widget _programme(BuildContext context, Course c) => Panel(
        child: LayoutBuilder(builder: (context, box) {
          final wide = box.maxWidth >= 720;
          final info = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Brand.aquaTint,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text('Corporate Programme',
                      style: body(11,
                          color: Brand.aqua, weight: FontWeight.w700)),
                ),
              ]),
              const SizedBox(height: 12),
              Text(c.title, style: heading(21)),
              const SizedBox(height: 8),
              Text(c.description, style: body(14.5, color: Brand.grey)),
              const SizedBox(height: 14),
              Wrap(spacing: 16, runSpacing: 8, children: [
                _meta(Icons.schedule, c.duration),
                _meta(Icons.school_outlined, c.modules >= 5 ? 'Up to 25 participants' : 'Up to 40 participants'),
                _meta(Icons.laptop_mac_outlined, 'Onsite / Online'),
                _meta(Icons.person_outline, c.instructor),
              ]),
              const SizedBox(height: 18),
              Wrap(spacing: 10, runSpacing: 10, children: [
                FilledButton(
                    onPressed: () => go(context, '/contact'),
                    child: const Text('Request a Quote')),
                OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/course',
                        arguments: c),
                    child: const Text('View Details')),
              ]),
            ],
          );
          final price = Panel(
            color: Brand.mist,
            child: Column(children: [
              Text('From', style: body(13, color: Brand.grey)),
              Text('RM${c.price.toStringAsFixed(0)}',
                  style: heading(26, color: Brand.teal)),
              const SizedBox(height: 6),
              Text('or Request Quote',
                  style: body(12, color: Brand.grey)),
            ]),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 3, child: info),
                  const SizedBox(width: 24),
                  SizedBox(width: 160, child: price),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  info,
                  const SizedBox(height: 18),
                  price,
                ]);
        }),
      );

  static Widget _meta(IconData icon, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Brand.aqua),
          const SizedBox(width: 5),
          Text(label, style: body(13, color: Brand.grey)),
        ],
      );
}

/// ---------------------------------------------------------------------------
/// Insights
/// ---------------------------------------------------------------------------
class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(children: [
        const PageHero(
          eyebrow: 'Insights',
          title: 'Ideas for people who lead and grow',
          subtitle:
              'Articles, videos, guides and resources from MT Alchemy on EQ, leadership and well-being.',
        ),
        Section(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeading('Browse by category'),
            const SizedBox(height: 20),
            Wrap(spacing: 10, runSpacing: 10, children: [
              for (final c in insightCategories)
                Chip(
                    backgroundColor: Brand.aquaTint,
                    side: BorderSide.none,
                    label: Text(c)),
            ]),
            const SizedBox(height: 28),
            CardGrid(children: [
              for (final a in articles) _articleCard(context, a),
            ]),
          ]),
        ),
      ]);

  Widget _articleCard(BuildContext context, Article a) => Panel(
        padding: EdgeInsets.zero,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(a.image,
                height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                      color: Brand.amber,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(a.type,
                      style: body(11,
                          color: Brand.teal, weight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(a.category,
                        style: body(12, color: Brand.teal),
                        overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 12),
              Text(a.title, style: heading(17), maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 10),
              Text('Read more →', style: body(13, color: Brand.teal)),
            ]),
          ),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Impact Stories (searchable / filterable)
/// ---------------------------------------------------------------------------
class ImpactPage extends StatefulWidget {
  const ImpactPage({super.key});
  @override
  State<ImpactPage> createState() => _ImpactPageState();
}

class _ImpactPageState extends State<ImpactPage> {
  String _filter = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final list = impactStories.where((s) {
      final matchesFilter = _filter == 'All' ||
          s.clientType == _filter ||
          s.tags.contains(_filter);
      final matchesQuery = _query.isEmpty ||
          s.title.toLowerCase().contains(_query.toLowerCase()) ||
          s.programme.toLowerCase().contains(_query.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();

    return Shell(children: [
      const PageHero(
        eyebrow: 'Impact Stories',
        title: 'Real workshops, real results',
        subtitle:
            'Case studies from corporate, education, youth, NGO and community work.',
      ),
      Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search stories',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 18),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final f in impactFilters)
              ChoiceChip(
                label: Text(f),
                selected: _filter == f,
                selectedColor: Brand.aqua,
                labelStyle: TextStyle(
                    color: _filter == f ? Colors.white : Brand.teal,
                    fontWeight: FontWeight.w600),
                onSelected: (_) => setState(() => _filter = f),
              ),
          ]),
          const SizedBox(height: 28),
          if (list.isEmpty)
            Panel(
              child: Text('No stories match your filter.',
                  style: body(15, color: Brand.grey)),
            )
          else
            CardGrid(children: [for (final s in list) StoryCard(s)]),
        ]),
      ),
      const CtaBand(label: 'Start Your Programme'),
    ]);
  }
}
