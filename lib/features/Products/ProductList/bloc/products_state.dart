import 'package:equatable/equatable.dart';
import '../data/productListModel.dart';


abstract class ProductsState extends Equatable {}

class ProductsInitial extends ProductsState {
  @override
  List<Object?> get props => [];
}

class ProductsLoading extends ProductsState {
  // Which load this is. A state equal to the current one is not emitted, so
  // Products opened again while an older load still ran showed no spinner.
  final int load;

  ProductsLoading({this.load = 0});

  @override
  List<Object?> get props => [load];
}

class ProductsLoaded extends ProductsState {
  final ProductListModel productListModel;

  ProductsLoaded({
    required this.productListModel,
  });

  @override
  List<Object?> get props => [productListModel];
}

class ProductsError extends ProductsState {
  final String errorMessage;
  ProductsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
