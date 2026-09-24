import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SingleOrderEvent extends Equatable {
  const SingleOrderEvent();

  @override
  List<Object> get props => [];
}

class PerformSingleOrder extends SingleOrderEvent {
  final String orderId;
  const PerformSingleOrder({
    required this.orderId,
  });
  @override
  List<Object> get props => [];
}