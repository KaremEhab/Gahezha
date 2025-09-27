import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
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

  List<UserModel> allCustomers = [];
  List<UserModel> reportedCustomers = [];

  List<ShopModel> allShops = [];
  List<ShopModel> reportedShops = [];

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

  List<ReportModel> allReports = [];
  List<ReportModel> myReports = [];
  List<ReportModel> reportsAboutMe = [];

  /// --------------------
  /// CREATE REPORT
  /// --------------------
  Future<void> createReport({
    required String reportType,
    required String reportDescription,
    required String reporterId,
    required String reporterName,
    required String reporterType, // 👈 use this to check admin
    required String reportingType,
    required dynamic assignedItem, // ShopModel / UserModel / Map
  }) async {
    emit(ReportLoading());

    try {
      // Assign name/id depending on type
      String assignedId = '';
      String assignedName = '';

      if (assignedItem is Map<String, dynamic>) {
        assignedId = assignedItem['id'];
        assignedName = assignedItem['name'];
      } else if (assignedItem.runtimeType.toString().contains("ShopModel")) {
        assignedId = assignedItem.id;
        assignedName = assignedItem.shopName;
      } else {
        assignedId = assignedItem.userId ?? '';
        assignedName = assignedItem.fullName ?? '';
      }

      // Generate custom report ID
      final reportId = await _generateReportId();

      // Firestore docRef
      final docRef = _firestore.collection('reports').doc(reportId);

      final report = ReportModel(
        id: reportId,
        reportType: reportType,
        reportDescription: reportDescription,
        reporter: ReportUser(
          id: reporterId,
          name: reporterName,
          userType: reporterType,
        ),
        reporting: ReportUser(
          id: assignedId,
          name: assignedName,
          userType: reportingType,
        ),
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await docRef.set(report.toMap());

      // ✅ Update reporting account in Firestore
      if (reportingType == "customer") {
        final userDoc = _firestore.collection("users").doc(assignedId);
        await _firestore.runTransaction((txn) async {
          final snap = await txn.get(userDoc);
          if (snap.exists) {
            final currentCount = snap.data()?['reportedCount'] ?? 0;
            txn.update(userDoc, {
              'reportedCount': currentCount + 1,
              'reported': true,
            });
          }
        });
      } else if (reportingType == "shop") {
        final shopDoc = _firestore.collection("shops").doc(assignedId);
        await _firestore.runTransaction((txn) async {
          final snap = await txn.get(shopDoc);
          if (snap.exists) {
            final currentCount = snap.data()?['reportedCount'] ?? 0;
            txn.update(shopDoc, {
              'reportedCount': currentCount + 1,
              'reported': true,
            });
          }
        });
      }

      // ✅ Update local list (depends on role)
      if (reporterType == "admin") {
        allReports.insert(0, report);
      } else {
        myReports.insert(0, report);
      }

      // ✅ Emit success
      emit(ReportActionSuccess("Report submitted successfully"));

      // ✅ Emit updated reports
      emit(
        ReportsDataLoaded(
          myReports: currentUserType == UserType.admin ? allReports : myReports,
          reportsAboutMe: reportsAboutMe,
        ),
      );
    } catch (e) {
      emit(ReportFailure("Failed to create report: $e"));
    }
  }

  /// --------------------
  /// UPDATE REPORT (status/respond)
  /// --------------------
  Future<void> updateReport({
    required String reportId,
    ReportStatusType? status,
    String? respond,
    String? reportType,
    dynamic assignedItem, // ShopModel / UserModel / Map
  }) async {
    emit(ReportLoading());

    try {
      final updateData = <String, dynamic>{};

      if (status != null) updateData['status'] = status.index;
      if (respond != null) updateData['reportRespond'] = respond;
      if (reportType != null) updateData['reportType'] = reportType;

      if (assignedItem != null) {
        String assignedId = '';
        String assignedName = '';

        if (assignedItem is Map<String, dynamic>) {
          assignedId = assignedItem['id'];
          assignedName = assignedItem['name'];
        } else if (assignedItem.runtimeType.toString().contains("ShopModel")) {
          assignedId = assignedItem.id;
          assignedName = assignedItem.shopName;
        } else {
          assignedId = assignedItem.userId ?? '';
          assignedName = assignedItem.fullName ?? '';
        }

        updateData['reporting'] = {
          'id': assignedId,
          'name': assignedName,
          'userType': updateData['reporting']?['userType'] ?? 'customer',
        };
      }

      await _firestore.collection('reports').doc(reportId).update(updateData);

      // ✅ Update locally (depends on role)
      List<ReportModel> targetList = currentUserType == UserType.admin
          ? allReports
          : myReports;

      final index = targetList.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        final oldReport = targetList[index];
        final updatedReport = oldReport.copyWith(
          status: status ?? oldReport.status,
          reportRespond: respond ?? oldReport.reportRespond,
          reportType: reportType ?? oldReport.reportType,
          reporting: assignedItem != null
              ? ReportUser(
                  id: updateData['reporting']['id'],
                  name: updateData['reporting']['name'],
                  userType: updateData['reporting']['userType'],
                )
              : oldReport.reporting,
        );
        targetList[index] = updatedReport;
      }

      emit(ReportSuccess("Report updated successfully"));
      emit(
        ReportsDataLoaded(
          myReports: currentUserType == UserType.admin ? allReports : myReports,
          reportsAboutMe: reportsAboutMe,
        ),
      );
    } catch (e) {
      emit(ReportFailure("Failed to update report: $e"));
    }
  }

  /// --------------------
  /// DELETE REPORT
  /// --------------------
  Future<void> deleteReport(String reportId) async {
    emit(ReportLoading());
    try {
      await _firestore.collection('reports').doc(reportId).delete();
      emit(ReportSuccess("Report deleted successfully"));
    } catch (e) {
      emit(ReportFailure("Failed to delete report: $e"));
    }
  }

  /// --------------------
  /// PROCESS CUSTOMER REPORTS
  /// --------------------
  void processCustomerReports(List<ReportModel> reports) {
    reportedCustomers.clear();

    final Map<String, int> reportsCountMap = {};
    for (var report in reports) {
      final reportingId = report.reporting.id;
      reportsCountMap[reportingId] = (reportsCountMap[reportingId] ?? 0) + 1;
    }

    for (var user in UserCubit.instance.allCustomers) {
      if (reportsCountMap.containsKey(user.userId)) {
        user.reported = true;
        user.reportedCount = reportsCountMap[user.userId]!;
        reportedCustomers.add(user);
      } else {
        user.reported = false;
        user.reportedCount = 0;
      }
    }

    // ✅ Actually notify Bloc listeners
    UserCubit.instance.updateReportedCustomers(reportedCustomers);
  }

  /// --------------------
  /// PROCESS SHOP REPORTS
  /// --------------------
  void processShopReports(List<ReportModel> allReports) {
    final shopCubit = ShopCubit.instance;

    for (final shop in shopCubit.allShops) {
      final reportsForShop = allReports
          .where((r) => r.reporting.id == shop.id)
          .toList();

      shop.reported = reportsForShop.isNotEmpty;
      shop.reportedCount = reportsForShop.length;
    }

    // ✅ Update reportedShops list inside ShopCubit
    shopCubit.reportedShops = shopCubit.allShops
        .where((s) => s.reported)
        .toList();

    // ✅ Actually notify Bloc listeners
    ShopCubit.instance.updateReportedShops(reportedShops);
  }

  /// --------------------
  /// GET ALL REPORTS (Admin only)
  /// --------------------
  Future<void> getAllReports() async {
    emit(ReportLoading());
    try {
      final snapshot = await _firestore
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .get();

      allReports = snapshot.docs
          .map((doc) => ReportModel.fromMap(doc.data()))
          .toList();

      emit(
        ReportsDataLoaded(
          myReports: allReports,
          reportsAboutMe: reportsAboutMe,
        ),
      );
    } catch (e) {
      emit(ReportFailure("Failed to fetch reports: $e"));
    }
  }

  /// --------------------
  /// GET MY REPORTS (reports I created)
  /// --------------------
  Future<void> getMyReports(String myUserId) async {
    emit(ReportLoading());
    final snapshot = await _firestore
        .collection('reports')
        .where('reporter.id', isEqualTo: myUserId)
        .orderBy('createdAt', descending: true)
        .get();

    myReports = snapshot.docs
        .map((doc) => ReportModel.fromMap(doc.data()))
        .toList();

    emit(
      ReportsDataLoaded(myReports: myReports, reportsAboutMe: reportsAboutMe),
    );
  }

  /// --------------------
  /// GET REPORTS ABOUT ME
  /// --------------------
  Future<void> getReportsAboutMe(String myUserId) async {
    emit(ReportLoading());
    final snapshot = await _firestore
        .collection('reports')
        .where('reporting.id', isEqualTo: myUserId)
        .orderBy('createdAt', descending: true)
        .get();

    reportsAboutMe = snapshot.docs
        .map((doc) => ReportModel.fromMap(doc.data()))
        .toList();

    emit(
      ReportsDataLoaded(myReports: myReports, reportsAboutMe: reportsAboutMe),
    );
  }

  //   // --- CREATE REPORT ---
  //   Future<void> createReport({
  //   required String reportType,
  //   required String reportDescription,
  //   required String reporterId,
  //   required String reporterName,
  //   required String reporterType, // 'customer' | 'shop' | 'admin'
  //   required dynamic assignedItem, // ShopModel / UserModel / Map
  // }) async {
  //   emit(ReportLoading());
  //
  //   try {
  //     String assignedName = '';
  //     String assignedImage = '';
  //     String reportingId = '';
  //
  //     if (assignedItem is ShopModel) {
  //       assignedName = assignedItem.shopName;
  //       assignedImage = assignedItem.shopLogo;
  //       reportingId = assignedItem.id;
  //     } else if (assignedItem is UserModel) {
  //       assignedName = assignedItem.fullName ?? '';
  //       assignedImage = assignedItem.profileUrl ?? '';
  //       reportingId = assignedItem.userId ?? '';
  //     } else if (assignedItem is Map<String, dynamic>) {
  //       assignedName = assignedItem['name'];
  //       assignedImage = assignedItem['image'];
  //       reportingId = assignedItem['id'];
  //     }
  //
  //     final reportId = await _generateReportId();
  //
  //     final newReport = ReportModel(
  //       id: reportId,
  //       reportType: reportType,
  //       reportDescription: reportDescription,
  //       reporter: ReportUser(id: reporterId, name: reporterName),
  //       reporting: ReportUser(id: reportingId, name: assignedName),
  //       status: ReportStatusType.pending,
  //       reportRespond: '',
  //       createdAt: DateTime.now(),
  //     );
  //
  //     // ---- حدد مكان التخزين حسب نوع المستخدم ----
  //     if (reporterType == 'admin') {
  //       await _firestore.collection('reports').doc(reportId).set(newReport.toMap());
  //     } else if (reporterType == 'customer') {
  //       await _firestore
  //           .collection('users')
  //           .doc(reporterId)
  //           .collection('reports')
  //           .doc(reportId)
  //           .set(newReport.toMap());
  //     } else if (reporterType == 'shop') {
  //       await _firestore
  //           .collection('shops')
  //           .doc(reporterId)
  //           .collection('reports')
  //           .doc(reportId)
  //           .set(newReport.toMap());
  //     }
  //
  //     _reports.insert(0, newReport);
  //
  //     emit(ReportCreated());
  //     emit(ReportLoaded(_reports));
  //   } catch (e, st) {
  //     print('Report creation failed: $e\n$st');
  //     emit(ReportError(e.toString()));
  //   }
  // }
  //
  //   // --- GET ALL REPORTS ---
  //   Future<void> getAllReports({required String userId, required String userType}) async {
  //   emit(ReportLoading());
  //
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> snapshot;
  //
  //     if (userType == 'admin') {
  //       snapshot = await _firestore.collection('reports').get();
  //     } else if (userType == 'customer') {
  //       snapshot = await _firestore
  //           .collection('users')
  //           .doc(userId)
  //           .collection('reports')
  //           .get();
  //     } else if (userType == 'shop') {
  //       snapshot = await _firestore
  //           .collection('shops')
  //           .doc(userId)
  //           .collection('reports')
  //           .get();
  //     } else {
  //       throw Exception('Unknown user type');
  //     }
  //
  //     _reports = snapshot.docs.map((doc) => ReportModel.fromMap(doc.data())).toList();
  //
  //     emit(ReportLoaded(_reports));
  //   } catch (e) {
  //     emit(ReportError(e.toString()));
  //   }
  // }

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

  // // --- DELETE REPORT ---
  // Future<void> deleteReport(
  //   String reportId, {
  //   bool isAdminReport = true,
  //   String? parentId,
  //   bool isShop = false,
  // }) async {
  //   emit(ReportLoading());
  //
  //   try {
  //     if (isAdminReport) {
  //       await _firestore.collection('reports').doc(reportId).delete();
  //     } else {
  //       if (parentId == null) {
  //         throw Exception('Parent ID required for non-admin reports');
  //       }
  //
  //       final collection = isShop ? 'shops' : 'users';
  //       await _firestore
  //           .collection(collection)
  //           .doc(parentId)
  //           .collection('reports')
  //           .doc(reportId)
  //           .delete();
  //     }
  //
  //     // Remove from local list
  //     _reports.removeWhere((r) => r.id == reportId);
  //
  //     emit(ReportDeleted());
  //     emit(ReportLoaded(_reports));
  //   } catch (e) {
  //     emit(ReportError(e.toString()));
  //   }
  // }

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

  // // --- UPDATE REPORT ---
  // Future<void> updateReport({
  //   required String reportId,
  //   String? reportType,
  //   String? reportDescription,
  //   dynamic assignedItem, // ShopModel / UserModel / Map
  // }) async {
  //   emit(ReportLoading());
  //
  //   try {
  //     // Prepare fields to update
  //     Map<String, dynamic> updateData = {};
  //     if (reportType != null) updateData['reportType'] = reportType;
  //     if (reportDescription != null) {
  //       updateData['reportDescription'] = reportDescription;
  //     }
  //
  //     String? reportingId;
  //     String? assignedName;
  //     String? assignedImage;
  //
  //     if (assignedItem != null) {
  //       if (assignedItem is ShopModel) {
  //         assignedName = assignedItem.shopName;
  //         assignedImage = assignedItem.shopLogo;
  //         reportingId = assignedItem.id;
  //       } else if (assignedItem is UserModel) {
  //         assignedName = assignedItem.fullName ?? '';
  //         assignedImage = assignedItem.profileUrl ?? '';
  //         reportingId = assignedItem.userId ?? '';
  //       } else if (assignedItem is Map<String, dynamic>) {
  //         assignedName = assignedItem['name'];
  //         assignedImage = assignedItem['image'];
  //         reportingId = assignedItem['id'];
  //       }
  //
  //       updateData['reporting'] = {
  //         'id': reportingId,
  //         'name': assignedName,
  //         'image': assignedImage,
  //       };
  //     }
  //
  //     // Update Firestore
  //     await _firestore.collection('reports').doc(reportId).update(updateData);
  //
  //     // Update local list
  //     final index = _reports.indexWhere((r) => r.id == reportId);
  //     if (index != -1) {
  //       final report = _reports[index];
  //       _reports[index] = report.copyWith(
  //         reportType: reportType ?? report.reportType,
  //         reportDescription: reportDescription ?? report.reportDescription,
  //         reporting: reportingId != null
  //             ? ReportUser(id: reportingId, name: assignedName!)
  //             : report.reporting,
  //       );
  //     }
  //
  //     emit(ReportUpdated());
  //     emit(ReportLoaded(_reports));
  //   } catch (e, st) {
  //     print('Report update failed: $e\n$st');
  //     emit(ReportError(e.toString()));
  //   }
  // }

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
