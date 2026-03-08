import 'package:cloud_firestore/cloud_firestore.dart';

/// NotificationModel stored in the 'notifications' collection.
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String titleAr;
  final String body;
  final String bodyAr;
  final String type;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.titleAr,
    required this.body,
    required this.bodyAr,
    required this.type,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final docData = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: docData['userId'] as String,
      title: docData['title'] as String,
      titleAr: docData['titleAr'] as String,
      body: docData['body'] as String,
      bodyAr: docData['bodyAr'] as String,
      type: docData['type'] as String,
      data: docData['data'] as Map<String, dynamic>?,
      isRead: docData['isRead'] as bool? ?? false,
      createdAt: (docData['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'titleAr': titleAr,
      'body': body,
      'bodyAr': bodyAr,
      'type': type,
      'data': data,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
