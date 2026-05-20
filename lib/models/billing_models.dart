import 'package:flutter/material.dart';

enum TransactionType { payment, refund, subscription, walletCredit, walletDebit }
enum TransactionStatus { success, pending, failed }

class TransactionModel {
  final String id;
  final DateTime date;
  final double amount;
  final TransactionType type;
  final String paymentMethod;
  final TransactionStatus status;
  final String description;

  TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.paymentMethod,
    required this.status,
    required this.description,
  });

  bool get isCredit => type == TransactionType.refund || type == TransactionType.walletCredit;
}

enum RefundStatus { initiated, processing, completed }

class RefundModel {
  final String id;
  final String orderId;
  final double amount;
  final RefundStatus status;
  final DateTime dateInitiated;
  final DateTime? expectedCreditDate;
  final String originalPaymentMethod;
  final String refundMode;
  final List<RefundTimelineItem> timeline;

  RefundModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.dateInitiated,
    this.expectedCreditDate,
    required this.originalPaymentMethod,
    required this.refundMode,
    required this.timeline,
  });
}

class RefundTimelineItem {
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;

  RefundTimelineItem({
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
  });
}

class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String period; // month, year
  final List<String> benefits;
  final bool isRecommended;
  final Color color;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.benefits,
    this.isRecommended = false,
    required this.color,
  });
}

class InvoiceModel {
  final String id;
  final String orderId;
  final DateTime date;
  final double totalAmount;
  final double gstAmount;
  final double deliveryCharge;
  final double discount;
  final List<InvoiceItem> items;

  InvoiceModel({
    required this.id,
    required this.orderId,
    required this.date,
    required this.totalAmount,
    required this.gstAmount,
    required this.deliveryCharge,
    required this.discount,
    required this.items,
  });
}

class InvoiceItem {
  final String name;
  final int quantity;
  final double price;
  final double total;

  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
  });
}
