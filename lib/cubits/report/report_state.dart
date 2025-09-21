part of 'report_cubit.dart';

@immutable
abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportCreated extends ReportState {}

class ReportDeleted extends ReportState {}

class ReportUpdated extends ReportState {}

class ReportLoaded extends ReportState {
  final List<ReportModel> reports;
  ReportLoaded(this.reports);
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}
