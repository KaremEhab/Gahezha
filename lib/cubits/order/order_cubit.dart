import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit._privateConstructor() : super(OrderInitial());

  static final OrderCubit _instance = OrderCubit._privateConstructor();

  factory OrderCubit() => _instance;

  static OrderCubit get instance => _instance;
}
