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
    creditAmount = json['credit_amount'];
    lifetimeSales = json['lifetime_sales'];
    averageOrders = json['average_orders'];
    totalProducts = json['total_products'];
    if (json['order_chart_data'] != null) {
      orderChartData = <OrderChartData>[];
      json['order_chart_data'].forEach((v) {
        orderChartData!.add(new OrderChartData.fromJson(v));
      });
    }
    if (json['amount_chart_data'] != null) {
      amountChartData = <OrderChartData>[];
      json['amount_chart_data'].forEach((v) {
        amountChartData!.add(new OrderChartData.fromJson(v));
      });
    }
    if (json['credit_chart_data'] != null) {
      creditChartData = <OrderChartData>[];
      json['credit_chart_data'].forEach((v) {
        creditChartData!.add(new OrderChartData.fromJsonCredit(v));
      });
    }
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
  int? numberOfOrder;
  int? orderAmount;

  OrderChartData({this.time, this.numberOfOrder, this.orderAmount});

  OrderChartData.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    numberOfOrder = json['number_of_order'];
    orderAmount = json['order_amount'];
  }

  OrderChartData.fromJsonCredit(Map<String, dynamic> json) {
    time = json['time'];
    numberOfOrder = json['received'];
    orderAmount = json['spent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['number_of_order'] = this.numberOfOrder;
    data['order_amount'] = this.orderAmount;
    return data;
  }
}
