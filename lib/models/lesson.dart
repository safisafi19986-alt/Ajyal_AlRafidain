import 'package:cloud_firestore/cloud_firestore.dart';

/// Lesson model stored in the 'lessons' collection.
class Lesson {
  final String id;
  final String curriculumId;
  final String title;
  final String titleAr;
  final String? description;
  final String? videoUrl;
  final String? hlsUrl;
  final String? thumbnailUrl;
  final int orderIndex;
  final int durationSeconds;
  final bool isPremium;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.curriculumId,
    required this.title,
    required this.titleAr,
    this.description,
    this.videoUrl,
    this.hlsUrl,
    this.thumbnailUrl,
    required this.orderIndex,
    this.durationSeconds = 0,
    this.isPremium = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lesson(
      id: doc.id,
      curriculumId: data['curriculumId'] as String,
      title: data['title'] as String,
      titleAr: data['titleAr'] as String,
      description: data['description'] as String?,
      videoUrl: data['videoUrl'] as String?,
      hlsUrl: data['hlsUrl'] as String?,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      orderIndex: data['orderIndex'] as int,
      durationSeconds: data['durationSeconds'] as int? ?? 0,
      isPremium: data['isPremium'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'curriculumId': curriculumId,
      'title': title,
      'titleAr': titleAr,
      'description': description,
      'videoUrl': videoUrl,
      'hlsUrl': hlsUrl,
      'thumbnailUrl': thumbnailUrl,
      'orderIndex': orderIndex,
      'durationSeconds': durationSeconds,
      'isPremium': isPremium,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
