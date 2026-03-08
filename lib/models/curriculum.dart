import 'package:cloud_firestore/cloud_firestore.dart';

/// Curriculum model stored in the 'curriculum' collection.
class Curriculum {
  final String id;
  final String title;
  final String titleAr;
  final String subject;
  final int grade;
  final String? description;
  final String? thumbnailUrl;
  final int totalLessons;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Curriculum({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.subject,
    required this.grade,
    this.description,
    this.thumbnailUrl,
    required this.totalLessons,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Curriculum.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Curriculum(
      id: doc.id,
      title: data['title'] as String,
      titleAr: data['titleAr'] as String,
      subject: data['subject'] as String,
      grade: data['grade'] as int,
      description: data['description'] as String?,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      totalLessons: data['totalLessons'] as int? ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'titleAr': titleAr,
      'subject': subject,
      'grade': grade,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'totalLessons': totalLessons,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
