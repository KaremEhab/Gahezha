import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';

enum ReportStatusType { pending, resolved, dismissed }

class ReportUser {
  final String id;
  final String name;
  final String userType;

  ReportUser({required this.id, required this.name, required this.userType});

  factory ReportUser.fromMap(Map<String, dynamic> map) => ReportUser(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    userType: map['userType'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'userType': userType,
  };

  ReportUser copyWith({String? id, String? name, String? userType}) {
    return ReportUser(
      id: id ?? this.id,
      name: name ?? this.name,
      userType: userType ?? this.userType,
    );
  }
}

class ReportModel {
  final String id;
  final String reportType;
  final String reportDescription;
  final ReportUser reporter;
  final ReportUser reporting;
  final ReportStatusType status;
  final String? reportRespond;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.reportType,
    required this.reportDescription,
    required this.reporter,
    required this.reporting,
    this.status = ReportStatusType.pending,
    this.reportRespond,
    required this.createdAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) => ReportModel(
    id: map['id'] ?? '',
    reportType: map['reportType'] ?? '',
    reportDescription: map['reportDescription'] ?? '',
    reporter: ReportUser.fromMap(map['reporter'] ?? {}),
    reporting: ReportUser.fromMap(map['reporting'] ?? {}),
    status: ReportStatusType.values[map['status'] ?? 0],
    reportRespond: map['reportRespond'],
    createdAt: map['createdAt'] != null
        ? (map['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'reportType': reportType,
    'reportDescription': reportDescription,
    'reporter': reporter.toMap(),
    'reporting': reporting.toMap(),
    'status': status.index,
    'reportRespond': reportRespond,
    'createdAt': createdAt,
  };

  ReportModel copyWith({
    String? id,
    String? reportType,
    String? reportDescription,
    ReportUser? reporter,
    ReportUser? reporting,
    ReportStatusType? status,
    String? reportRespond,
    DateTime? createdAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      reportType: reportType ?? this.reportType,
      reportDescription: reportDescription ?? this.reportDescription,
      reporter: reporter ?? this.reporter,
      reporting: reporting ?? this.reporting,
      status: status ?? this.status,
      reportRespond: reportRespond ?? this.reportRespond,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static String getLocalizedReportStatus(
    BuildContext context,
    ReportStatusType reportStatus,
  ) {
    switch (reportStatus) {
      case ReportStatusType.resolved:
        return S.of(context).resolved;
      case ReportStatusType.dismissed:
        return S.of(context).dismissed;
      default:
        return S.of(context).pending;
    }
  }
}
