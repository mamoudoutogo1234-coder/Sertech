import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import 'reduced_motion.dart';

/// Widget d'entrée en cascade (fade + slide up) avec prise en compte du
/// reduced motion.
///
/// À utiliser autour d'un item de liste pour créer un effet de défilement
/// fluide et discret.
class StaggeredEntrance extends StatefulWidget {
  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.delayMultiplier = 1,
    this.offset = const Offset(0, 8),
    this.duration,
    this.curve,
  });

  final int index;
  final Widget child;
  final int delayMultiplier;
  final Offset offset;
  final Duration? duration;
  final Curve? curve;

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? AppMotion.normal,
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? AppMotion.enter,
    );
    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve ?? AppMotion.enter,
      ),
    );
    _start();
  }

  void _start() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        if (shouldReduceMotion(context)) {
          if (mounted) _controller.value = 1;
          return;
        }
        final delay = AppMotion.stagger * widget.index * widget.delayMultiplier;
        Future.delayed(delay, () {
          if (!mounted) return;
          try {
            _controller.forward();
          } catch (_) {
            if (mounted) _controller.value = 1;
          }
        });
      } catch (_) {
        if (mounted) _controller.value = 1;
      }
    });
  }

  @override
  void didUpdateWidget(covariant StaggeredEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index && shouldReduceMotion(context)) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (shouldReduceMotion(context)) {
        return widget.child;
      }
    } catch (_) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Wrapper pour animer l'apparition d'un groupe d'éléments avec un léger
/// décalage global.
class StaggeredList extends StatelessWidget {
  const StaggeredList({
    super.key,
    required this.children,
    this.delayMultiplier = 1,
    this.offset = const Offset(0, 8),
  });

  final List<Widget> children;
  final int delayMultiplier;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    if (shouldReduceMotion(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++)
          StaggeredEntrance(
            index: i,
            delayMultiplier: delayMultiplier,
            offset: offset,
            child: children[i],
          ),
      ],
    );
  }
}
