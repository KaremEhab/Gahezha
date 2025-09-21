part of 'order_cubit.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;
  OrderLoaded(this.orders);
}

class OrderPlaced extends OrderState {
  final OrderModel order;
  OrderPlaced(this.order);
}

class MultiOrderPlaced extends OrderState {
  final List<OrderModel> orders;
  MultiOrderPlaced(this.orders);
}

class OrderStatusChanged extends OrderState {
  final OrderModel order;
  OrderStatusChanged(this.order);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

class OrderSuccess extends OrderState {
  final String message;
  OrderSuccess(this.message);
}

/// ---------------- SUCCESS STATES ----------------

class Last5PendingOrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  Last5PendingOrdersLoaded(this.orders);
}

class AllPendingOrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  AllPendingOrdersLoaded(this.orders);
}

class AcceptedOrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  AcceptedOrdersLoaded(this.orders);
}

class RejectedOrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  RejectedOrdersLoaded(this.orders);
}

class PreparingOrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  PreparingOrdersLoaded(this.orders);
}

class PickupOrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  PickupOrdersLoaded(this.orders);
}

class DeliveredOrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  DeliveredOrdersLoaded(this.orders);
}
