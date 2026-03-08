import 'package:cloud_firestore/cloud_firestore.dart';

/// Subscription model stored in the 'subscriptions' collection.
class Subscription {
  final String id;
  final String userId;
  final String planType;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final double amount;
  final String currency;
  final String? paymentMethod;
  final String? transactionId;
  final bool autoRenew;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.planType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.amount,
    this.currency = 'IQD',
    this.paymentMethod,
    this.transactionId,
    this.autoRenew = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Subscription(
      id: doc.id,
      userId: data['userId'] as String,
      planType: data['planType'] as String,
      status: data['status'] as String,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      amount: (data['amount'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'IQD',
      paymentMethod: data['paymentMethod'] as String?,
      transactionId: data['transactionId'] as String?,
      autoRenew: data['autoRenew'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'planType': planType,
      'status': status,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'autoRenew': autoRenew,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
