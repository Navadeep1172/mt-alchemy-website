import 'package:flutter/material.dart';
import 'data.dart';
import 'motion.dart';
import 'theme.dart';

/// Central navigation helper - every button uses named routes through
/// Flutter's [Navigator] (see `onGenerateRoute` in main.dart).
void go(BuildContext context, String path) =>
    Navigator.pushNamed(context, path);

/// ---------------------------------------------------------------------------
/// Shell = Scaffold
/// ---------------------------------------------------------------------------
/// Every screen is wrapped in this Shell. It is the single place where the
/// Flutter [Scaffold] is used: AppBar, Drawer (mobile navigation), a floating
/// cart button with a pulsing halo, and a scroll-progress bar.
class Shell extends StatefulWidget {
  final List<Widget> children;
  final bool appBar;
  const Shell({super.key, required this.children, this.appBar = true});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final ScrollController _scroll = ScrollController();
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final max = _scroll.position.maxScrollExtent;
    final v = max <= 0 ? 0.0 : (_scroll.offset / max).clamp(0.0, 1.0);
    if ((v - _progress).abs() > 0.001) setState(() => _progress = v);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name ?? '/';
    final wide = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      // ---- Scaffold.floatingActionButton: the cart, with a pulse halo ----
      floatingActionButton: route == '/cart'
          ? null
          : PulseHalo(
              child: FloatingActionButton.extended(
                onPressed: () => go(context, '/cart'),
                backgroundColor: Brand.purple,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Cart'),
              ),
            ),
      appBar: widget.appBar ? _buildAppBar(context, route, wide) : null,
      drawer: widget.appBar && !wide ? _buildDrawer(context, route) : null,
      body: Stack(children: [
        SingleChildScrollView(
          controller: _scroll,
          child: Column(children: [...widget.children, const Footer()]),
        ),
        if (widget.appBar)
          Positioned(top: 0, left: 0, right: 0, child: _ScrollProgress(_progress)),
      ]),
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
          const _LogoBadge(),
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
            _NavLink(
              item: item,
              active: route == item.path,
              onTap: () => go(context, item.path),
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
              child: AnimatedBackdrop(
                particles: false,
                intensity: 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MT Alchemy',
                        style: heading(24, color: Brand.softYellow)),
                    const SizedBox(height: 4),
                    Text('People development consultancy',
                        style: body(13, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            for (var i = 0; i < allRoutes.length; i++)
              Reveal(
                delay: Duration(milliseconds: i * 26),
                offset: const Offset(26, 0),
                child: ListTile(
                  leading: Icon(allRoutes[i].icon,
                      color: route == allRoutes[i].path
                          ? Brand.purple
                          : Brand.grey),
                  title: Text(allRoutes[i].label,
                      style: TextStyle(
                          fontWeight: route == allRoutes[i].path
                              ? FontWeight.w700
                              : FontWeight.w500)),
                  selected: route == allRoutes[i].path,
                  selectedTileColor: Brand.lavender,
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    go(context, allRoutes[i].path);
                  },
                ),
              ),
            const Divider(),
            ListTile(
              leading:
                  const Icon(Icons.shopping_cart_outlined, color: Brand.purple),
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

/// The "MT" mark - spins gently and lifts on hover.
class _LogoBadge extends StatefulWidget {
  const _LogoBadge();
  @override
  State<_LogoBadge> createState() => _LogoBadgeState();
}

class _LogoBadgeState extends State<_LogoBadge> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        width: 38,
        height: 38,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateZ(_hover ? 0.14 : 0)
          ..scaleByDouble(
              _hover ? 1.08 : 1.0, _hover ? 1.08 : 1.0, 1, 1),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Brand.softYellow, Brand.softYellowDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hover
              ? [
                  BoxShadow(
                      color: Brand.softYellow.withValues(alpha: 0.4),
                      blurRadius: 16)
                ]
              : const [],
        ),
        alignment: Alignment.center,
        child: Text('MT',
            style:
                heading(16, color: Brand.deepBlue, weight: FontWeight.w700)),
      ),
    );
  }
}

/// AppBar link with a sliding active/hover underline.
class _NavLink extends StatefulWidget {
  final NavItem item;
  final bool active;
  final VoidCallback onTap;
  const _NavLink({required this.item, required this.active, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final on = widget.active || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          foregroundColor: on ? Brand.softYellow : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            widget.item.label,
            style: TextStyle(
              color: on ? Brand.softYellow : Colors.white,
              fontWeight: on ? FontWeight.w700 : FontWeight.w500,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 2,
            width: on ? 22 : 0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Brand.softYellow, Brand.purpleLight]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Thin gradient bar that tracks reading progress down the page.
class _ScrollProgress extends StatelessWidget {
  final double value;
  const _ScrollProgress(this.value);
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 3,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Brand.softYellow, Brand.purple]),
              ),
            ),
          ),
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Section = Container
/// ---------------------------------------------------------------------------
/// Reusable page band. Demonstrates [Container] used for width, padding,
/// background colour / gradient and max-width centring. Content reveals itself
/// as it scrolls into view, and an optional [backdrop] paints full-bleed
/// animation behind it.
class Section extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Gradient? gradient;
  final double vertical;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final Widget? backdrop;
  final bool reveal;
  final Duration revealDelay;
  const Section({
    super.key,
    required this.child,
    this.color,
    this.gradient,
    this.vertical = 72,
    this.maxWidth = 1180,
    this.padding,
    this.backdrop,
    this.reveal = true,
    this.revealDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = padding ??
        EdgeInsets.symmetric(vertical: vertical, horizontal: 20);
    Widget content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
    if (reveal) {
      content = Reveal(
        trigger: RevealTrigger.scroll,
        delay: revealDelay,
        child: content,
      );
    }
    content = Padding(padding: resolved, child: content);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: color, gradient: gradient),
      child: backdrop == null
          ? content
          : Stack(children: [
              Positioned.fill(child: backdrop!),
              content,
            ]),
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
        Reveal(
          duration: const Duration(milliseconds: 520),
          child: Eyebrow(eyebrow, color: Brand.softYellow),
        ),
        const SizedBox(height: 18),
        Reveal(
          delay: const Duration(milliseconds: 110),
          duration: const Duration(milliseconds: 700),
          offset: const Offset(0, 42),
          child: GradientText(title, style: heading(wide ? 46 : 32)),
        ),
        const SizedBox(height: 18),
        Reveal(
          delay: const Duration(milliseconds: 240),
          child: Text(subtitle,
              style: body(18, color: Colors.white.withValues(alpha: 0.85))),
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: 30),
          Reveal(
            delay: const Duration(milliseconds: 380),
            child: Wrap(spacing: 14, runSpacing: 14, children: actions),
          ),
        ],
      ],
    );

    return Section(
      vertical: 64,
      reveal: false,
      gradient: const LinearGradient(
        colors: [Brand.deepBlueDark, Brand.deepBlue, Brand.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      backdrop: const AnimatedBackdrop(
        colors: [Brand.purpleLight, Brand.softYellow, Brand.deepBlueLight],
      ),
      child: wide && image != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: text),
                const SizedBox(width: 40),
                Expanded(
                  flex: 2,
                  child: Reveal(
                    delay: const Duration(milliseconds: 220),
                    duration: const Duration(milliseconds: 800),
                    beginScale: 0.94,
                    offset: const Offset(0, 20),
                    child: Tilt(
                      child: Float(
                        distance: 10,
                        child: _HeroImage(image!),
                      ),
                    ),
                  ),
                ),
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
            BoxShadow(
                color: Color(0x55101B31), blurRadius: 40, offset: Offset(0, 18)),
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
  Widget build(BuildContext context) => HoverLift(
        glow: Brand.purple,
        child: Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Brand.purple, Brand.purpleLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x336C4AB6),
                        blurRadius: 14,
                        offset: Offset(0, 6)),
                  ],
                ),
                child: Icon(item.icon, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(item.title, style: heading(19)),
              const SizedBox(height: 8),
              Text(item.blurb, style: body(14.5, color: Brand.grey)),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Brand.mist,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text('For: ${item.whoFor}',
                    style: body(12,
                        color: Brand.deepBlue, weight: FontWeight.w600)),
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
        ),
      );
}

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard(this.course, {super.key});
  @override
  Widget build(BuildContext context) => HoverLift(
        glow: Brand.purple,
        child: Panel(
          onTap: () =>
              Navigator.pushNamed(context, '/course', arguments: course),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: HoverZoom(
                  child: Image.asset(course.image,
                      height: 150, width: double.infinity, fit: BoxFit.cover),
                ),
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
                      const Icon(Icons.person_outline,
                          size: 15, color: Brand.grey),
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
                          const Icon(Icons.star,
                              size: 16, color: Brand.softYellowDeep),
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
        ),
      );
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {super.key});
  @override
  Widget build(BuildContext context) => HoverLift(
        glow: Brand.deepBlueLight,
        child: Panel(
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
                  child: HoverZoom(
                    child: Image.asset(product.image,
                        height: 160, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: product.type == 'Digital'
                            ? const [Brand.purple, Brand.purpleLight]
                            : const [Brand.deepBlue, Brand.deepBlueLight],
                      ),
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
                        style: body(12,
                            color: Brand.grey, weight: FontWeight.w600)),
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
        ),
      );
}

class StoryCard extends StatelessWidget {
  final ImpactStory story;
  const StoryCard(this.story, {super.key});
  @override
  Widget build(BuildContext context) => HoverLift(
        glow: Brand.softYellowDeep,
        child: Panel(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: HoverZoom(
                  child: Image.asset(story.image,
                      height: 170, width: double.infinity, fit: BoxFit.cover),
                ),
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
                                color: Brand.deepBlue,
                                weight: FontWeight.w700)),
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
        ),
      );
}

/// Responsive wrap grid used by every content page. Children cascade in with a
/// small stagger so grids feel alive as they enter the viewport.
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
            for (var i = 0; i < children.length; i++)
              SizedBox(
                width: w,
                child: Reveal(
                  trigger: RevealTrigger.scroll,
                  delay: Duration(milliseconds: i.clamp(0, 5) * 85),
                  child: children[i],
                ),
              ),
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
  Widget build(BuildContext context) => Reveal(
        trigger: RevealTrigger.scroll,
        child: Column(
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
        ),
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
        reveal: false,
        gradient: const LinearGradient(
          colors: [Brand.deepBlue, Brand.purple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        backdrop: const AnimatedBackdrop(
          particles: false,
          intensity: 0.9,
          colors: [Brand.purpleLight, Brand.softYellow],
        ),
        child: Column(children: [
          Reveal(
            trigger: RevealTrigger.scroll,
            child: GradientText(title,
                style: heading(30), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 22),
          Reveal(
            trigger: RevealTrigger.scroll,
            delay: const Duration(milliseconds: 140),
            child: FilledButton(
                onPressed: () => go(context, path), child: Text(label)),
          ),
        ]),
      );
}

class StatTile extends StatelessWidget {
  final String value;
  final String label;
  const StatTile(this.value, this.label, {super.key});
  @override
  Widget build(BuildContext context) => HoverLift(
        glow: Brand.softYellow,
        cursorClick: false,
        child: Panel(
          color: Colors.white.withValues(alpha: 0.06),
          borderColor: Colors.white24,
          child: Column(children: [
            AnimatedCount(value, style: heading(34, color: Brand.softYellow)),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: body(14, color: Colors.white70)),
          ]),
        ),
      );
}

/// A transformation pathway: Discover - Design - Deliver - Sustain. On wide
/// screens the steps sit on an animated gradient rail.
class JourneyStrip extends StatelessWidget {
  final List<(String, String, IconData)> steps;
  const JourneyStrip({
    super.key,
    this.steps = const [
      ('Discover', 'Listen to your people, culture and goals.', Icons.search),
      ('Design', 'Shape a human-centred programme around them.',
          Icons.architecture),
      ('Deliver', 'Facilitate with energy, evidence and care.', Icons.rocket_launch),
      ('Sustain', 'Embed habits that keep the change alive.', Icons.eco),
    ],
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, box) {
        final wide = box.maxWidth >= 820;
        final items = [
          for (var i = 0; i < steps.length; i++)
            Reveal(
              trigger: RevealTrigger.scroll,
              delay: Duration(milliseconds: i * 110),
              child: _JourneyStep(index: i + 1, step: steps[i]),
            ),
        ];
        if (!wide) {
          return Column(children: [
            for (var i = 0; i < items.length; i++) ...[
              items[i],
              if (i != items.length - 1) const SizedBox(height: 16),
            ],
          ]);
        }
        return Stack(children: [
          Positioned(
            top: 45,
            left: 24,
            right: 24,
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Brand.purple,
                  Brand.softYellowDeep,
                  Brand.purpleLight,
                ]),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in items)
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: item)),
            ],
          ),
        ]);
      });
}

class _JourneyStep extends StatelessWidget {
  final int index;
  final (String, String, IconData) step;
  const _JourneyStep({required this.index, required this.step});
  @override
  Widget build(BuildContext context) => HoverLift(
        glow: Brand.purple,
        cursorClick: false,
        child: Panel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Brand.purple, Brand.purpleLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(step.$3, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text('0$index',
                  style: heading(26, color: Brand.softYellowDeep)),
            ]),
            const SizedBox(height: 14),
            Text(step.$1, style: heading(18)),
            const SizedBox(height: 6),
            Text(step.$2, style: body(13.5, color: Brand.grey)),
          ]),
        ),
      );
}

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: Brand.deepBlueDark,
        child: Column(children: [
          Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Brand.purple,
                Brand.softYellow,
                Brand.purpleLight,
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Reveal(
                  trigger: RevealTrigger.scroll,
                  child: Column(children: [
                    Text('MT Alchemy',
                        style: heading(26, color: Brand.softYellow)),
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
            ),
          ),
        ]),
      );
}