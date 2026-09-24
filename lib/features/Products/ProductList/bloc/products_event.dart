
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class PerformProductList extends ProductsEvent {
  final String query;
  const PerformProductList({
    required this.query,
  });
  @override
  List<Object> get props => [];
}