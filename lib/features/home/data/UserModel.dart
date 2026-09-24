import '../../../core/utils/json_parser.dart';

class UserModel {
  int? id;
  String? vendorId;
  String? email;
  String? createdAt;
  String? updatedAt;
  int? groupId;
  int? status;
  String? city;
  String? company;
  String? countryId;
  String? postcode;
  int? regionId;
  String? street;
  String? telephone;
  int? customerId;
  String? firstname;
  String? lastname;
  String? middlename;
  String? groupName;
  String? name;
  String? statusLabel;
  String? country;
  String? countryName;
  String? regionCode;

  UserModel(
      {this.id,
        this.vendorId,
        this.email,
        this.createdAt,
        this.updatedAt,
        this.groupId,
        this.status,
        this.city,
        this.company,
        this.countryId,
        this.postcode,
        this.regionId,
        this.street,
        this.telephone,
        this.customerId,
        this.firstname,
        this.lastname,
        this.middlename,
        this.groupName,
        this.name,
        this.statusLabel,
        this.country,
        this.countryName,
        this.regionCode});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = JsonParser.toInt(json['id']);
    vendorId = JsonParser.toStr(json['vendor_id']);
    email = JsonParser.toStr(json['email']);
    createdAt = JsonParser.toStr(json['created_at']);
    updatedAt = JsonParser.toStr(json['updated_at']);
    groupId = JsonParser.toInt(json['group_id']);
    status = JsonParser.toInt(json['status']);
    city = JsonParser.toStr(json['city']);
    company = JsonParser.toStr(json['company']);
    countryId = JsonParser.toStr(json['country_id']);
    postcode = JsonParser.toStr(json['postcode']);
    regionId = JsonParser.toInt(json['region_id']);
    street = JsonParser.toStr(json['street']);
    telephone = JsonParser.toStr(json['telephone']);
    customerId = JsonParser.toInt(json['customer_id']);
    firstname = JsonParser.toStr(json['firstname']);
    lastname = JsonParser.toStr(json['lastname']);
    middlename = JsonParser.toStr(json['middlename']);
    groupName = JsonParser.toStr(json['group_name']);
    name = JsonParser.toStr(json['name']);
    statusLabel = JsonParser.toStr(json['status_label']);
    country = JsonParser.toStr(json['country']);
    countryName = JsonParser.toStr(json['country_name']);
    regionCode = JsonParser.toStr(json['region_code']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['group_id'] = this.groupId;
    data['status'] = this.status;
    data['city'] = this.city;
    data['company'] = this.company;
    data['country_id'] = this.countryId;
    data['postcode'] = this.postcode;
    data['region_id'] = this.regionId;
    data['street'] = this.street;
    data['telephone'] = this.telephone;
    data['customer_id'] = this.customerId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['middlename'] = this.middlename;
    data['group_name'] = this.groupName;
    data['name'] = this.name;
    data['status_label'] = this.statusLabel;
    data['country'] = this.country;
    data['country_name'] = this.countryName;
    data['region_code'] = this.regionCode;
    return data;
  }
}