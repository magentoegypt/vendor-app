part of 'dashboard_bloc.dart';

@immutable
abstract class DasboardEvent extends Equatable {
  const DasboardEvent();

  @override
  List<Object> get props => [];
}

class PerformDashboard extends DasboardEvent {

  const PerformDashboard();

  @override
  List<Object> get props => [];
}

class PerformUserDetail extends DasboardEvent {

  const PerformUserDetail();
  @override
  List<Object> get props => [];
}

class PerformOrderList extends DasboardEvent {
  final String query;
  const PerformOrderList({
    required this.query,
  });
  @override
  List<Object> get props => [];
}