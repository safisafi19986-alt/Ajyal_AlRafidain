import 'package:cloud_firestore/cloud_firestore.dart';

/// StudentGame model stored in the 'student_games' collection.
/// Tracks a student's game play history and scores.
class StudentGame {
  final String id;
  final String studentId;
  final String gameId;
  final int highScore;
  final int totalPlays;
  final int totalTimePlayed;
  final DateTime lastPlayedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentGame({
    required this.id,
    required this.studentId,
    required this.gameId,
    this.highScore = 0,
    this.totalPlays = 0,
    this.totalTimePlayed = 0,
    required this.lastPlayedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentGame.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentGame(
      id: doc.id,
      studentId: data['studentId'] as String,
      gameId: data['gameId'] as String,
      highScore: data['highScore'] as int? ?? 0,
      totalPlays: data['totalPlays'] as int? ?? 0,
      totalTimePlayed: data['totalTimePlayed'] as int? ?? 0,
      lastPlayedAt: (data['lastPlayedAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'gameId': gameId,
      'highScore': highScore,
      'totalPlays': totalPlays,
      'totalTimePlayed': totalTimePlayed,
      'lastPlayedAt': Timestamp.fromDate(lastPlayedAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
