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

class AdminShopDisabled extends AdminState {
  final String shopId;
  final bool isDisabled;
  AdminShopDisabled(this.shopId, this.isDisabled);
}

class AdminShopBlocked extends AdminState {
  final String shopId;
  final bool isBlocked;
  AdminShopBlocked(this.shopId, this.isBlocked);
}

class AdminShopDeleted extends AdminState {
  final String shopId;
  AdminShopDeleted(this.shopId);
}
