import 'package:flutter/material.dart';

enum IssueType {
  missingItem,
  wrongProduct,
  damaged,
  quantityIssue,
  paymentIssue,
  lateDelivery,
  other
}

enum ResolutionPreference {
  replacement,
  refundToOriginal,
  storeCredit,
  callMe
}

enum TicketStatus {
  raised,
  underReview,
  approved,
  rejected,
  refundInitiated,
  resolved
}

class TicketModel {
  final String id;
  final String orderId;
  final DateTime dateCreated;
  final TicketStatus status;
  final IssueType issueType;
  final List<String> affectedItemIds;
  final String description;
  final List<String> evidencePhotos;
  final ResolutionPreference resolutionPreference;
  final double? estimatedRefundAmount;
  final DateTime? estimatedResolutionTime;

  TicketModel({
    required this.id,
    required this.orderId,
    required this.dateCreated,
    required this.status,
    required this.issueType,
    required this.affectedItemIds,
    required this.description,
    this.evidencePhotos = const [],
    required this.resolutionPreference,
    this.estimatedRefundAmount,
    this.estimatedResolutionTime,
  });

  static List<TicketModel> sampleTickets = [
    TicketModel(
      id: '#FRU892312',
      orderId: '#ORD-2024-1925',
      dateCreated: DateTime.now().subtract(const Duration(hours: 2)),
      status: TicketStatus.underReview,
      issueType: IssueType.damaged,
      affectedItemIds: ['Pomegranate'],
      description: 'The pomegranate was crushed inside the box.',
      resolutionPreference: ResolutionPreference.refundToOriginal,
      estimatedResolutionTime: DateTime.now().add(const Duration(hours: 4)),
    ),
    TicketModel(
      id: '#FRU891100',
      orderId: '#ORD-2024-1847',
      dateCreated: DateTime.now().subtract(const Duration(days: 2)),
      status: TicketStatus.resolved,
      issueType: IssueType.missingItem,
      affectedItemIds: ['Apple'],
      description: 'Missing 1kg Apple from the delivery.',
      resolutionPreference: ResolutionPreference.storeCredit,
      estimatedRefundAmount: 3.99,
    ),
  ];
}

class IssueTypeData {
  final IssueType type;
  final String title;
  final IconData icon;
  final Color color;

  IssueTypeData(this.type, this.title, this.icon, this.color);
}
