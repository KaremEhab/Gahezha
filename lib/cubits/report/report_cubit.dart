import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:meta/meta.dart';

import '../../models/report_model.dart';
import '../../models/user_model.dart';
import '../../models/shop_model.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit._privateConstructor() : super(ReportInitial());

  static final ReportCubit _instance = ReportCubit._privateConstructor();
  factory ReportCubit() => _instance;
  static ReportCubit get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Local cache
  List<ReportModel> _reports = [];

  List<ReportModel> get reports => _reports;

  Future<String> _generateReportId() async {
    final reportId = await _firestore.runTransaction((transaction) async {
      final counterRef = _firestore.collection('app_counters').doc('reports');
      final snapshot = await transaction.get(counterRef);

      int current = 10000; // default starting number
      if (snapshot.exists && snapshot.data()?['lastReportNumber'] != null) {
        current = snapshot.data()!['lastReportNumber'] + 1;
      }

      transaction.set(counterRef, {'lastReportNumber': current});

      return '#$current';
    });

    return reportId;
  }

  // --- CREATE REPORT ---
  Future<void> createReport({
  required String reportType,
  required String reportDescription,
  required String reporterId,
  required String reporterName,
  required String reporterType, // 'customer' | 'shop' | 'admin'
  required dynamic assignedItem, // ShopModel / UserModel / Map
}) async {
  emit(ReportLoading());

  try {
    String assignedName = '';
    String assignedImage = '';
    String reportingId = '';

    if (assignedItem is ShopModel) {
      assignedName = assignedItem.shopName;
      assignedImage = assignedItem.shopLogo;
      reportingId = assignedItem.id;
    } else if (assignedItem is UserModel) {
      assignedName = assignedItem.fullName ?? '';
      assignedImage = assignedItem.profileUrl ?? '';
      reportingId = assignedItem.userId ?? '';
    } else if (assignedItem is Map<String, dynamic>) {
      assignedName = assignedItem['name'];
      assignedImage = assignedItem['image'];
      reportingId = assignedItem['id'];
    }

    final reportId = await _generateReportId();

    final newReport = ReportModel(
      id: reportId,
      reportType: reportType,
      reportDescription: reportDescription,
      reporter: ReportUser(id: reporterId, name: reporterName),
      reporting: ReportUser(id: reportingId, name: assignedName),
      status: ReportStatusType.pending,
      reportRespond: '',
      createdAt: DateTime.now(),
    );

    // ---- حدد مكان التخزين حسب نوع المستخدم ----
    if (reporterType == 'admin') {
      await _firestore.collection('reports').doc(reportId).set(newReport.toMap());
    } else if (reporterType == 'customer') {
      await _firestore
          .collection('users')
          .doc(reporterId)
          .collection('reports')
          .doc(reportId)
          .set(newReport.toMap());
    } else if (reporterType == 'shop') {
      await _firestore
          .collection('shops')
          .doc(reporterId)
          .collection('reports')
          .doc(reportId)
          .set(newReport.toMap());
    }

    _reports.insert(0, newReport);

    emit(ReportCreated());
    emit(ReportLoaded(_reports));
  } catch (e, st) {
    print('Report creation failed: $e\n$st');
    emit(ReportError(e.toString()));
  }
}

  // --- GET ALL REPORTS ---
  Future<void> getAllReports({required String userId, required String userType}) async {
  emit(ReportLoading());

  try {
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (userType == 'admin') {
      snapshot = await _firestore.collection('reports').get();
    } else if (userType == 'customer') {
      snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('reports')
          .get();
    } else if (userType == 'shop') {
      snapshot = await _firestore
          .collection('shops')
          .doc(userId)
          .collection('reports')
          .get();
    } else {
      throw Exception('Unknown user type');
    }

    _reports = snapshot.docs.map((doc) => ReportModel.fromMap(doc.data())).toList();

    emit(ReportLoaded(_reports));
  } catch (e) {
    emit(ReportError(e.toString()));
  }
}

  // --- GET REPORTS BY REPORT ID ---
  Future<void> getReportsById(String id, {bool isShop = false}) async {
    emit(ReportLoading());

    try {
      final collection = isShop ? 'shops' : 'users';
      final snapshot = await _firestore
          .collection(collection)
          .doc(id)
          .collection('reports')
          .get();
      _reports = snapshot.docs
          .map((doc) => ReportModel.fromMap(doc.data()))
          .toList();
      emit(ReportLoaded(_reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  // --- DELETE REPORT ---
  Future<void> deleteReport(
    String reportId, {
    bool isAdminReport = true,
    String? parentId,
    bool isShop = false,
  }) async {
    emit(ReportLoading());

    try {
      if (isAdminReport) {
        await _firestore.collection('reports').doc(reportId).delete();
      } else {
        if (parentId == null) {
          throw Exception('Parent ID required for non-admin reports');
        }

        final collection = isShop ? 'shops' : 'users';
        await _firestore
            .collection(collection)
            .doc(parentId)
            .collection('reports')
            .doc(reportId)
            .delete();
      }

      // Remove from local list
      _reports.removeWhere((r) => r.id == reportId);

      emit(ReportDeleted());
      emit(ReportLoaded(_reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  // --- GET REPORTS BY STATUS ---
  Future<void> getReportsByStatus(ReportStatusType status) async {
    emit(ReportLoading());

    try {
      final snapshot = await _firestore
          .collection('reports')
          .where('status', isEqualTo: status.index)
          .get();
      _reports = snapshot.docs
          .map((doc) => ReportModel.fromMap(doc.data()))
          .toList();
      emit(ReportLoaded(_reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  // --- UPDATE REPORT ---
  Future<void> updateReport({
    required String reportId,
    String? reportType,
    String? reportDescription,
    dynamic assignedItem, // ShopModel / UserModel / Map
  }) async {
    emit(ReportLoading());

    try {
      // Prepare fields to update
      Map<String, dynamic> updateData = {};
      if (reportType != null) updateData['reportType'] = reportType;
      if (reportDescription != null) {
        updateData['reportDescription'] = reportDescription;
      }

      String? reportingId;
      String? assignedName;
      String? assignedImage;

      if (assignedItem != null) {
        if (assignedItem is ShopModel) {
          assignedName = assignedItem.shopName;
          assignedImage = assignedItem.shopLogo;
          reportingId = assignedItem.id;
        } else if (assignedItem is UserModel) {
          assignedName = assignedItem.fullName ?? '';
          assignedImage = assignedItem.profileUrl ?? '';
          reportingId = assignedItem.userId ?? '';
        } else if (assignedItem is Map<String, dynamic>) {
          assignedName = assignedItem['name'];
          assignedImage = assignedItem['image'];
          reportingId = assignedItem['id'];
        }

        updateData['reporting'] = {
          'id': reportingId,
          'name': assignedName,
          'image': assignedImage,
        };
      }

      // Update Firestore
      await _firestore.collection('reports').doc(reportId).update(updateData);

      // Update local list
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        final report = _reports[index];
        _reports[index] = report.copyWith(
          reportType: reportType ?? report.reportType,
          reportDescription: reportDescription ?? report.reportDescription,
          reporting: reportingId != null
              ? ReportUser(id: reportingId, name: assignedName!)
              : report.reporting,
        );
      }

      emit(ReportUpdated());
      emit(ReportLoaded(_reports));
    } catch (e, st) {
      print('Report update failed: $e\n$st');
      emit(ReportError(e.toString()));
    }
  }

  /// --- CLEAR ALL REPORTS (local + Firestore) ---
  Future<void> clearReports() async {
    emit(ReportLoading());

    try {
      if (currentUserType == UserType.admin) {
        // Delete all admin reports
        final snapshot = await _firestore.collection('reports').get();
        for (var doc in snapshot.docs) {
          await _firestore.collection('reports').doc(doc.id).delete();
        }
      } else {
        // Delete reports for a specific shop/user
        if (uId == null) {
          throw Exception('Parent ID required for non-admin reports');
        }
        final collection = currentUserType == UserType.shop ? 'shops' : 'users';
        final snapshot = await _firestore
            .collection(collection)
            .doc(uId)
            .collection('reports')
            .get();

        for (var doc in snapshot.docs) {
          await _firestore
              .collection(collection)
              .doc(uId)
              .collection('reports')
              .doc(doc.id)
              .delete();
        }
      }

      // Clear local list
      _reports.clear();
      emit(ReportDeleted());
      emit(ReportLoaded(_reports));
    } catch (e) {
      print('Clear reports failed: $e');
      emit(ReportError(e.toString()));
    }
  }
}
