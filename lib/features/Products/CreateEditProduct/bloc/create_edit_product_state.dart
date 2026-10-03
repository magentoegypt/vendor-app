import 'package:equatable/equatable.dart';
import '../../ProductList/data/productListModel.dart';
import '../data/ProductAttributeModel.dart';
import '../data/ProductAttributeSetList.dart';
import '../data/product_translations.dart';


abstract class CreateEditProductState extends Equatable {}

class ProductsInitial extends CreateEditProductState {
  @override
  List<Object?> get props => [];
}

class ProductsLoading extends CreateEditProductState {
  @override
  List<Object?> get props => [];
}

class ProductsAttributeLoaded extends CreateEditProductState {
  final List<ProductAttributeModel> productAttributeModel;

  ProductsAttributeLoaded({
    required this.productAttributeModel,
  });

  @override
  List<Object?> get props => [productAttributeModel];
}

class ProductsAttributeSetLoaded extends CreateEditProductState {
  final List<ProductAttributeSetList> productAttributeSetList;

  ProductsAttributeSetLoaded({
    required this.productAttributeSetList,
  });

  @override
  List<Object?> get props => [productAttributeSetList];
}

class SaveProductLoaded extends CreateEditProductState {
  final ProductListModel productListModel;
  /// The store views' text sent after the product, and the text the server
  /// then had live: a change it does not show yet waits for the admin.
  final List<Map<String, dynamic>> translationsSent;
  final ProductTranslations? translationsReply;
  /// Why the store views' text was not saved, though the product was.
  final String? translationsError;

  SaveProductLoaded({
    required this.productListModel,
    this.translationsSent = const [],
    this.translationsReply,
    this.translationsError,
  });

  @override
  List<Object?> get props => [productListModel, translationsSent, translationsReply, translationsError];
}

class ProductTranslationsLoaded extends CreateEditProductState {
  /// Null when the server has no text per store view to give (no such API
  /// yet, or the call failed): the form edits one text per field, as before.
  final ProductTranslations? translations;

  ProductTranslationsLoaded({
    required this.translations,
  });

  @override
  List<Object?> get props => [translations];
}

class SingleProductLoaded extends CreateEditProductState {
  final ProductItem productItem;

  SingleProductLoaded({
    required this.productItem,
  });

  @override
  List<Object?> get props => [productItem];
}

class ProductCategoriesLoaded extends CreateEditProductState {
  final List<Map<String, dynamic>> treeListData;

  ProductCategoriesLoaded({
    required this.treeListData,
  });

  @override
  List<Object?> get props => [treeListData];
}

class ProductsError extends CreateEditProductState {
  final String errorMessage;
  ProductsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
