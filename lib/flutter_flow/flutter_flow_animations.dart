import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

enum AnimationTrigger {
  onPageLoad,
  onActionTrigger,
}

class AnimationInfo {
  AnimationInfo({
    required this.trigger,
    required this.effectsBuilder,
    this.loop = false,
    this.reverse = false,
    this.applyInitialState = true,
  });

  final AnimationTrigger trigger;
  final List<Effect> Function()? effectsBuilder;
  final bool applyInitialState;
  final bool loop;
  final bool reverse;
  late AnimationController controller;

  List<Effect>? _effects;

  List<Effect> get effects => _effects ??= effectsBuilder!();

  void maybeUpdateEffects(final List<Effect>? updatedEffects) {
    if (updatedEffects != null) {
      _effects = updatedEffects;
    }
  }
}

void createAnimation(
    final AnimationInfo animation, final TickerProvider vsync) {
  final newController = AnimationController(vsync: vsync);
  animation.controller = newController;
}

void setupAnimations(
    final Iterable<AnimationInfo> animations, final TickerProvider vsync) {
  for (final AnimationInfo animation in animations) {
    createAnimation(animation, vsync);
  }
}

extension AnimatedWidgetExtension on Widget {
  Widget animateOnPageLoad(
    final AnimationInfo animationInfo, {
    final List<Effect>? effects,
  }) {
    animationInfo.maybeUpdateEffects(effects);
    return Animate(
      effects: animationInfo.effects,
      child: this,
      onPlay: (final controller) => animationInfo.loop
          ? controller.repeat(reverse: animationInfo.reverse)
          : null,
      onComplete: (final controller) =>
          !animationInfo.loop && animationInfo.reverse
              ? controller.reverse()
              : null,
    );
  }

  Widget animateOnActionTrigger(
    final AnimationInfo animationInfo, {
    final List<Effect>? effects,
    final bool hasBeenTriggered = false,
  }) {
    animationInfo.maybeUpdateEffects(effects);
    return hasBeenTriggered || animationInfo.applyInitialState
        ? Animate(
            controller: animationInfo.controller,
            autoPlay: false,
            effects: animationInfo.effects,
            child: this)
        : this;
  }
}

class TiltEffect extends Effect<Offset> {
  const TiltEffect({
    super.delay,
    super.duration,
    super.curve,
    final Offset? begin,
    final Offset? end,
  }) : super(
          begin: begin ?? Offset.zero,
          end: end ?? Offset.zero,
        );

  @override
  Widget build(
    final BuildContext context,
    final Widget child,
    final AnimationController controller,
    final EffectEntry entry,
  ) {
    Animation<Offset> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<Offset>(
      animation: animation,
      builder: (final _, final __) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(animation.value.dx)
          ..rotateY(animation.value.dy),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
