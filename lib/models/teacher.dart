import 'package:cloud_firestore/cloud_firestore.dart';

/// Teacher model stored in the 'teachers' collection.
class Teacher {
  final String id;
  final String userId;
  final String fullName;
  final String? subject;
  final String? schoolName;
  final List<int> assignedGrades;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  Teacher({
    required this.id,
    required this.userId,
    required this.fullName,
    this.subject,
    this.schoolName,
    required this.assignedGrades,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Teacher.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Teacher(
      id: doc.id,
      userId: data['userId'] as String,
      fullName: data['fullName'] as String,
      subject: data['subject'] as String?,
      schoolName: data['schoolName'] as String?,
      assignedGrades: List<int>.from(data['assignedGrades'] ?? []),
      isVerified: data['isVerified'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fullName': fullName,
      'subject': subject,
      'schoolName': schoolName,
      'assignedGrades': assignedGrades,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Teacher copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? subject,
    String? schoolName,
    List<int>? assignedGrades,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Teacher(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      subject: subject ?? this.subject,
      schoolName: schoolName ?? this.schoolName,
      assignedGrades: assignedGrades ?? this.assignedGrades,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
