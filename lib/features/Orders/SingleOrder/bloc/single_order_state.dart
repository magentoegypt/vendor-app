import 'package:equatable/equatable.dart';
import '../../SingleOrder/data/OrderModel.dart';


abstract class SingleOrderState extends Equatable {}

class OrdersInitial extends SingleOrderState {
  @override
  List<Object?> get props => [];
}

class OrderLoading extends SingleOrderState {
  @override
  List<Object?> get props => [];
}

class SingleOrderLoaded extends SingleOrderState {
  final OrderModel orderModel;

  SingleOrderLoaded({
    required this.orderModel,
  });

  @override
  List<Object?> get props => [orderModel];
}

class OrderError extends SingleOrderState {
  final String errorMessage;
  OrderError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}