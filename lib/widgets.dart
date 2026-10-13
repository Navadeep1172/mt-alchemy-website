import 'package:flutter/material.dart';
import 'data.dart';
import 'theme.dart';

/// Central navigation helper - every button uses named routes through
/// Flutter's [Navigator] (see `routes` / `onGenerateRoute` in main.dart).
void go(BuildContext context, String path) =>
    Navigator.pushNamed(context, path);

/// ---------------------------------------------------------------------------
/// Shell = Scaffold
/// ---------------------------------------------------------------------------
/// Every screen is wrapped in this Shell. It is the single place where the
/// Flutter [Scaffold] is used: AppBar, Drawer (mobile navigation) and body.
/// Passing `appBar: false` keeps the header off dashboard-style screens.
class Shell extends StatelessWidget {
  final List<Widget> children;
  final bool appBar;
  const Shell({super.key, required this.children, this.appBar = true});

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name ?? '/';
    final wide = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      // ---- Scaffold.persistentFooterButtons / floatingActionButton could also
      // be demonstrated here. We keep the Cart as a floating action button.
      floatingActionButton: route == '/cart'
          ? null
          : FloatingActionButton.extended(
              onPressed: () => go(context, '/cart'),
              backgroundColor: Brand.purple,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Cart'),
            ),
      appBar: appBar ? _buildAppBar(context, route, wide) : null,
      drawer: appBar && !wide ? _buildDrawer(context, route) : null,
      body: SingleChildScrollView(
        child: Column(children: [...children, const Footer()]),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, String route, bool wide) {
    return AppBar(
      toolbarHeight: 74,
      titleSpacing: 24,
      title: InkWell(
        onTap: () => go(context, '/'),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Brand.softYellow,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text('MT',
                style: heading(16, color: Brand.deepBlue, weight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text('MT Alchemy',
                overflow: TextOverflow.ellipsis,
                style: heading(22, color: Colors.white)),
          ),
        ]),
      ),
      actions: [
        if (wide)
          for (final item in topNav)
            TextButton(
              onPressed: () => go(context, item.path),
              child: Text(
                item.label,
                style: TextStyle(
                  color: route == item.path ? Brand.softYellow : Colors.white,
                  fontWeight: route == item.path ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
        IconButton(
          tooltip: 'Login / Register',
          onPressed: () => go(context, '/login'),
          icon: const Icon(Icons.person_outline),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, String route) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Brand.deepBlue, Brand.deepBlueLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MT Alchemy', style: heading(24, color: Brand.softYellow)),
                  const SizedBox(height: 4),
                  Text('People development consultancy',
                      style: body(13, color: Colors.white70)),
                ],
              ),
            ),
            for (final item in allRoutes)
              ListTile(
                leading: Icon(item.icon,
                    color: route == item.path ? Brand.purple : Brand.grey),
                title: Text(item.label,
                    style: TextStyle(
                        fontWeight: route == item.path
                            ? FontWeight.w700
                            : FontWeight.w500)),
                selected: route == item.path,
                selectedTileColor: Brand.lavender,
                onTap: () {
                  Navigator.pop(context); // close drawer
                  go(context, item.path);
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined, color: Brand.purple),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                go(context, '/cart');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Section = Container
/// ---------------------------------------------------------------------------
/// Reusable page band. Demonstrates [Container] used for width, padding,
/// background colour / gradient and max-width centring.
class Section extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Gradient? gradient;
  final double vertical;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  const Section({
    super.key,
    required this.child,
    this.color,
    this.gradient,
    this.vertical = 72,
    this.maxWidth = 1180,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: color, gradient: gradient),
      padding: padding ??
          EdgeInsets.symmetric(vertical: vertical, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

/// A Container used specifically as a decorated card - grouped content,
/// rounded border, soft shadow. Used across the whole app.
class Panel extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final double radius;
  final VoidCallback? onTap;
  const Panel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(24),
    this.borderColor,
    this.radius = 18,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? Brand.line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F1B2A4A), blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      padding: padding,
      // Material provides the ink/background surface required by ListTile and
      // its variants (RadioListTile, CheckboxListTile) when placed on a
      // coloured Container.
      child: Material(
        type: MaterialType.transparency,
        child: onTap == null
            ? child
            : InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: onTap,
                child: child,
              ),
      ),
    );
  }
}

/// Small uppercase label used above headings.
class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;
  const Eyebrow(this.text, {super.key, this.color = Brand.softYellowDeep});
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(
            color: color,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w700,
            fontSize: 13),
      );
}

/// ---------------------------------------------------------------------------
/// Hero
/// ---------------------------------------------------------------------------
class PageHero extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final List<Widget> actions;
  final String? image;
  const PageHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.actions = const [],
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(eyebrow),
        const SizedBox(height: 18),
        Text(title, style: heading(wide ? 46 : 32, color: Colors.white)),
        const SizedBox(height: 18),
        Text(subtitle, style: body(18, color: Colors.white.withValues(alpha: 0.85))),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: 30),
          Wrap(spacing: 14, runSpacing: 14, children: actions),
        ],
      ],
    );

    return Section(
      vertical: 64,
      gradient: const LinearGradient(
        colors: [Brand.deepBlueDark, Brand.deepBlue, Brand.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: wide && image != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: text),
                const SizedBox(width: 40),
                Expanded(flex: 2, child: _HeroImage(image!)),
              ],
            )
          : text,
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String image;
  const _HeroImage(this.image);
  @override
  Widget build(BuildContext context) => Container(
        height: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24, width: 4),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          boxShadow: const [
            BoxShadow(color: Color(0x33101B31), blurRadius: 30, offset: Offset(0, 12)),
          ],
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Cards & grids
/// ---------------------------------------------------------------------------
class ServiceCard extends StatelessWidget {
  final ServiceItem item;
  final bool showCta;
  const ServiceCard(this.item, {super.key, this.showCta = false});
  @override
  Widget build(BuildContext context) => Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Brand.lavender,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: Brand.purple),
            ),
            const SizedBox(height: 16),
            Text(item.title, style: heading(19)),
            const SizedBox(height: 8),
            Text(item.blurb, style: body(14.5, color: Brand.grey)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Brand.mist,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text('For: ${item.whoFor}',
                  style: body(12, color: Brand.deepBlue, weight: FontWeight.w600)),
            ),
            if (showCta) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => go(context, '/contact'),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Enquire'),
              ),
            ],
          ],
        ),
      );
}

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard(this.course, {super.key});
  @override
  Widget build(BuildContext context) => Panel(
        onTap: () => Navigator.pushNamed(context, '/course', arguments: course),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.asset(course.image,
                  height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.category,
                      style: body(12,
                          color: Brand.purple, weight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(course.title, style: heading(18), maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.person_outline, size: 15, color: Brand.grey),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(course.instructor,
                            style: body(12.5, color: Brand.grey),
                            overflow: TextOverflow.ellipsis)),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.access_time, size: 15, color: Brand.grey),
                    const SizedBox(width: 4),
                    Text('${course.duration} · ${course.modules} modules',
                        style: body(12.5, color: Brand.grey)),
                  ]),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RM${course.price.toStringAsFixed(0)}',
                          style: heading(18, color: Brand.deepBlue)),
                      Row(children: [
                        const Icon(Icons.star, size: 16, color: Brand.softYellowDeep),
                        const SizedBox(width: 4),
                        Text(course.rating.toStringAsFixed(1), style: body(13)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {super.key});
  @override
  Widget build(BuildContext context) => Panel(
        onTap: () =>
            Navigator.pushNamed(context, '/product', arguments: product),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.asset(product.image,
                    height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: product.type == 'Digital'
                        ? Brand.purple
                        : Brand.deepBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(product.type,
                      style: body(11,
                          color: Colors.white, weight: FontWeight.w700)),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.category,
                      style: body(12, color: Brand.grey, weight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(product.name, style: heading(17), maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(product.description,
                      style: body(13, color: Brand.grey),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 14),
                  Text('RM${product.price.toStringAsFixed(0)}',
                      style: heading(18, color: Brand.deepBlue)),
                ],
              ),
            ),
          ],
        ),
      );
}

class StoryCard extends StatelessWidget {
  final ImpactStory story;
  const StoryCard(this.story, {super.key});
  @override
  Widget build(BuildContext context) => Panel(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.asset(story.image,
                  height: 170, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Brand.softYellow,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(story.clientType,
                          style: body(11,
                              color: Brand.deepBlue, weight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(story.participants,
                            overflow: TextOverflow.ellipsis,
                            style: body(12, color: Brand.grey))),
                  ]),
                  const SizedBox(height: 12),
                  Text(story.title, style: heading(18)),
                  const SizedBox(height: 8),
                  Text(story.outcome, style: body(13.5, color: Brand.grey)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 6, runSpacing: 6, children: [
                    for (final t in story.tags)
                      Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Brand.mist,
                        side: BorderSide.none,
                        label: Text(t, style: body(11.5)),
                      ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Responsive wrap grid used by every content page.
class CardGrid extends StatelessWidget {
  final List<Widget> children;
  final double minWidth;
  const CardGrid({super.key, required this.children, this.minWidth = 300});
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, box) {
        final cols = (box.maxWidth / minWidth).floor().clamp(1, 3);
        final w = (box.maxWidth - (cols - 1) * 20) / cols;
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final c in children) SizedBox(width: w, child: c),
          ],
        );
      });
}

/// A container-based heading block used at the top of content sections.
class SectionHeading extends StatelessWidget {
  final String title;
  final String? intro;
  final bool center;
  const SectionHeading(this.title, {super.key, this.intro, this.center = false});
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment:
            center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(title,
              textAlign: center ? TextAlign.center : TextAlign.start,
              style: heading(30)),
          if (intro != null) ...[
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(intro!,
                  textAlign: center ? TextAlign.center : TextAlign.start,
                  style: body(16, color: Brand.grey)),
            ),
          ],
        ],
      );
}

class CtaBand extends StatelessWidget {
  final String title;
  final String label;
  final String path;
  const CtaBand({
    super.key,
    this.title = "Let's build a thriving workplace together.",
    this.label = 'Get a Free Consultation',
    this.path = '/contact',
  });
  @override
  Widget build(BuildContext context) => Section(
        gradient: const LinearGradient(
          colors: [Brand.deepBlue, Brand.purple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        child: Column(children: [
          Text(title,
              textAlign: TextAlign.center,
              style: heading(30, color: Colors.white)),
          const SizedBox(height: 22),
          FilledButton(
              onPressed: () => go(context, path), child: Text(label)),
        ]),
      );
}

class StatTile extends StatelessWidget {
  final String value;
  final String label;
  const StatTile(this.value, this.label, {super.key});
  @override
  Widget build(BuildContext context) => Panel(
        color: Colors.white.withValues(alpha: 0.06),
        borderColor: Colors.white24,
        child: Column(children: [
          Text(value, style: heading(34, color: Brand.softYellow)),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: body(14, color: Colors.white70)),
        ]),
      );
}

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: Brand.deepBlueDark,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(children: [
              Text('MT Alchemy', style: heading(26, color: Brand.softYellow)),
              const SizedBox(height: 8),
              Text(
                  'Elevate your value: master human intelligence in a rapidly evolving AI-driven world.',
                  textAlign: TextAlign.center,
                  style: body(14, color: Colors.white70)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  for (final r in allRoutes)
                    TextButton(
                      onPressed: () => go(context, r.path),
                      child: Text(r.label,
                          style: body(13.5, color: Colors.white)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('© 2026 MT Alchemy | Kaedae Event Management',
                  style: body(12, color: Colors.white38)),
            ]),
          ),
        ),
      );
}
