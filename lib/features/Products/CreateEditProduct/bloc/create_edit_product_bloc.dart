import 'dart:convert';

import 'package:bloc/bloc.dart';
import '../data/create_edit_product_repository.dart';
import 'create_edit_product_event.dart';
import 'create_edit_product_state.dart';




class CreateEditProductBloc extends Bloc<CreateEditProductEvent, CreateEditProductState> {
  CreateEditProductBloc({required this.repository}) : super(ProductsInitial()) {
    on<PerformProductAttributeList>(_onPerformProductAttribute);
    on<PerformProductAttributeSetList>(_onPerformProductAttributeSetList);
    on<PerformSaveProduct>(_onPerformSaveProduct);
    on<PerformSingleProduct>(_onPerformSingleProduct);
    on<PerformProductDeleteMedia>(_onPerformProductDeleteMedia);
    on<PerformProductCategories>(_onPerformProductCategories);
  }

  final CreateEditProductRepository repository;

  void _onPerformProductAttribute(PerformProductAttributeList event, emit) async {
    try {
      // emit the loading state
      emit(ProductsLoading());
      final productListModel = await repository.requestProductsAttribute(query: event.query);
      emit(ProductsAttributeLoaded(productAttributeModel: productListModel));
    } on Exception catch (e) {
      emit(ProductsError(errorMessage: e.toString()));
    }
  }

  void _onPerformProductAttributeSetList(PerformProductAttributeSetList event, emit) async {
    try {
      // emit the loading state
      emit(ProductsLoading());
      final productAttributeSetList = await repository.requestProductsAttributeSetList(query: event.query);
      emit(ProductsAttributeSetLoaded(productAttributeSetList: productAttributeSetList));
    } on Exception catch (e) {
      emit(ProductsError(errorMessage: e.toString()));
    }
  }

  void _onPerformSaveProduct(event, emit) async {
    try {
      // emit the loading state
      emit(ProductsLoading());
      final productListModel = await repository.requestSaveProduct(
        requestValueMap: event.requestValueMap,
        isUpdate: event.isUpdate
      );
      // emit RegisterLoaded State
      emit(SaveProductLoaded(productListModel: productListModel));
    } on Exception catch (e) {
      emit(ProductsError(errorMessage: e.toString()));
    }
  }

  void _onPerformSingleProduct(event, emit) async {
    try {
      // emit the loading state
      emit(ProductsLoading());
      final productItem = await repository.requestSingleProduct(
        productSku: event.productSku,
      );
      // emit RegisterLoaded State
      emit(SingleProductLoaded(productItem: productItem));
    } on Exception catch (e) {
      emit(ProductsError(errorMessage: e.toString()));
    }
  }

  void _onPerformProductDeleteMedia(event, emit) async {
    try {
      // emit the loading state
      final productItem = await repository.requestDeleteProductMedia(
        sku: event.sku,
        mediaGalleryEntry: event.mediaGalleryEntry
      );
      // emit RegisterLoaded State
    } on Exception catch (e) {
      emit(ProductsError(errorMessage: e.toString()));
    }
  }

  void _onPerformProductCategories(event, emit) async {
    try {
      final treeListData = await repository.requestProductCategories();
      emit(ProductCategoriesLoaded(treeListData: treeListData));
    } on Exception catch (e) {
      emit(ProductsError(errorMessage: e.toString()));
    }
  }
}
