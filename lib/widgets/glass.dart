import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Soft gradient backdrop with two blurred light blobs. Everything else in the
/// app is drawn on top of it, so the glass surfaces have something to blur.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: _BackdropPainter(brightness)),
        child,
      ],
    );
  }
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter(this.brightness);

  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    final dark = brightness == Brightness.dark;
    final rect = Offset.zero & size;

    final base = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: dark
            ? const [Color(0xFF06110D), Color(0xFF081812), Color(0xFF040C09)]
            : const [Color(0xFFF4FBF7), Color(0xFFE9F6EF), Color(0xFFF7FCF9)],
      ).createShader(rect);
    canvas.drawRect(rect, base);

    void blob(Offset center, double radius, Color color) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    blob(
      Offset(size.width * 0.85, size.height * 0.08),
      size.width * 0.65,
      brandGreen.withValues(alpha: dark ? 0.30 : 0.20),
    );
    blob(
      Offset(size.width * 0.05, size.height * 0.45),
      size.width * 0.55,
      (dark ? const Color(0xFF1FD394) : const Color(0xFF8BE8C2))
          .withValues(alpha: dark ? 0.16 : 0.28),
    );
    blob(
      Offset(size.width * 0.6, size.height * 0.95),
      size.width * 0.7,
      const Color(0xFF3B82F6).withValues(alpha: dark ? 0.10 : 0.08),
    );
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) =>
      oldDelegate.brightness != brightness;
}

/// Frosted panel used by cards, sheets and dialogs.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.radius = 22,
    this.onTap,
    this.blur = 0,
    this.tint,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final VoidCallback? onTap;
  final double blur;
  final Color? tint;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = tint ??
        (dark
            ? Colors.white.withValues(alpha: 0.055)
            : Colors.white.withValues(alpha: 0.62));
    final border = borderColor ??
        (dark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.white.withValues(alpha: 0.85));
    final shape = BorderRadius.circular(radius);

    Widget surface = Container(
      decoration: BoxDecoration(
        color: base,
        borderRadius: shape,
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.35 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: shape,
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : InkWell(
                borderRadius: shape,
                onTap: onTap,
                child: Padding(padding: padding, child: child),
              ),
      ),
    );

    if (blur > 0) {
      surface = ClipRRect(
        borderRadius: shape,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: surface,
        ),
      );
    }

    return margin == null ? surface : Padding(padding: margin!, child: surface);
  }
}
