import 'package:cloud_firestore/cloud_firestore.dart';

/// QuizResult model stored in the 'quiz_results' collection.
class QuizResult {
  final String id;
  final String studentId;
  final String quizId;
  final String lessonId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int timeTakenSeconds;
  final List<int> selectedAnswers;
  final bool passed;
  final DateTime completedAt;
  final DateTime createdAt;

  QuizResult({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.lessonId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTakenSeconds,
    required this.selectedAnswers,
    required this.passed,
    required this.completedAt,
    required this.createdAt,
  });

  factory QuizResult.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizResult(
      id: doc.id,
      studentId: data['studentId'] as String,
      quizId: data['quizId'] as String,
      lessonId: data['lessonId'] as String,
      score: data['score'] as int,
      totalQuestions: data['totalQuestions'] as int,
      correctAnswers: data['correctAnswers'] as int,
      timeTakenSeconds: data['timeTakenSeconds'] as int,
      selectedAnswers: List<int>.from(data['selectedAnswers'] ?? []),
      passed: data['passed'] as bool,
      completedAt: (data['completedAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'quizId': quizId,
      'lessonId': lessonId,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'timeTakenSeconds': timeTakenSeconds,
      'selectedAnswers': selectedAnswers,
      'passed': passed,
      'completedAt': Timestamp.fromDate(completedAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
