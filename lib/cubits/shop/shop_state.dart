part of 'shop_cubit.dart';

abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final ShopModel shop;
  ShopLoaded(this.shop);
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
