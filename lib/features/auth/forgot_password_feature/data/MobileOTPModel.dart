import '../../../../core/utils/json_parser.dart';

class MobileOTPModel {
  String? status;
  String? message;
  String? token;

  MobileOTPModel({this.status, this.message, this.token});

  MobileOTPModel.fromJson(Map<String, dynamic> json) {
    status = JsonParser.toStr(json['status']);
    message = JsonParser.toStr(json['message']);
    token = JsonParser.toStr(json['token']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    return data;
  }
}