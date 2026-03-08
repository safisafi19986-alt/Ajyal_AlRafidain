import 'package:cloud_firestore/cloud_firestore.dart';

/// AiReport model stored in the 'ai_reports' collection.
/// AI-driven performance and learning analytics reports.
class AiReport {
  final String id;
  final String studentId;
  final String reportType;
  final String summary;
  final String summaryAr;
  final Map<String, dynamic> metrics;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;
  final DateTime generatedAt;
  final DateTime createdAt;

  AiReport({
    required this.id,
    required this.studentId,
    required this.reportType,
    required this.summary,
    required this.summaryAr,
    required this.metrics,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
    required this.generatedAt,
    required this.createdAt,
  });

  factory AiReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AiReport(
      id: doc.id,
      studentId: data['studentId'] as String,
      reportType: data['reportType'] as String,
      summary: data['summary'] as String,
      summaryAr: data['summaryAr'] as String,
      metrics: Map<String, dynamic>.from(data['metrics'] ?? {}),
      strengths: List<String>.from(data['strengths'] ?? []),
      weaknesses: List<String>.from(data['weaknesses'] ?? []),
      recommendations: List<String>.from(data['recommendations'] ?? []),
      generatedAt: (data['generatedAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'reportType': reportType,
      'summary': summary,
      'summaryAr': summaryAr,
      'metrics': metrics,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'recommendations': recommendations,
      'generatedAt': Timestamp.fromDate(generatedAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
