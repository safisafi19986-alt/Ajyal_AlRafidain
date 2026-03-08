import 'package:cloud_firestore/cloud_firestore.dart';

/// StudentProgress model stored in the 'student_progress' collection.
class StudentProgress {
  final String id;
  final String studentId;
  final String lessonId;
  final String curriculumId;
  final double progressPercent;
  final int watchedSeconds;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentProgress({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.curriculumId,
    this.progressPercent = 0.0,
    this.watchedSeconds = 0,
    this.isCompleted = false,
    this.completedAt,
    required this.lastAccessedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentProgress(
      id: doc.id,
      studentId: data['studentId'] as String,
      lessonId: data['lessonId'] as String,
      curriculumId: data['curriculumId'] as String,
      progressPercent: (data['progressPercent'] as num?)?.toDouble() ?? 0.0,
      watchedSeconds: data['watchedSeconds'] as int? ?? 0,
      isCompleted: data['isCompleted'] as bool? ?? false,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      lastAccessedAt: (data['lastAccessedAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'lessonId': lessonId,
      'curriculumId': curriculumId,
      'progressPercent': progressPercent,
      'watchedSeconds': watchedSeconds,
      'isCompleted': isCompleted,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'lastAccessedAt': Timestamp.fromDate(lastAccessedAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
