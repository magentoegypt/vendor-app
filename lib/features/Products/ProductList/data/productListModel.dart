import '../../../../core/utils/json_parser.dart';
import '../../CreateEditProduct/data/StockItemQunatityModel.dart';

class ProductListModel {
  List<ProductItem>? products;
  int? totalCount;

  ProductListModel({this.products, this.totalCount});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    products = JsonParser.toList(json['items'], ProductItem.fromJson);
    totalCount = JsonParser.toInt(json['total_count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['items'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['total_count'] = this.totalCount;
    return data;
  }
}

class ProductItem {
  num? qty;
  int? id;
  String? sku;
  String? name;
  int? attributeSetId;
  dynamic price;
  int? status;
  int? visibility;
  String? typeId;
  String? createdAt;
  String? updatedAt;
  num? weight;
  StockItemQunatityModel? stockItemQunatityModel;
  List<ProductLinks>? productLinks;
  List<CustomAttributes>? customAttributes;
  List<MediaGalleryEntries>? mediaGalleryEntries;
  String? thumbnailUrl;

  ProductItem(
      {this.qty,
        this.id,
        this.sku,
        this.name,
        this.attributeSetId,
        this.price,
        this.status,
        this.visibility,
        this.typeId,
        this.createdAt,
        this.updatedAt,
        this.weight,
        this.productLinks,
        this.customAttributes,
        this.thumbnailUrl});

  ProductItem.fromJson(Map<String, dynamic> json) {
    qty = JsonParser.toNum(json['qty']);
    id = JsonParser.toInt(json['id']);
    sku = JsonParser.toStr(json['sku']);
    name = JsonParser.toStr(json['name']);
    attributeSetId = JsonParser.toInt(json['attribute_set_id']);
    price = JsonParser.toNum(json['price']);
    status = JsonParser.toInt(json['status']);
    visibility = JsonParser.toInt(json['visibility']);
    typeId = JsonParser.toStr(json['type_id']);
    createdAt = JsonParser.toStr(json['created_at']);
    updatedAt = JsonParser.toStr(json['updated_at']);
    weight = JsonParser.toNum(json['weight']);
    productLinks = JsonParser.toList(json['product_links'], ProductLinks.fromJson);
    mediaGalleryEntries = JsonParser.toList(
        json['media_gallery_entries'], MediaGalleryEntries.fromJson);
    customAttributes =
        JsonParser.toList(json['custom_attributes'], CustomAttributes.fromJson);
    thumbnailUrl = JsonParser.toStr(json['thumbnail_url']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    data['id'] = this.id;
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['attribute_set_id'] = this.attributeSetId;
    data['price'] = this.price;
    data['status'] = this.status;
    data['visibility'] = this.visibility;
    data['type_id'] = this.typeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['weight'] = this.weight;
    if (this.productLinks != null) {
      data['product_links'] =
          this.productLinks!.map((v) => v.toJson()).toList();
    }
    if (this.customAttributes != null) {
      data['custom_attributes'] =
          this.customAttributes!.map((v) => v.toJson()).toList();
    }
    if (this.mediaGalleryEntries != null) {
      data['media_gallery_entries'] =
          this.mediaGalleryEntries!.map((v) => v.toJson()).toList();
    }
    data['thumbnail_url'] = this.thumbnailUrl;
    return data;
  }
}

class MediaGalleryEntries {
  int? id;
  String? mediaType;
  String? label;
  int? position;
  bool? disabled;
  List<String>? types;
  String? file;

  MediaGalleryEntries(
      {this.id,
        this.mediaType,
        this.label,
        this.position,
        this.disabled,
        this.types,
        this.file});

  MediaGalleryEntries.fromJson(Map<String, dynamic> json) {
    id = JsonParser.toInt(json['id']);
    mediaType = JsonParser.toStr(json['media_type']);
    label = JsonParser.toStr(json['label']);
    position = JsonParser.toInt(json['position']);
    disabled = JsonParser.toBool(json['disabled']);
    types = JsonParser.toStringList(json['types']);
    file = JsonParser.toStr(json['file']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['media_type'] = this.mediaType;
    data['label'] = this.label;
    data['position'] = this.position;
    data['disabled'] = this.disabled;
    data['types'] = this.types;
    data['file'] = this.file;
    return data;
  }
}

class ProductLinks {
  String? sku;
  String? linkType;
  String? linkedProductSku;
  String? linkedProductType;
  int? position;

  ProductLinks(
      {this.sku,
        this.linkType,
        this.linkedProductSku,
        this.linkedProductType,
        this.position});

  ProductLinks.fromJson(Map<String, dynamic> json) {
    sku = JsonParser.toStr(json['sku']);
    linkType = JsonParser.toStr(json['link_type']);
    linkedProductSku = JsonParser.toStr(json['linked_product_sku']);
    linkedProductType = JsonParser.toStr(json['linked_product_type']);
    position = JsonParser.toInt(json['position']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['link_type'] = this.linkType;
    data['linked_product_sku'] = this.linkedProductSku;
    data['linked_product_type'] = this.linkedProductType;
    data['position'] = this.position;
    return data;
  }
}

class CustomAttributes {
  String? attributeCode;
  dynamic value;

  CustomAttributes({this.attributeCode, this.value});

  CustomAttributes.fromJson(Map<String, dynamic> json) {
    attributeCode = JsonParser.toStr(json['attribute_code']);
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_code'] = this.attributeCode;
    data['value'] = this.value;
    return data;
  }
}

