part of 'dashboard_bloc.dart';

abstract class DasboardState extends Equatable {}

class DashboardInitial extends DasboardState {
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DasboardState {
  @override
  List<Object?> get props => [];
}

class DashboardLoaded extends DasboardState {
  final DashboarModel dashboarModel;

  DashboardLoaded({
    required this.dashboarModel,
  });

  @override
  List<Object?> get props => [dashboarModel];
}

class UserLoaded extends DasboardState {
  final UserModel userModel;

  UserLoaded({
    required this.userModel,
  });

  @override
  List<Object?> get props => [userModel];
}

class OrderLoaded extends DasboardState {
  final OrderListModel orderListModel;

  OrderLoaded({
    required this.orderListModel,
  });

  @override
  List<Object?> get props => [orderListModel];
}

class DashboardError extends DasboardState {
  final String errorMessage;
  DashboardError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
