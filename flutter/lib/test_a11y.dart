// Test file to reproduce a11y_assessments import errors
import 'package:flutter/widgets.dart';
import 'package:a11y_assessments/accessibility_checker.dart';
import 'package:a11y_assessments/a11y_utils.dart';

class A11yTestWidget extends StatelessWidget {
  const A11yTestWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const AccessibilityChecker();
  }
}

void runAssessment() {
  A11yUtils.checkAccessibility();
}