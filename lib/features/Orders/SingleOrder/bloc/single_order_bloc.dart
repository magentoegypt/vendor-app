
import 'package:bloc/bloc.dart';
import 'package:multi_vendor/features/Orders/SingleOrder/bloc/single_order_event.dart';
import 'package:multi_vendor/features/Orders/SingleOrder/bloc/single_order_state.dart';
import '../data/single_order_repository.dart';

class SingleOrderBloc extends Bloc<SingleOrderEvent, SingleOrderState> {
  SingleOrderBloc({required this.orderRepository}) : super(OrdersInitial()) {
    on<PerformSingleOrder>(_onPerformSingleOrderApi);
  }
  final SingleOrderRepository orderRepository;

  void _onPerformSingleOrderApi(event, emit) async {
    try {
      emit(OrderLoading());
      final orderModel = await orderRepository.requestSingleOrder(orderId: event.orderId);
      emit(SingleOrderLoaded(orderModel: orderModel));
    } on Exception catch (e) {
      emit(OrderError(errorMessage: e.toString()));
    }
  }
}

