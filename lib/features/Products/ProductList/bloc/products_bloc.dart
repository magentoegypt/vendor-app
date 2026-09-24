import 'dart:convert';

import 'package:bloc/bloc.dart';
import '../../../../features/Products/ProductList/bloc/products_event.dart';
import '../../../../features/Products/ProductList/bloc/products_state.dart';
import '../data/products_repository.dart';




class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({required this.repository}) : super(ProductsInitial()) {
    on<PerformProductList>(_onPerformProductList);
  }

  final ProductsRepository repository;

  void _onPerformProductList(PerformProductList event, emit) async {
    try {
      // emit the loading state
      emit(ProductsLoading());
      final productListModel = await repository.requestProducts(query: event.query);
      emit(ProductsLoaded(productListModel: productListModel));
    } on Exception catch (e) {
      emit(ProductsError(errorMessage: e.toString()));
    }
  }
}
