import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../features/Orders/OrderList/data/orderListModel.dart';
import '../../../features/Orders/OrderList/data/orders_repository.dart';
import '../../../features/home/data/DashboarModel.dart';
import '../../../features/home/data/UserModel.dart';
import '../data/dashboard_repository.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DasboardEvent, DasboardState> {
  DashboardBloc({required this.repository,required this.ordersRepository}) : super(DashboardInitial()) {
    on<PerformDashboard>(_onPerformDashboardApi);
    on<PerformUserDetail>(_onPerformUserApi);
    on<PerformOrderList>(_onPerformOrderListApi);
  }

  final DashboardRepository repository;
  final OrdersRepository ordersRepository;

  void _onPerformDashboardApi(event, emit) async {
    try {
      // emit the loading state
      emit(DashboardLoading());
      final dashboarModel = await repository.requestDashboard();
      emit(DashboardLoaded(dashboarModel: dashboarModel));
    } on Exception catch (e) {
      emit(DashboardError(errorMessage: e.toString()));
    }
  }

  void _onPerformUserApi(event, emit) async {
    try {
      final userModel = await repository.requestUserDetail();
      emit(UserLoaded(userModel: userModel));
    } on Exception catch (e) {
      emit(DashboardError(errorMessage: e.toString()));
    }
  }

  void _onPerformOrderListApi(event, emit) async {
    try {
      final orderListModel = await ordersRepository.requestOrderList(query: event.query);
      emit(OrderLoaded(orderListModel: orderListModel));
    } on Exception catch (e) {
      emit(DashboardError(errorMessage: e.toString()));
    }
  }
}
