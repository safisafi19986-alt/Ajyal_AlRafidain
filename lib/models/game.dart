import 'package:cloud_firestore/cloud_firestore.dart';

/// Game model stored in the 'games' collection.
class Game {
  final String id;
  final String title;
  final String titleAr;
  final String? description;
  final String? thumbnailUrl;
  final String gameType;
  final int? relatedGrade;
  final String? relatedSubject;
  final bool isPremium;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Game({
    required this.id,
    required this.title,
    required this.titleAr,
    this.description,
    this.thumbnailUrl,
    required this.gameType,
    this.relatedGrade,
    this.relatedSubject,
    this.isPremium = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Game.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Game(
      id: doc.id,
      title: data['title'] as String,
      titleAr: data['titleAr'] as String,
      description: data['description'] as String?,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      gameType: data['gameType'] as String,
      relatedGrade: data['relatedGrade'] as int?,
      relatedSubject: data['relatedSubject'] as String?,
      isPremium: data['isPremium'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'titleAr': titleAr,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'gameType': gameType,
      'relatedGrade': relatedGrade,
      'relatedSubject': relatedSubject,
      'isPremium': isPremium,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
