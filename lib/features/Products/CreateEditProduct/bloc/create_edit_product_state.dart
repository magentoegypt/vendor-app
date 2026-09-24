import 'package:equatable/equatable.dart';
import '../../ProductList/data/productListModel.dart';
import '../data/ProductAttributeModel.dart';
import '../data/ProductAttributeSetList.dart';


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

  SaveProductLoaded({
    required this.productListModel,
  });

  @override
  List<Object?> get props => [productListModel];
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
