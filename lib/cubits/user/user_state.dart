import 'package:gahezha/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

class UsersLoaded extends UserState {
  final List<UserModel> users;
  UsersLoaded(this.users);
}

class UserStateAllCustomersLoaded extends UserState {
  final List<UserModel> allCustomers;
  final List<UserModel> reportedCustomers;
  UserStateAllCustomersLoaded(this.allCustomers, this.reportedCustomers);
}

class GuestLoaded extends UserState {
  final GuestUserModel guest;
  GuestLoaded(this.guest);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserUpdating extends UserState {}

class UserUpdated extends UserState {
  final UserModel user;
  UserUpdated(this.user);
}

class UserUpdatingError extends UserState {
  final String message;
  UserUpdatingError(this.message);
}
