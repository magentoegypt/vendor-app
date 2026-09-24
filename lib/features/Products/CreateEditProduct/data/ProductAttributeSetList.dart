class ProductAttributeSetList {

  String? attributeSetName;
  int? attributeSetId;


  ProductAttributeSetList({this.attributeSetName, this.attributeSetId});

  ProductAttributeSetList.fromJson(Map<String, dynamic> json) {

    attributeSetName = json['attribute_set_name'];
    attributeSetId = json['attribute_set_id'];
  }

}