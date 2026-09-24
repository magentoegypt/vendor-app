import '../../../core/utils/json_parser.dart';

class DashboarModel {
  String? creditAmount;
  String? lifetimeSales;
  String? averageOrders;
  int? totalProducts;
  List<OrderChartData>? orderChartData;
  List<OrderChartData>? amountChartData;
  List<OrderChartData>? creditChartData;

  DashboarModel(
      {this.creditAmount,
        this.lifetimeSales,
        this.averageOrders,
        this.totalProducts,
        this.orderChartData,
        this.amountChartData,
        this.creditChartData});

  DashboarModel.fromJson(Map<String, dynamic> json) {
    creditAmount = JsonParser.toStr(json['credit_amount']);
    lifetimeSales = JsonParser.toStr(json['lifetime_sales']);
    averageOrders = JsonParser.toStr(json['average_orders']);
    totalProducts = JsonParser.toInt(json['total_products']);
    orderChartData = JsonParser.toList(json['order_chart_data'], OrderChartData.fromJson);
    amountChartData = JsonParser.toList(json['amount_chart_data'], OrderChartData.fromJson);
    creditChartData = JsonParser.toList(json['credit_chart_data'], OrderChartData.fromJsonCredit);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_amount'] = this.creditAmount;
    data['lifetime_sales'] = this.lifetimeSales;
    data['average_orders'] = this.averageOrders;
    data['total_products'] = this.totalProducts;
    if (this.orderChartData != null) {
      data['order_chart_data'] =
          this.orderChartData!.map((v) => v.toJson()).toList();
    }
    if (this.amountChartData != null) {
      data['amount_chart_data'] =
          this.amountChartData!.map((v) => v.toJson()).toList();
    }
    if (this.creditChartData != null) {
      data['credit_chart_data'] =
          this.creditChartData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderChartData {
  String? time;
  num? numberOfOrder;
  num? orderAmount;

  OrderChartData({this.time, this.numberOfOrder, this.orderAmount});

  OrderChartData.fromJson(Map<String, dynamic> json) {
    time = JsonParser.toStr(json['time']);
    numberOfOrder = JsonParser.toNum(json['number_of_order']);
    orderAmount = JsonParser.toNum(json['order_amount']);
  }

  OrderChartData.fromJsonCredit(Map<String, dynamic> json) {
    time = JsonParser.toStr(json['time']);
    numberOfOrder = JsonParser.toNum(json['received']);
    orderAmount = JsonParser.toNum(json['spent']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['number_of_order'] = this.numberOfOrder;
    data['order_amount'] = this.orderAmount;
    return data;
  }
}
