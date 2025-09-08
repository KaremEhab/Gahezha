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

class ShopError extends ShopState {
  final String message;
  ShopError(this.message);
}
