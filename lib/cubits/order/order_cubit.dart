import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/cart/cart_cubit.dart';
import 'package:gahezha/cubits/notifications/notifications_cubit.dart';
import 'package:gahezha/models/cart_model.dart';
import 'package:gahezha/models/notification_model.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/home/shop/shop_home.dart';
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit._privateConstructor() : super(OrderInitial());

  static final OrderCubit _instance = OrderCubit._privateConstructor();

  factory OrderCubit() => _instance;

  static OrderCubit get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int activeOrders = 0;

  StreamSubscription? pickupOrdersSub;

  // 🔥 Maintain all lists separately
  List<OrderModel> last5PickupOrders = [];
  List<OrderModel> allPendingOrders = [];
  List<OrderModel> acceptedOrders = [];
  List<OrderModel> rejectedOrders = [];
  List<OrderModel> preparingOrders = [];
  List<OrderModel> pickupOrders = [];
  List<OrderModel> deliveredOrders = [];

  // Streams cleanup
  final List<StreamSubscription> _subscriptions = [];

  /// --------------------
  /// GENERATE UNIQUE ORDER ID LIKE #10303
  /// --------------------
  Future<String> generateOrderId() async {
    final counterRef = _firestore.collection('app_counters').doc('orders');

    final snapshot = await counterRef.get();
    int lastNumber = snapshot.exists ? snapshot['lastOrderNumber'] : 9999;

    await counterRef.set({
      'lastOrderNumber': FieldValue.increment(1),
    }, SetOptions(merge: true));

    return '#${lastNumber + 1}';
  }

  /// --------------------
  /// PLACE SINGLE ORDER WITH MULTIPLE SHOPS
  /// --------------------
  Future<void> placeOrderWithShops({
    required List<CartShop> shops,
    required UserModel customerInfo,
  }) async {
    if (shops.isEmpty) {
      emit(OrderError('No shops selected'));
      return;
    }

    emit(OrderLoading());

    try {
      // Atomic transaction to generate unique order ID
      final orderId = await _firestore.runTransaction((transaction) async {
        final counterRef = _firestore.collection('app_counters').doc('orders');
        final snapshot = await transaction.get(counterRef);

        int current = 10000; // default starting number
        if (snapshot.exists && snapshot.data()?['lastOrderNumber'] != null) {
          current = snapshot.data()!['lastOrderNumber'] + 1;
        }

        transaction.set(counterRef, {'lastOrderNumber': current});
        return '#$current';
      });

      final startDate = DateTime.now();

      final List<Map<String, dynamic>> shopsData = shops.map((shop) {
        final shopItems = shop.orders.map((cartItem) {
          return OrderItem(
            name: cartItem.name,
            price: cartItem.totalPrice.toStringAsFixed(2),
            extras: cartItem.extras,
          ).toMap();
        }).toList();

        return {
          'shopId': shop.shopId,
          'statusIndex': OrderStatus.pending.index,
          'shopName': shop.shopName,
          'shopLogo': shop.shopLogo,
          'shopPhone': shop.shopPhone,
          'endDate': Timestamp.fromDate(
            DateTime.now().add(Duration(minutes: shop.preparingTimeTo)),
          ),
          'shopTotalPrice': shop.totalPrice.toStringAsFixed(2),
          'items': shopItems,
          'preparingTimeFrom': shop.preparingTimeFrom,
          'preparingTimeTo': shop.preparingTimeTo,
        };
      }).toList();

      final double totalPrice = shops.fold(
        0,
        (sum, shop) => sum + shop.totalPrice,
      );

      final List<String> shopIds = shops.map((shop) => shop.shopId).toList();

      final orderData = {
        'id': orderId,
        'startDate': Timestamp.fromDate(startDate),
        'shops': shopsData,
        'shopIds': shopIds,
        'totalPrice': totalPrice.toStringAsFixed(2),
        'customerId': customerInfo.userId ?? '',
        'customerFullName': customerInfo.fullName ?? '',
        'customerProfileUrl': customerInfo.profileUrl ?? '',
        'customerPhone': customerInfo.phoneNumber ?? '',
      };

      final orderModel = OrderModel.fromMap(orderData);

      // Save order in Firestore
      await _firestore.collection('orders').doc(orderId).set(orderData);

      // Prepare receivers for notification
      final receivers = shops.map((shop) {
        return SenderReceiver(
          id: shop.shopId,
          name: shop.shopName,
          profile: shop.shopLogo,
        );
      }).toList();

      // Send notification to all shops
      await NotificationCubit.instance.sendNotification(
        receivers: receivers,
        isShop: true,
        sender: SenderReceiver(
          id: customerInfo.userId ?? '',
          name: customerInfo.fullName ?? '',
          profile: customerInfo.profileUrl ?? '',
        ),
        label: "New Order Received",
        content: "You have received a new order ${orderModel.id}",
        notificationType: NotificationType.newOrder,
        payload: {
          "type": NotificationType.newOrder.name,
          "order": orderModel.toMap(),
        }, // send the order as payload
      );

      emit(OrderPlaced(orderModel));
      CartCubit.instance.clearCart();
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  /// --------------------
  /// CHANGE ORDER STATUS
  /// --------------------
  Future<void> changeOrderStatus(
    OrderModel orderModel,
    OrderStatus status,
    SenderReceiver receiver,
  ) async {
    try {
      final orderRef = _firestore.collection('orders').doc(orderModel.id);
      final snapshot = await orderRef.get();

      if (!snapshot.exists) throw Exception("Order not found");

      final currentOrder = OrderModel.fromMap(snapshot.data()!);

      // Update only the current shop inside the order
      final updatedShops = currentOrder.shops.map((shop) {
        if (shop.shopId == uId) {
          DateTime newEndDate = shop.endDate;

          if (status == OrderStatus.accepted &&
              currentShopModel?.preparingTimeTo != null) {
            // Add preparing time to current endDate
            newEndDate = shop.endDate.add(
              Duration(minutes: currentShopModel!.preparingTimeTo),
            );
          } else if (status == OrderStatus.pickup) {
            // When order is picked up, endDate = now
            newEndDate = DateTime.now();
          }

          return OrderShop(
            shopId: shop.shopId,
            status: status,
            shopName: shop.shopName,
            shopLogo: shop.shopLogo,
            shopPhone: shop.shopPhone,
            endDate: newEndDate,
            preparingTimeFrom: currentShopModel!.preparingTimeFrom,
            preparingTimeTo: currentShopModel!.preparingTimeTo,
            items: shop.items,
            shopTotalPrice: shop.shopTotalPrice,
          );
        }
        return shop;
      }).toList();

      // Push updated shops back to Firestore
      await orderRef.update({
        'shops': updatedShops.map((s) => s.toMap()).toList(),
      });

      final updatedSnapshot = await orderRef.get();
      final updatedOrder = OrderModel.fromMap(updatedSnapshot.data()!);

      // Send notification to all shops
      await NotificationCubit.instance.sendNotification(
        receivers: [receiver],
        isShop: false,
        sender: SenderReceiver(
          id: uId ?? '',
          name: currentShopModel!.shopName ?? '',
          profile: currentShopModel!.shopLogo ?? '',
        ),
        label: "Order ${orderModel.id} is now ${status.name}",
        content: "Click the notification to view the order",
        notificationType: NotificationType.orderStatus,
        payload: {
          "type": NotificationType.orderStatus.name,
          "order": orderModel.toMap(),
        }, // send the order as payload
      );

      emit(OrderStatusChanged(updatedOrder));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  /// --------------------
  /// GET ALL ORDERS BY CUSTOMER STREAM
  /// --------------------
  StreamSubscription getOrdersByCustomerStream() {
    emit(OrderLoading());
    return _firestore
        .collection('orders')
        .where('customerId', isEqualTo: uId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data()))
              .toList();
          emit(OrderLoaded(orders));
        }, onError: (e) => emit(OrderError(e.toString())));
  }

  /// --------------------
  /// GET ORDERS STREAM
  /// --------------------
  StreamSubscription getOrdersStream() {
    emit(OrderLoading());
    return _firestore.collection('orders').snapshots().listen((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .toList();
      emit(OrderLoaded(orders.reversed.toList()));
    }, onError: (e) => emit(OrderError(e.toString())));
  }

  /// --------------------
  /// GET LAST 10 ORDERS STREAM
  /// --------------------
  void getLastTenOrdersStream() {
    emit(OrderLoading());

    _firestore
        .collection('orders')
        .orderBy('startDate', descending: true) // newest first
        .limit(10) // only last 10 orders
        .snapshots()
        .listen(
          (snapshot) {
            final orders = snapshot.docs
                .map((doc) => OrderModel.fromMap(doc.data()))
                .toList();
            emit(OrderLoaded(orders));
          },
          onError: (e) {
            emit(OrderError(e.toString()));
          },
        );
  }

  /// --------------------
  /// GET ORDERS STREAM BY USER ID
  /// --------------------
  void getOrdersStreamByUserId(String userId) {
    emit(OrderLoading());
    _firestore
        .collection('orders')
        .where('customerId', isEqualTo: userId) // 🔑 filter by userId field
        .snapshots()
        .listen(
          (snapshot) {
            final orders = snapshot.docs
                .map((doc) => OrderModel.fromMap(doc.data()))
                .toList();
            emit(OrderLoaded(orders.reversed.toList())); // latest first
          },
          onError: (e) {
            emit(OrderError(e.toString()));
          },
        );
  }

  /// --------------------
  /// GET PICKUP ORDERS STREAM
  /// --------------------
  void getPickupOrdersStream(String userId) {
    emit(OrderLoading());
    activeOrders = 0;

    pickupOrdersSub = _firestore
        .collection('orders')
        .where('customerId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
          final allOrders = snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data()))
              .toList();

          final pickupOrders = allOrders.where((order) {
            return order.shops.any((shop) => shop.status == OrderStatus.pickup);
          }).toList();

          activeOrders = pickupOrders.length;
          emit(OrderLoaded(pickupOrders.reversed.toList()));
        }, onError: (e) => emit(OrderError(e.toString())));
  }

  /// --------------------
  /// GET LAST 5 PENDING ORDERS STREAM
  /// --------------------
  void getLast5PickupOrdersStream(String shopId) {
    emit(OrderLoading());
    print('🔍 [getLast5PickupOrdersStream] Looking for shopId: $shopId');

    final sub = _firestore
        .collection('orders')
        .where('shopIds', arrayContains: shopId) // keep this to narrow orders
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            print('📥 [Firestore] Orders fetched: ${snapshot.docs.length}');

            // Map Firestore docs → OrderModel
            final allOrders = snapshot.docs.map((d) {
              final data = d.data();
              print('➡️ OrderId: ${data['id']} | shopIds: ${data['shopIds']}');
              return OrderModel.fromMap(data);
            }).toList();

            // Filter orders where this shop has status pending
            final pendingOrders = allOrders.where((order) {
              return order.shops.any(
                (shop) =>
                    shop.shopId == shopId && shop.status == OrderStatus.pickup,
              );
            }).toList();

            // Take only first 5
            last5PickupOrders = pendingOrders.take(5).toList();

            print('✅ [Filtered Orders] Count: ${last5PickupOrders.length}');
            for (var order in last5PickupOrders) {
              print(
                '   • Order ${order.id} | Shops: ${order.shops.map((s) => "${s.shopId}:${s.status}")}',
              );
            }

            emit(OrderLoaded(last5PickupOrders));
          },
          onError: (e) {
            print('❌ Error in getLast5PickupOrdersStream: $e');
            emit(OrderError(e.toString()));
          },
        );

    _subscriptions.add(sub);
  }

  /// --------------------
  /// GET ALL PENDING ORDERS STREAM
  /// --------------------
  void getAllPendingOrdersStream(String shopId) {
    print('🔍 [getAllPendingOrdersStream] Looking for shopId: $shopId');

    final sub = _firestore
        .collection('orders')
        .where('shopIds', arrayContains: shopId) // keep this to narrow orders
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            print('📥 [Firestore] Orders fetched: ${snapshot.docs.length}');

            // Map Firestore docs → OrderModel
            final allOrders = snapshot.docs.map((d) {
              final data = d.data();
              print('➡️ OrderId: ${data['id']} | shopIds: ${data['shopIds']}');
              return OrderModel.fromMap(data);
            }).toList();

            // Filter orders where this shop has status pending
            allPendingOrders = allOrders.where((order) {
              return order.shops.any(
                (shop) =>
                    shop.shopId == shopId && shop.status == OrderStatus.pending,
              );
            }).toList();

            print('✅ [Filtered Orders] Count: ${allPendingOrders.length}');
            for (var order in allPendingOrders) {
              print(
                '   • Order ${order.id} | Shops: ${order.shops.map((s) => "${s.shopId}:${s.status}")}',
              );
            }

            emit(OrderLoaded(allPendingOrders));
          },
          onError: (e) {
            print('❌ Error in getAllPendingOrdersStream: $e');
            emit(OrderError(e.toString()));
          },
        );

    _subscriptions.add(sub);
  }

  /// --------------------
  /// GET ACCEPTED ORDERS STREAM
  /// --------------------
  void getAcceptedOrdersStream(String shopId) {
    final sub = _firestore
        .collection('orders')
        .where('shopIds', arrayContains: shopId) // keep this to narrow orders
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          // Map Firestore docs → OrderModel
          final allOrders = snapshot.docs
              .map((d) => OrderModel.fromMap(d.data()))
              .toList();

          // Filter orders where this shop has status accepted
          acceptedOrders = allOrders.where((order) {
            return order.shops.any(
              (shop) =>
                  shop.shopId == shopId && shop.status == OrderStatus.accepted,
            );
          }).toList();

          emit(OrderLoaded(acceptedOrders));
        });

    _subscriptions.add(sub);
  }

  /// --------------------
  /// GET REJECTED ORDERS STREAM
  /// --------------------
  void getRejectedOrdersStream(String shopId) {
    final sub = _firestore
        .collection('orders')
        .where('shopIds', arrayContains: shopId) // keep this to narrow orders
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          // Map Firestore docs → OrderModel
          final allOrders = snapshot.docs
              .map((d) => OrderModel.fromMap(d.data()))
              .toList();

          // Filter orders where this shop has status rejected
          rejectedOrders = allOrders.where((order) {
            return order.shops.any(
              (shop) =>
                  shop.shopId == shopId && shop.status == OrderStatus.rejected,
            );
          }).toList();

          emit(OrderLoaded(rejectedOrders));
        });

    _subscriptions.add(sub);
  }

  /// --------------------
  /// GET PREPARING ORDERS STREAM
  /// --------------------
  void getPreparingOrdersStream(String shopId) {
    final sub = _firestore
        .collection('orders')
        .where('shopIds', arrayContains: shopId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          preparingOrders = snapshot.docs
              .map((d) => OrderModel.fromMap(d.data()))
              .where(
                (order) => order.shops.any(
                  (shop) =>
                      shop.shopId == shopId &&
                      shop.status == OrderStatus.preparing,
                ),
              )
              .toList();

          emit(OrderLoaded(preparingOrders));
        });

    _subscriptions.add(sub);
  }

  /// --------------------
  /// GET PICKUP ORDERS STREAM
  /// --------------------
  void getShopPickupOrdersStream(String shopId) {
    final sub = _firestore
        .collection('orders')
        .where('shopIds', arrayContains: shopId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          pickupOrders = snapshot.docs
              .map((d) => OrderModel.fromMap(d.data()))
              .where(
                (order) => order.shops.any(
                  (shop) =>
                      shop.shopId == shopId &&
                      shop.status == OrderStatus.pickup,
                ),
              )
              .toList();

          emit(OrderLoaded(pickupOrders));
        });

    _subscriptions.add(sub);
  }

  /// --------------------
  /// GET DELIVERED ORDERS STREAM
  /// --------------------
  void getDeliveredOrdersStream(String shopId) {
    final sub = _firestore
        .collection('orders')
        .where('shopIds', arrayContains: shopId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          deliveredOrders = snapshot.docs
              .map((d) => OrderModel.fromMap(d.data()))
              .where(
                (order) => order.shops.any(
                  (shop) =>
                      shop.shopId == shopId &&
                      shop.status == OrderStatus.delivered,
                ),
              )
              .toList();

          emit(OrderLoaded(deliveredOrders));
        });

    _subscriptions.add(sub);
  }

  /// --------------------
  /// DISPOSE ALL STREAMS
  /// --------------------
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }

  /// --------------------
  /// DELETE ORDER
  /// --------------------
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      emit(OrderSuccess("Order deleted successfully"));
    } catch (e) {
      emit(OrderError("Failed to delete order: $e"));
    }
  }
}
