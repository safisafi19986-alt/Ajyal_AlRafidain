import 'package:cloud_firestore/cloud_firestore.dart';

/// Student model stored in the 'students' collection.
/// Each student has a unique barcode/ID for parent linking.
class Student {
  final String id;
  final String userId;
  final String fullName;
  final String uniqueCode;
  final String? parentId;
  final int grade;
  final String? schoolName;
  final String? section;
  final String? avatarUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.uniqueCode,
    this.parentId,
    required this.grade,
    this.schoolName,
    this.section,
    this.avatarUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      userId: data['userId'] as String,
      fullName: data['fullName'] as String,
      uniqueCode: data['uniqueCode'] as String,
      parentId: data['parentId'] as String?,
      grade: data['grade'] as int,
      schoolName: data['schoolName'] as String?,
      section: data['section'] as String?,
      avatarUrl: data['avatarUrl'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fullName': fullName,
      'uniqueCode': uniqueCode,
      'parentId': parentId,
      'grade': grade,
      'schoolName': schoolName,
      'section': section,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Student copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? uniqueCode,
    String? parentId,
    int? grade,
    String? schoolName,
    String? section,
    String? avatarUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      uniqueCode: uniqueCode ?? this.uniqueCode,
      parentId: parentId ?? this.parentId,
      grade: grade ?? this.grade,
      schoolName: schoolName ?? this.schoolName,
      section: section ?? this.section,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
