import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

/// ---------------------------------------------------------------------------
/// Motion system for MT Alchemy
/// ---------------------------------------------------------------------------
/// All animation used across the prototype lives here so the visual language
/// stays consistent and deliberately restrained:
///
///  * [Reveal]              - fade + rise entrance, optionally scroll-triggered
///  * [HoverLift]           - faint pointer-reactive lift for cards
///  * [HoverZoom]           - slow image zoom for media inside cards
///  * [AnimatedBackdrop]    - softly drifting aurora wash behind dark panels
///  * [Marquee]             - slow capability ticker on the home page
///  * [AnimatedCount]       - numbers that count up when they appear
///  * [GradientText]        - faint sweeping sheen on hero headings
///  * [GradientProgressBar] - progress that fills itself
///  * [fadeSlideRoute]      - the shared page transition
///
/// Every looping animation respects the OS "reduce motion" setting
/// (`MediaQuery.disableAnimations`) and is ticker-based (no `Timer`s), which
/// keeps widget tests deterministic.
/// ---------------------------------------------------------------------------

/// Fade + rise entrance animation.
enum RevealTrigger { auto, scroll }

class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final double beginScale;
  final Curve curve;
  final RevealTrigger trigger;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 620),
    this.offset = const Offset(0, 34),
    this.beginScale = 1,
    this.curve = Curves.easeOutCubic,
    this.trigger = RevealTrigger.auto,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;
  ScrollPosition? _position;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    final total = widget.delay + widget.duration;
    _controller = AnimationController(vsync: this, duration: total);
    final start = total.inMicroseconds == 0
        ? 0.0
        : widget.delay.inMicroseconds / total.inMicroseconds;
    _t = CurvedAnimation(
      parent: _controller,
      curve: Interval(start.clamp(0.0, 0.99), 1.0, curve: widget.curve),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;

    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _controller.value = 1;
      _started = true;
      return;
    }

    if (widget.trigger == RevealTrigger.scroll) {
      _position = Scrollable.maybeOf(context)?.position;
      _position?.addListener(_check);
      WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final screen = MediaQuery.of(context).size.height;
    if (top < screen * 0.94) _start();
  }

  void _start() {
    if (_started || !mounted) return;
    _started = true;
    _position?.removeListener(_check);
    _position = null;
    _controller.forward();
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (context, child) {
        final v = _t.value.clamp(0.0, 1.0);
        var result = Transform.translate(
          offset: Offset(
            widget.offset.dx * (1 - v),
            widget.offset.dy * (1 - v),
          ),
          child: child,
        );
        if (widget.beginScale < 1) {
          result = Transform.scale(
            scale: widget.beginScale + (1 - widget.beginScale) * v,
            child: result,
          );
        }
        return Opacity(opacity: v, child: result);
      },
    );
  }
}

/// A short accent rule that draws itself in from the left the first time it
/// scrolls into view. Used as the kicker above section headings.
class DrawBar extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final Duration delay;
  final Duration duration;
  const DrawBar({
    super.key,
    this.width = 52,
    this.height = 4,
    this.color = Brand.clay,
    this.delay = const Duration(milliseconds: 120),
    this.duration = const Duration(milliseconds: 760),
  });

  @override
  State<DrawBar> createState() => _DrawBarState();
}

class _DrawBarState extends State<DrawBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;
  ScrollPosition? _position;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    final total = widget.delay + widget.duration;
    _controller = AnimationController(vsync: this, duration: total);
    final start = total.inMicroseconds == 0
        ? 0.0
        : widget.delay.inMicroseconds / total.inMicroseconds;
    _t = CurvedAnimation(
      parent: _controller,
      curve: Interval(start.clamp(0.0, 0.99), 1.0, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _controller.value = 1;
      _started = true;
      return;
    }
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final screen = MediaQuery.of(context).size.height;
    if (top < screen * 0.94) _start();
  }

  void _start() {
    if (_started || !mounted) return;
    _started = true;
    _position?.removeListener(_check);
    _position = null;
    _controller.forward();
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (context, _) {
        final v = _t.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: (v * 1.6).clamp(0.0, 1.0),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: v,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(widget.height),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Pointer-reactive lift: a quiet raise and soft shadow while hovered.
class HoverLift extends StatefulWidget {
  final Widget child;
  final double lift;
  final double scale;
  final double radius;
  final Color glow;
  final bool cursorClick;
  const HoverLift({
    super.key,
    required this.child,
    this.lift = 5,
    this.scale = 1.008,
    this.radius = 14,
    this.glow = Brand.sage,
    this.cursorClick = true,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.cursorClick ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeOutCubic,
        transformAlignment: Alignment.center,
        transform:
            Matrix4.translationValues(0, _hover ? -widget.lift : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: widget.glow.withValues(alpha: 0.14),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ]
              : const [],
        ),
        child: AnimatedScale(
          scale: _hover ? widget.scale : 1,
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Slow zoom for imagery inside hoverable cards.
class HoverZoom extends StatefulWidget {
  final Widget child;
  final double scale;
  const HoverZoom({super.key, required this.child, this.scale = 1.04});

  @override
  State<HoverZoom> createState() => _HoverZoomState();
}

class _HoverZoomState extends State<HoverZoom> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: ClipRect(
        child: AnimatedScale(
          scale: _hover ? widget.scale : 1,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Softly drifting colour wash behind dark panels. Painted behind its child
/// (or filling its parent when no child is given).
class AnimatedBackdrop extends StatefulWidget {
  final Widget? child;
  final double intensity;
  final List<Color> colors;
  const AnimatedBackdrop({
    super.key,
    this.child,
    this.intensity = 1,
    this.colors = const [
      Brand.sage,
      Brand.greenLight,
      Brand.clay,
    ],
  });

  @override
  State<AnimatedBackdrop> createState() => _AnimatedBackdropState();
}

class _AnimatedBackdropState extends State<AnimatedBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 32));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!(MediaQuery.maybeDisableAnimationsOf(context) ?? false)) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        willChange: true,
        painter: _BackdropPainter(
          t: _controller,
          colors: widget.colors,
          intensity: widget.intensity,
        ),
        child: widget.child,
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  final Animation<double> t;
  final List<Color> colors;
  final double intensity;

  _BackdropPainter({
    required this.t,
    required this.colors,
    required this.intensity,
  }) : super(repaint: t);

  @override
  void paint(Canvas canvas, Size size) {
    final v = t.value;
    final w = size.width, h = size.height;
    final short = math.min(w, h);

    for (var i = 0; i < colors.length; i++) {
      final phase = i * 2.1;
      final cx = w * (0.5 + 0.36 * math.sin(v * 2 * math.pi + phase));
      final cy = h * (0.5 + 0.30 * math.cos(v * 2 * math.pi * 0.8 + phase));
      final radius =
          short * (0.42 + 0.10 * math.sin(v * 2 * math.pi + phase * 1.7));
      final center = Offset(cx, cy);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i].withValues(alpha: 0.22 * intensity),
            colors[i].withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter old) => old.t != t;
}

/// Endless horizontal ticker for keyword / value strips.
class Marquee extends StatefulWidget {
  final List<Widget> items;
  final Widget? separator;
  final double speed;
  final double gap;
  final EdgeInsetsGeometry padding;
  final bool pauseOnHover;

  const Marquee({
    super.key,
    required this.items,
    this.separator,
    this.speed = 26,
    this.gap = 32,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.pauseOnHover = true,
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee>
    with SingleTickerProviderStateMixin {
  final GlobalKey _rowKey = GlobalKey();
  final ScrollController _scroll = ScrollController();
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 20));
  double _cycle = 0;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_tick);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  /// The row holds three identical copies; one copy plus a [gap] is one cycle,
  /// which makes the wrap-around at the end of the loop invisible.
  void _measure() {
    if (!mounted) return;
    final box = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 0;
    if (width <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
      return;
    }
    _cycle = (width - 2 * widget.gap) / 3 + widget.gap;
    final ms = (_cycle / widget.speed * 1000).round().clamp(4000, 240000);
    _controller.duration = Duration(milliseconds: ms);
    if (_started) return;
    _started = true;
    if (!(MediaQuery.maybeDisableAnimationsOf(context) ?? false)) {
      _controller.repeat();
    }
  }

  void _tick() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    _scroll.jumpTo((_controller.value * _cycle).clamp(0.0, max));
  }

  @override
  void dispose() {
    _controller.removeListener(_tick);
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strip = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.items.length; i++) ...[
          widget.items[i],
          SizedBox(width: widget.gap),
          if (widget.separator != null) ...[
            widget.separator!,
            SizedBox(width: widget.gap),
          ],
        ],
      ],
    );

    return MouseRegion(
      cursor: MouseCursor.defer,
      onEnter: widget.pauseOnHover ? (_) => _controller.stop() : null,
      onExit: widget.pauseOnHover ? (_) => _controller.repeat() : null,
      child: Padding(
        padding: widget.padding,
        child: SingleChildScrollView(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            key: _rowKey,
            mainAxisSize: MainAxisSize.min,
            children: [
              strip,
              SizedBox(width: widget.gap),
              strip,
              SizedBox(width: widget.gap),
              strip,
            ],
          ),
        ),
      ),
    );
  }
}

/// Counts a numeric value up when it first appears. Keeps any prefix/suffix
/// (e.g. "RM42k", "1,100+", "64%").
class AnimatedCount extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  const AnimatedCount(this.text,
      {super.key, this.style, this.duration = const Duration(milliseconds: 1400)});

  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'^(\D*?)([\d,]+(?:\.\d+)?)(.*)$').firstMatch(text);
    if (match == null) return Text(text, style: style);

    final prefix = match.group(1) ?? '';
    final raw = match.group(2) ?? '';
    final suffix = match.group(3) ?? '';
    final target = double.tryParse(raw.replaceAll(',', '')) ?? 0;
    final decimals = raw.contains('.') ? raw.split('.').last.length : 0;
    final grouped = raw.contains(',');

    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return Text(text, style: style);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: target),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final valueText = decimals > 0
            ? value.toStringAsFixed(decimals)
            : value.round().toString();
        final formatted =
            grouped ? _withCommas(valueText) : valueText;
        return Text('$prefix$formatted$suffix', style: style);
      },
    );
  }

  static String _withCommas(String digits) {
    final parts = digits.split('.');
    final intPart = parts.first;
    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return parts.length > 1 ? '$buffer.${parts[1]}' : buffer.toString();
  }
}

/// Heading text with a slowly sweeping gradient sheen.
class GradientText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final Duration period;
  final TextAlign? textAlign;
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.colors = const [Brand.green, Brand.clayDeep, Brand.green],
    this.period = const Duration(seconds: 9),
    this.textAlign,
  });

  @override
  State<GradientText> createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.period);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!(MediaQuery.maybeDisableAnimationsOf(context) ?? false)) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final v = _controller.value * 4 - 2;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment(v, 0),
            end: Alignment(v + 1.6, 0),
            colors: widget.colors,
          ).createShader(rect),
          child: Text(widget.text,
              style: widget.style, textAlign: widget.textAlign),
        );
      },
    );
  }
}

/// Progress bar that fills itself with a brand gradient.
class GradientProgressBar extends StatefulWidget {
  final double value;
  final double height;
  final Color track;
  final List<Color> colors;
  const GradientProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.track = Brand.mist,
    this.colors = const [Brand.green, Brand.clay],
  });

  @override
  State<GradientProgressBar> createState() => _GradientProgressBarState();
}

class _GradientProgressBarState extends State<GradientProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 950));

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant GradientProgressBar old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _controller.forward(from: 0.35);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.value.clamp(0.0, 1.0);
    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.height),
        child: LayoutBuilder(
          builder: (context, box) => Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: widget.track)),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final v = Curves.easeOutCubic
                      .transform(_controller.value.clamp(0.0, 1.0));
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: box.maxWidth * target * v,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: widget.colors),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The shared page transition: fade + rise + tiny scale.
PageRoute<T> fadeSlideRoute<T>(RouteSettings settings, Widget page) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.035),
            end: Offset.zero,
          ).animate(curved),
          child: ScaleTransition(
            scale: Tween(begin: 0.985, end: 1.0).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

/// Applies [fadeSlideRoute] as the default transition on every platform.
class FadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeSlidePageTransitionsBuilder();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route is PageRouteBuilder) return child;
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.035), end: Offset.zero)
            .animate(curved),
        child: child,
      ),
    );
  }
}