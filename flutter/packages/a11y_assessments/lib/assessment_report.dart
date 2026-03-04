/// Assessment report for accessibility evaluation
class AssessmentReport {
  final List<String> issues = [];
  final List<String> warnings = [];
  final DateTime timestamp = DateTime.now();
  
  AssessmentReport();
  
  void addIssue(String issue) {
    issues.add(issue);
  }
  
  void addWarning(String warning) {
    warnings.add(warning);
  }
  
  bool get hasIssues => issues.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  
  @override
  String toString() {
    return 'AssessmentReport(issues: ${issues.length}, warnings: ${warnings.length})';
  }
}