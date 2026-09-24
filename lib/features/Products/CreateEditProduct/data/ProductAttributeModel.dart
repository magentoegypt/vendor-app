class ProductAttributeModel {
  int? attributeId;
  String? attributeCode;
  String? frontendInput;
  String? entityTypeId;
  bool? isRequired;
  List<Options>? options;
  bool? isUserDefined;
  String? defaultFrontendLabel;
  String? backendType;
  String? sourceModel;
  String? defaultValue;
  String? isUnique;
  dynamic value;
  var featuredImage;
  List<dynamic> galleryImages = [];

  ProductAttributeModel(
      {this.attributeId,
        this.attributeCode,
        this.frontendInput,
        this.entityTypeId,
        this.isRequired,
        this.options,
        this.isUserDefined,
        this.defaultFrontendLabel,
        this.backendType,
        this.sourceModel,
        this.defaultValue,
        this.isUnique
      });

  ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    attributeCode = json['attribute_code'];
    frontendInput = json['frontend_input'];
    entityTypeId = json['entity_type_id'];
    isRequired = json['is_required'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    isUserDefined = json['is_user_defined'];
    defaultFrontendLabel = json['default_frontend_label'];
    backendType = json['backend_type'];
    sourceModel = json['source_model'];
    defaultValue = json['default_value'];
    isUnique = json['is_unique'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_id'] = this.attributeId;
    data['attribute_code'] = this.attributeCode;
    data['frontend_input'] = this.frontendInput;
    data['entity_type_id'] = this.entityTypeId;
    data['is_required'] = this.isRequired;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['is_user_defined'] = this.isUserDefined;
    data['default_frontend_label'] = this.defaultFrontendLabel;
    data['backend_type'] = this.backendType;
    data['source_model'] = this.sourceModel;
    data['default_value'] = this.defaultValue;
    data['is_unique'] = this.isUnique;

    return data;
  }

  void updateImages(List<dynamic> images) {
    galleryImages = List.from(images);
  }
  void updateFeatureImage(image) {
    featuredImage = image;
  }
}

class Options {
  String? label;
  String? value;

  Options({this.label, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}