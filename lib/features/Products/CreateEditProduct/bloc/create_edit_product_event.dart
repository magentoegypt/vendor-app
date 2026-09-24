
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../ProductList/data/productListModel.dart';

@immutable
abstract class CreateEditProductEvent extends Equatable {
  const CreateEditProductEvent();
  @override
  List<Object> get props => [];
}

class PerformProductAttributeList extends CreateEditProductEvent {
  final String query;
  const PerformProductAttributeList({
    required this.query,
  });
  @override
  List<Object> get props => [];
}

class PerformProductAttributeSetList extends CreateEditProductEvent {
  final String query;
  const PerformProductAttributeSetList({
    required this.query,
  });
  @override
  List<Object> get props => [];
}

class PerformSaveProduct extends CreateEditProductEvent {
  final Map<String, dynamic> requestValueMap;
  final bool isUpdate;
  const PerformSaveProduct({
    required this.requestValueMap,
    required  this.isUpdate,
  });
  @override
  List<Object> get props => [requestValueMap];
}

class PerformSingleProduct extends CreateEditProductEvent {
  final String productSku;
  const PerformSingleProduct({
    required this.productSku,
  });
  @override
  List<Object> get props => [];
}

class PerformProductCategories extends CreateEditProductEvent {

  const PerformProductCategories();
  @override
  List<Object> get props => [];
}

class PerformProductDeleteMedia extends CreateEditProductEvent {

  final String sku;
  final MediaGalleryEntries mediaGalleryEntry;
  const PerformProductDeleteMedia({
    required this.sku,
    required this.mediaGalleryEntry,
  });
  @override
  List<Object> get props => [];
}