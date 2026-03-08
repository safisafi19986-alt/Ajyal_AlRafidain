import 'package:cloud_firestore/cloud_firestore.dart';

/// Quiz model stored in the 'quizzes' collection.
class Quiz {
  final String id;
  final String lessonId;
  final String title;
  final String titleAr;
  final List<QuizQuestion> questions;
  final int timeLimitSeconds;
  final int passingScore;
  final bool isAiGenerated;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Quiz({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.titleAr,
    required this.questions,
    this.timeLimitSeconds = 300,
    this.passingScore = 60,
    this.isAiGenerated = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Quiz.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final questionsData = data['questions'] as List<dynamic>? ?? [];
    return Quiz(
      id: doc.id,
      lessonId: data['lessonId'] as String,
      title: data['title'] as String,
      titleAr: data['titleAr'] as String,
      questions: questionsData
          .map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>))
          .toList(),
      timeLimitSeconds: data['timeLimitSeconds'] as int? ?? 300,
      passingScore: data['passingScore'] as int? ?? 60,
      isAiGenerated: data['isAiGenerated'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'lessonId': lessonId,
      'title': title,
      'titleAr': titleAr,
      'questions': questions.map((q) => q.toMap()).toList(),
      'timeLimitSeconds': timeLimitSeconds,
      'passingScore': passingScore,
      'isAiGenerated': isAiGenerated,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

/// Individual quiz question.
class QuizQuestion {
  final String questionText;
  final String questionTextAr;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;

  QuizQuestion({
    required this.questionText,
    required this.questionTextAr,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      questionText: map['questionText'] as String,
      questionTextAr: map['questionTextAr'] as String,
      options: List<String>.from(map['options']),
      correctOptionIndex: map['correctOptionIndex'] as int,
      explanation: map['explanation'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'questionTextAr': questionTextAr,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }
}
