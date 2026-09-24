import '../../CreateEditProduct/data/StockItemQunatityModel.dart';

class ProductListModel {
  List<ProductItem>? products;
  int? totalCount;

  ProductListModel({this.products, this.totalCount});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      products = <ProductItem>[];
      json['items'].forEach((v) {
        products!.add(new ProductItem.fromJson(v));
      });
    }
    totalCount = json['total_count'];
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
  int? qty;
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
  int? weight;
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
    qty = json['qty'];
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    attributeSetId = json['attribute_set_id'];
    price = json['price'];
    status = json['status'];
    visibility = json['visibility'];
    typeId = json['type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    weight = json['weight'];
    if (json['product_links'] != null) {
      productLinks = <ProductLinks>[];
      json['product_links'].forEach((v) {
        productLinks!.add(new ProductLinks.fromJson(v));
      });
    }
    if (json['media_gallery_entries'] != null) {
      mediaGalleryEntries = <MediaGalleryEntries>[];
      json['media_gallery_entries'].forEach((v) {
        mediaGalleryEntries!.add(new MediaGalleryEntries.fromJson(v));
      });
    }

    if (json['custom_attributes'] != null) {
      customAttributes = <CustomAttributes>[];
      json['custom_attributes'].forEach((v) {
        customAttributes!.add(new CustomAttributes.fromJson(v));
      });
    }
    thumbnailUrl = json['thumbnail_url'];
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
    id = json['id'];
    mediaType = json['media_type'];
    label = json['label'];
    position = json['position'];
    disabled = json['disabled'];
    types = json['types'].cast<String>();
    file = json['file'];
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
    sku = json['sku'];
    linkType = json['link_type'];
    linkedProductSku = json['linked_product_sku'];
    linkedProductType = json['linked_product_type'];
    position = json['position'];
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
    attributeCode = json['attribute_code'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_code'] = this.attributeCode;
    data['value'] = this.value;
    return data;
  }
}

