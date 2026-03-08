import 'package:cloud_firestore/cloud_firestore.dart';

/// Parent model stored in the 'parents' collection.
/// A parent can link to multiple student profiles via their phone number.
class ParentModel {
  final String id;
  final String userId;
  final String phoneNumber;
  final String fullName;
  final List<String> linkedStudentIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParentModel({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.fullName,
    required this.linkedStudentIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParentModel(
      id: doc.id,
      userId: data['userId'] as String,
      phoneNumber: data['phoneNumber'] as String,
      fullName: data['fullName'] as String,
      linkedStudentIds: List<String>.from(data['linkedStudentIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'linkedStudentIds': linkedStudentIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ParentModel copyWith({
    String? id,
    String? userId,
    String? phoneNumber,
    String? fullName,
    List<String>? linkedStudentIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ParentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      linkedStudentIds: linkedStudentIds ?? this.linkedStudentIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
