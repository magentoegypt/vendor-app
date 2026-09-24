

import 'package:bloc/bloc.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orders_repository.dart';
import 'orders_event.dart';
import 'orders_state.dart';


class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({required this.ordersRepository}) : super(OrdersInitial()) {
    on<PerformOrdersList>(_onPerformOrderListApi);
  }
  final OrdersRepository ordersRepository;

  void _onPerformOrderListApi(event, emit) async {
    try {
      emit(OrdersLoading());
      final orderListModel = await ordersRepository.requestOrderList(query: event.query);
      emit(OrderLoaded(orderListModel: orderListModel));
    } on Exception catch (e) {
      emit(OrderError(errorMessage: e.toString()));
    }
  }
}

