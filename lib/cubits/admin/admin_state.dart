import 'package:gahezha/models/user_model.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final UserModel admin;
  AdminLoaded(this.admin);
}

class AdminsLoaded extends AdminState {
  final List<UserModel> admins;
  AdminsLoaded(this.admins);
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}
