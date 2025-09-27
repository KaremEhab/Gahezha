part of 'shop_cubit.dart';

abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final ShopModel shop;
  ShopLoaded(this.shop);
}

class ShopStateAllShopsLoaded extends ShopState {
  final List<ShopModel> allCustomers;
  final List<ShopModel> reportedCustomers;
  ShopStateAllShopsLoaded(this.allCustomers, this.reportedCustomers);
}

class ShopsLoaded extends ShopState {
  final List<ShopModel> shops;
  ShopsLoaded(this.shops);
}

class PendingShopsLoaded extends ShopState {
  final List<ShopModel> shops;
  PendingShopsLoaded(this.shops);
}

class AcceptedShopsLoaded extends ShopState {
  final List<ShopModel> shops;
  AcceptedShopsLoaded(this.shops);
}

class RejectedShopsLoaded extends ShopState {
  final List<ShopModel> shops;
  RejectedShopsLoaded(this.shops);
}

class AllShopsLoaded extends ShopState {
  final List<ShopModel> shops;
  AllShopsLoaded(this.shops);
}

class DealerShopsLoaded extends ShopState {
  final List<ShopModel> shops;
  DealerShopsLoaded(this.shops);
}

class ShopError extends ShopState {
  final String message;
  ShopError(this.message);
}

class ShopDisabled extends ShopState {
  final String shopId;
  ShopDisabled(this.shopId);
}

class ShopBlocked extends ShopState {
  final String shopId;
  ShopBlocked(this.shopId);
}

class ShopDeleted extends ShopState {
  final String shopId;
  ShopDeleted(this.shopId);
}
