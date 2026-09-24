import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class PerformOrdersList extends OrdersEvent {
  final String query;
  const PerformOrdersList({
    required this.query,
  });
  @override
  List<Object> get props => [];
}