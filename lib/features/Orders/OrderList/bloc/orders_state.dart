import 'package:equatable/equatable.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orderListModel.dart';


abstract class OrdersState extends Equatable {}

class OrdersInitial extends OrdersState {
  @override
  List<Object?> get props => [];
}

class OrdersLoading extends OrdersState {
  @override
  List<Object?> get props => [];
}

class OrderLoaded extends OrdersState {
  final OrderListModel orderListModel;

  OrderLoaded({
    required this.orderListModel,
  });

  @override
  List<Object?> get props => [orderListModel];
}

class OrderError extends OrdersState {
  final String errorMessage;
  OrderError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}