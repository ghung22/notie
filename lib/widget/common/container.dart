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
  final List<Case>? cases;
  final Widget child;

  const CaseContainer({
    Key? key,
    this.cases,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cases != null) {
      for (final Case caseItem in cases!) {
        if (caseItem.condition) return caseItem.child;
      }
    }
    return child;
  }
}

class RedContainer extends StatelessWidget {
  final Widget child;

  const RedContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Container(color: Colors.red, child: child);
}