import 'package:equatable/equatable.dart';
import '../data/productListModel.dart';


abstract class ProductsState extends Equatable {}

class ProductsInitial extends ProductsState {
  @override
  List<Object?> get props => [];
}

class ProductsLoading extends ProductsState {
  @override
  List<Object?> get props => [];
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
