import 'dart:convert';

import 'package:bloc/bloc.dart';
import '../data/create_edit_product_repository.dart';
import '../data/product_translations.dart';
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
    on<PerformProductTranslations>(_onPerformProductTranslations);
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

  void _onPerformSaveProduct(PerformSaveProduct event, emit) async {
    try {
      // emit the loading state
      emit(ProductsLoading());
      final productListModel = await repository.requestSaveProduct(
        requestValueMap: event.requestValueMap,
        isUpdate: event.isUpdate
      );
      // The store views' text goes once the product is saved, under its SKU:
      // a new product has none before. The product stays saved if this fails.
      ProductTranslations? translationsReply;
      String? translationsError;
      if (event.translations.isNotEmpty) {
        final sku = productListModel.products?.firstOrNull?.sku ??
            event.requestValueMap['product']?['sku']?.toString() ?? '';
        try {
          translationsReply = await repository.requestSaveProductTranslations(
            productSku: sku,
            translations: event.translations,
          );
        } on Exception catch (e) {
          translationsError = e.toString();
        }
      }
      emit(SaveProductLoaded(
        productListModel: productListModel,
        translationsSent: event.translations,
        translationsReply: translationsReply,
        translationsError: translationsError,
      ));
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

  void _onPerformProductTranslations(PerformProductTranslations event, emit) async {
    try {
      final translations = await repository.requestProductTranslations(
        productSku: event.productSku,
      );
      emit(ProductTranslationsLoaded(translations: translations));
    } on Exception {
      // No translations API on the server yet, or the call failed: the form
      // edits one text per field, as before, rather than show an error.
      emit(ProductTranslationsLoaded(translations: null));
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
