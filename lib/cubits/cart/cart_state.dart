part of 'cart_cubit.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartItemIncrementedLoading extends CartState {}

class CartItemDecrementedLoading extends CartState {}

class CartItemIncremented extends CartState {}

class CartItemDecremented extends CartState {}

class CartLoaded extends CartState {
  final List<CartShop> cartShops;
  final double totalCart; // new field

  CartLoaded(this.cartShops, {required this.totalCart});
}

class CartError extends CartState {
  final String error;

  CartError(this.error);
}
