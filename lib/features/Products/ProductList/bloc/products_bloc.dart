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

  // Loads run side by side and this bloc outlives the list screen, so an older
  // load can end after a newer one: backing out of a slow load and opening
  // Products again showed the old load's "no internet" over the new list.
  // Only the newest load may change the screen.
  int _latestLoad = 0;

  void _onPerformProductList(PerformProductList event, emit) async {
    final load = ++_latestLoad;
    try {
      // emit the loading state
      emit(ProductsLoading(load: load));
      final productListModel = await repository.requestProducts(query: event.query);
      if (load == _latestLoad) emit(ProductsLoaded(productListModel: productListModel));
    } on Exception catch (e) {
      if (load == _latestLoad) emit(ProductsError(errorMessage: e.toString()));
    }
  }
}
