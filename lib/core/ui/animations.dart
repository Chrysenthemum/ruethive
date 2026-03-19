import 'package:flutter/material.dart';
import '../constants.dart';



class AppAnimations {
  AppAnimations._();

  //  Curves
  static const Curve standard   = Curves.easeInOut;
  static const Curve decelerate = Curves.easeOutCubic;  // entrances
  static const Curve spring     = Curves.elasticOut;    // playful scale pops
  static const Curve emphasis   = Curves.fastOutSlowIn; // nav transitions

  //  Scale values
  static const double calendarCellPressed = 0.92;
  static const double bottomNavSelected   = 1.12;
  static const double cardHoverLift       = -2.0; // offset Y in pixels
}



class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  const AnimatedScaleButton({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = AppAnimations.calendarCellPressed,
  });

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) => setState(() => _pressed = false),
      onTapCancel: ()  => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale:    _pressed ? widget.pressedScale : 1.0,
        duration: AppConstants.fastAnimation,
        curve:    AppAnimations.standard,
        child: widget.child,
      ),
    );
  }
}




class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset slideOffset; // starting offset, e.g. Offset(0, 0.04)

  const FadeInWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideOffset = const Offset(0, 0.03),
  });

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>  _opacity;
  late final Animation<Offset>  _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: AppConstants.mediumAnimation,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: AppAnimations.decelerate),
    );
    _slide = Tween<Offset>(begin: widget.slideOffset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppAnimations.decelerate));

    if (widget.delay == Duration.zero) {
      _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}


enum SlideFrom { bottom, left, right, top }

class SlideInWidget extends StatefulWidget {
  final Widget child;
  final SlideFrom from;
  final Duration delay;

  const SlideInWidget({
    super.key,
    required this.child,
    this.from  = SlideFrom.bottom,
    this.delay = Duration.zero,
  });

  @override
  State<SlideInWidget> createState() => _SlideInWidgetState();
}

class _SlideInWidgetState extends State<SlideInWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset>   _slide;
  late final Animation<double>   _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: AppConstants.mediumAnimation,
    );

    final begin = switch (widget.from) {
      SlideFrom.bottom => const Offset(0,  0.12),
      SlideFrom.top    => const Offset(0, -0.12),
      SlideFrom.left   => const Offset(-0.12, 0),
      SlideFrom.right  => const Offset(0.12,  0),
    };

    _slide = Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: AppAnimations.decelerate),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: AppAnimations.decelerate),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}




class HoverLiftCard extends StatefulWidget {
  final Widget child;

  const HoverLiftCard({super.key, required this.child});

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppConstants.fastAnimation,
        curve: AppAnimations.standard,
        transform: Matrix4.translationValues(
          0, _hovered ? AppAnimations.cardHoverLift : 0, 0,
        ),
        child: widget.child,
      ),
    );
  }
}




class AnimatedNavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Color? color;

  const AnimatedNavIcon({
    super.key,
    required this.icon,
    required this.isSelected,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale:    isSelected ? AppAnimations.bottomNavSelected : 1.0,
      duration: AppConstants.fastAnimation,
      curve:    AppAnimations.decelerate,
      child: Icon(
        icon,
        color: color ?? (isSelected ? scheme.primary : scheme.onSurfaceVariant),
      ),
    );
  }
}






class AnimatedIconRotation extends StatelessWidget {
  final IconData icon;
  final bool rotated;
  final double turns;       // how far to rotate when [rotated] is true (0.5 = 180°)
  final Color? color;
  final double size;

  const AnimatedIconRotation({
    super.key,
    required this.icon,
    required this.rotated,
    this.turns = 0.5,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: rotated ? turns : 0,
      duration: AppConstants.fastAnimation,
      curve: AppAnimations.standard,
      child: Icon(icon, color: color, size: size),
    );
  }
}


class PanelSwitcher extends StatelessWidget {
  final Widget child;

  const PanelSwitcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppConstants.mediumAnimation,
      switchInCurve:  AppAnimations.decelerate,
      switchOutCurve: AppAnimations.standard,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
