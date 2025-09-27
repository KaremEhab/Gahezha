part of 'report_cubit.dart';

@immutable
abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportCreated extends ReportState {}

class ReportDeleted extends ReportState {}

class ReportUpdated extends ReportState {}

class ReportSuccess extends ReportState {
  final String message;
  ReportSuccess(this.message);
}

class ReportFailure extends ReportState {
  final String error;
  ReportFailure(this.error);
}

class ReportLoaded extends ReportState {
  final List<ReportModel> reports;
  ReportLoaded(this.reports);
}

/// --------------------
/// CUSTOMERS STATES
/// --------------------
class AllCustomersLoaded extends ReportState {
  final List<UserModel> allCustomers;
  final List<UserModel> reportedCustomers;

  AllCustomersLoaded(this.allCustomers, this.reportedCustomers);
}

/// --------------------
/// SHOPS STATES
/// --------------------
class AllShopsLoaded extends ReportState {
  final List<ShopModel> allShops;
  final List<ShopModel> reportedShops;

  AllShopsLoaded(this.allShops, this.reportedShops);
}

class ReportsDataLoaded extends ReportState {
  final List<ReportModel> myReports;
  final List<ReportModel> reportsAboutMe;

  ReportsDataLoaded({required this.myReports, required this.reportsAboutMe});
}

class ReportsAboutMeLoaded extends ReportState {
  final List<ReportModel> reports;
  ReportsAboutMeLoaded(this.reports);
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}

class ReportActionSuccess extends ReportState {
  final String message;
  ReportActionSuccess(this.message);
}
