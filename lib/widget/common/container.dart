import 'package:flutter/material.dart';

class Nothing extends StatelessWidget {
  const Nothing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class Case {
  final bool condition;
  final Widget child;

  const Case({required this.condition, required this.child});
}

class CaseContainer extends StatelessWidget {
  final List<Case> cases;
  final Widget child;

  const CaseContainer({
    Key? key,
    this.cases = const [],
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (final Case caseItem in cases) {
      if (caseItem.condition) return caseItem.child;
    }
    return child;
  }
}

/// A builder wrapped in a container
class BuilderContainer extends Container {
  final Widget Function(BuildContext context) builder;
  final double? width;
  final double? height;

  BuilderContainer({
    Key? key,
    required this.builder,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    this.width,
    this.height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) : super(
          key: key,
          alignment: alignment,
          padding: padding,
          color: color,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
          transform: transform,
          transformAlignment: transformAlignment,
          clipBehavior: clipBehavior,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: Builder(builder: builder),
    );
  }
}

class RedContainer extends StatelessWidget {
  final Widget child;

  const RedContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Container(color: Colors.red, child: child);
}