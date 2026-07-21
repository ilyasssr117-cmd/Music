import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:spotiflac_android/widgets/settings_group.dart' show settingsGroupColor;

/// A reusable frosted-glass surface with a soft tint, border, and blur.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final double blurSigma;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? tint;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;

  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blurSigma = 22,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.tint,
    this.border,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceTint = tint ?? settingsGroupColor(context);
    final resolvedBorder = border ??
        Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.34));
    final resolvedShadow = boxShadow ??
        [
          BoxShadow(
            blurRadius: 30,
            spreadRadius: -12,
            offset: const Offset(0, 16),
            color: Colors.black.withValues(alpha: 0.32),
          ),
        ];

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: resolvedShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: resolvedBorder,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  surfaceTint.withValues(alpha: 0.78),
                  Color.alphaBlend(
                    Colors.white.withValues(alpha: 0.04),
                    surfaceTint,
                  ).withValues(alpha: 0.58),
                ],
              ),
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
