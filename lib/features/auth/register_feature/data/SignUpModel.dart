class SignUpModel {
  Customer? customer;
  String? password;
  String? redirectUrl;

  SignUpModel({this.customer, this.password, this.redirectUrl});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
    password = json['password'];
    redirectUrl = json['redirectUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['password'] = this.password;
    data['redirectUrl'] = this.redirectUrl;
    return data;
  }
}

class Customer {
  int? id;
  int? groupId;
  String? vendor_id;
  int? status;
  String? defaultBilling;
  String? defaultShipping;
  String? confirmation;
  String? createdAt;
  String? updatedAt;
  String? createdIn;
  String? dob;
  String? email;
  String? firstname;
  String? lastname;
  String? middlename;
  String? prefix;
  String? suffix;
  int? gender;
  int? storeId;
  String? taxvat;
  String? password;
  int? websiteId;

  String? street;
  String? city;
  String? region;
  String? company;
  String? telephone;
  String? postcode;
  String? country_id;
  List<Address>? addresses;
  int? disableAutoGroupChange;
  ExtensionAttributes? extensionAttributes;
  List<CustomAttributes>? customAttributes;

  Customer({this.id, this.groupId, this.defaultBilling, this.defaultShipping, this.confirmation, this.createdAt, this.updatedAt, this.createdIn, this.dob, this.email, this.firstname, this.lastname, this.middlename, this.prefix, this.suffix, this.gender, this.storeId, this.taxvat, this.websiteId, this.addresses, this.disableAutoGroupChange, this.extensionAttributes, this.customAttributes});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['group_id'];
    defaultBilling = json['default_billing'];
    defaultShipping = json['default_shipping'];
    confirmation = json['confirmation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdIn = json['created_in'];
    dob = json['dob'];
    email = json['email'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    middlename = json['middlename'];
    prefix = json['prefix'];
    suffix = json['suffix'];
    gender = json['gender'];
    storeId = json['store_id'];
    taxvat = json['taxvat'];
    websiteId = json['website_id'];
    if (json['addresses'] != null) {
      addresses = <Address>[];
      json['addresses'].forEach((v) { addresses!.add(new Address.fromJson(v)); });
    }
    disableAutoGroupChange = json['disable_auto_group_change'];
    extensionAttributes = json['extension_attributes'] != null ? new ExtensionAttributes.fromJson(json['extension_attributes']) : null;
    if (json['custom_attributes'] != null) {
      customAttributes = <CustomAttributes>[];
      json['custom_attributes'].forEach((v) { customAttributes!.add(new CustomAttributes.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_id'] = this.groupId;
    data['default_billing'] = this.defaultBilling;
    data['default_shipping'] = this.defaultShipping;
    data['confirmation'] = this.confirmation;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_in'] = this.createdIn;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['middlename'] = this.middlename;
    data['prefix'] = this.prefix;
    data['suffix'] = this.suffix;
    data['gender'] = this.gender;
    data['store_id'] = this.storeId;
    data['taxvat'] = this.taxvat;
    data['website_id'] = this.websiteId;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    data['disable_auto_group_change'] = this.disableAutoGroupChange;
    if (this.extensionAttributes != null) {
      data['extension_attributes'] = this.extensionAttributes!.toJson();
    }
    if (this.customAttributes != null) {
      data['custom_attributes'] = this.customAttributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toUpfateProfileJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    var fullname = firstname?.split(' ');
    data['id'] = this.id;
    data['vendor_id'] = this.vendor_id;
    data['status'] = this.status;
    data['city'] = this.city;
    data['company'] = this.company;
    data['country_id'] = this.country_id;
    _putAddress(data);
    data['region'] = this.region;
    data['telephone'] = this.telephone;
    if((fullname?.length ?? 0) > 0){
      data['firstname'] = fullname?[0];
    }else{
      data['firstname'] = this.firstname;
    }
    if((fullname?.length ?? 0) > 1){
      data['lastname'] = fullname?[1];
    }
    return data;
  }

  /// Street and postcode are optional, so they are only sent when filled in:
  /// a vendor who leaves them empty sends the same payload as before.
  void _putAddress(Map<String, dynamic> data) {
    if ((street ?? '').trim().isNotEmpty) data['street'] = street!.trim();
    if ((postcode ?? '').trim().isNotEmpty) data['postcode'] = postcode!.trim();
  }
  Map<String, dynamic> toRegisterJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    var fullname = firstname?.split(' ');
    data['email'] = this.email;
    data['vendor_id'] = this.vendor_id;
    data['city'] = this.city;
    data['company'] = this.company;
    data['country_id'] = this.country_id;
    _putAddress(data);
    data['region'] = this.region;
    data['telephone'] = this.telephone;
    if((fullname?.length ?? 0) > 0){
      data['firstname'] = fullname?[0];
    }else{
      data['firstname'] = this.firstname;
    }
    if((fullname?.length ?? 0) > 1){
      data['lastname'] = fullname?[1];
    }
    final Map<String, dynamic> extension_attributes = new Map<String, dynamic>();
    extension_attributes['password'] = this.password;
    data['extension_attributes'] = extension_attributes;
    return data;
  }
}


class Address {
  int? id;
  int? customerId;
  Region? region;
  int? regionId;
  String? countryId;
  List<String>? street;
  String? company;
  String? telephone;
  String? fax;
  String? postcode;
  String? city;
  String? firstname;
  String? lastname;
  String? middlename;
  String? prefix;
  String? suffix;
  String? vatId;
  bool? defaultShipping;
  bool? defaultBilling;
  ExtensionAttributes? extensionAttributes;
  List<CustomAttributes>? customAttributes;

  Address({this.id, this.customerId, this.region, this.regionId, this.countryId, this.street, this.company, this.telephone, this.fax, this.postcode, this.city, this.firstname, this.lastname, this.middlename, this.prefix, this.suffix, this.vatId, this.defaultShipping, this.defaultBilling, this.extensionAttributes, this.customAttributes});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    region = json['region'] != null ? new Region.fromJson(json['region']) : null;
    regionId = json['region_id'];
    countryId = json['country_id'];
    street = json['street'].cast<String>();
    company = json['company'];
    telephone = json['telephone'];
    fax = json['fax'];
    postcode = json['postcode'];
    city = json['city'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    middlename = json['middlename'];
    prefix = json['prefix'];
    suffix = json['suffix'];
    vatId = json['vat_id'];
    defaultShipping = json['default_shipping'];
    defaultBilling = json['default_billing'];
    extensionAttributes = json['extension_attributes'] != null ? new ExtensionAttributes.fromJson(json['extension_attributes']) : null;
    if (json['custom_attributes'] != null) {
      customAttributes = <CustomAttributes>[];
      json['custom_attributes'].forEach((v) { customAttributes!.add(new CustomAttributes.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    data['region_id'] = this.regionId;
    data['country_id'] = this.countryId;
    data['street'] = this.street;
    data['company'] = this.company;
    data['telephone'] = this.telephone;
    data['fax'] = this.fax;
    data['postcode'] = this.postcode;
    data['city'] = this.city;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['middlename'] = this.middlename;
    data['prefix'] = this.prefix;
    data['suffix'] = this.suffix;
    data['vat_id'] = this.vatId;
    data['default_shipping'] = this.defaultShipping;
    data['default_billing'] = this.defaultBilling;
    if (this.extensionAttributes != null) {
      data['extension_attributes'] = this.extensionAttributes!.toJson();
    }
    if (this.customAttributes != null) {
      data['custom_attributes'] = this.customAttributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Region {
  String? regionCode;
  String? region;
  int? regionId;
  ExtensionAttributes? extensionAttributes;

  Region({this.regionCode, this.region, this.regionId, this.extensionAttributes});

  Region.fromJson(Map<String, dynamic> json) {
    regionCode = json['region_code'];
    region = json['region'];
    regionId = json['region_id'];
    extensionAttributes = json['extension_attributes'] != null ? new ExtensionAttributes.fromJson(json['extension_attributes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['region_code'] = this.regionCode;
    data['region'] = this.region;
    data['region_id'] = this.regionId;
    if (this.extensionAttributes != null) {
      data['extension_attributes'] = this.extensionAttributes!.toJson();
    }
    return data;
  }
}

class CustomAttributes {
  String? attributeCode;
  String? value;

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

class ExtensionAttributes {
  int? assistanceAllowed;
  bool? isSubscribed;

  ExtensionAttributes({this.assistanceAllowed, this.isSubscribed});

  ExtensionAttributes.fromJson(Map<String, dynamic> json) {
    assistanceAllowed = json['assistance_allowed'];
    isSubscribed = json['is_subscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assistance_allowed'] = this.assistanceAllowed;
    data['is_subscribed'] = this.isSubscribed;
    return data;
  }
}

