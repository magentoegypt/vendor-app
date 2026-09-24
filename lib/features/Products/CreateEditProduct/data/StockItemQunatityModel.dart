
class StockItemQunatityModel {

  int? itemId;
  int? productId;
  int? stockId;
  int? qty;
  bool? isInStock;
  bool? isQtyDecimal;
  bool? showDefaultNotificationMessage;
  bool? useConfigMinQty;
  int? minQty;
  int? useConfigMinSaleQty;
  int? minSaleQty;
  bool? useConfigMaxSaleQty;
  int? maxSaleQty;
  bool? useConfigBackorders;
  int? backorders;
  bool? useConfigNotifyStockQty;
  int? notifyStockQty;
  bool? useConfigQtyIncrements;
  int? qtyIncrements;
  bool? useConfigEnableQtyInc;
  bool? enableQtyIncrements;
  bool? useConfigManageStock;
  bool? manageStock;
  String? lowStockDate;
  bool? isDecimalDivided;
  int? stockStatusChangedAuto;

  StockItemQunatityModel(
      {this.itemId,
        this.productId,
        this.stockId,
        this.qty,
        this.isInStock,
        this.isQtyDecimal,
        this.showDefaultNotificationMessage,
        this.useConfigMinQty,
        this.minQty,
        this.useConfigMinSaleQty,
        this.minSaleQty,
        this.useConfigMaxSaleQty,
        this.maxSaleQty,
        this.useConfigBackorders,
        this.backorders,
        this.useConfigNotifyStockQty,
        this.notifyStockQty,
        this.useConfigQtyIncrements,
        this.qtyIncrements,
        this.useConfigEnableQtyInc,
        this.enableQtyIncrements,
        this.useConfigManageStock,
        this.manageStock,
        this.lowStockDate,
        this.isDecimalDivided,
        this.stockStatusChangedAuto});

  StockItemQunatityModel.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    productId = json['product_id'];
    stockId = json['stock_id'];
    qty = json['qty'];
    isInStock = json['is_in_stock'];
    isQtyDecimal = json['is_qty_decimal'];
    showDefaultNotificationMessage = json['show_default_notification_message'];
    useConfigMinQty = json['use_config_min_qty'];
    minQty = json['min_qty'];
    useConfigMinSaleQty = json['use_config_min_sale_qty'];
    minSaleQty = json['min_sale_qty'];
    useConfigMaxSaleQty = json['use_config_max_sale_qty'];
    maxSaleQty = json['max_sale_qty'];
    useConfigBackorders = json['use_config_backorders'];
    backorders = json['backorders'];
    useConfigNotifyStockQty = json['use_config_notify_stock_qty'];
    notifyStockQty = json['notify_stock_qty'];
    useConfigQtyIncrements = json['use_config_qty_increments'];
    qtyIncrements = json['qty_increments'];
    useConfigEnableQtyInc = json['use_config_enable_qty_inc'];
    enableQtyIncrements = json['enable_qty_increments'];
    useConfigManageStock = json['use_config_manage_stock'];
    manageStock = json['manage_stock'];
    lowStockDate = json['low_stock_date'];
    isDecimalDivided = json['is_decimal_divided'];
    stockStatusChangedAuto = json['stock_status_changed_auto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['product_id'] = this.productId;
    data['stock_id'] = this.stockId;
    data['qty'] = this.qty;
    data['is_in_stock'] = this.isInStock;
    data['is_qty_decimal'] = this.isQtyDecimal;
    data['show_default_notification_message'] =
        this.showDefaultNotificationMessage;
    data['use_config_min_qty'] = this.useConfigMinQty;
    data['min_qty'] = this.minQty;
    data['use_config_min_sale_qty'] = this.useConfigMinSaleQty;
    data['min_sale_qty'] = this.minSaleQty;
    data['use_config_max_sale_qty'] = this.useConfigMaxSaleQty;
    data['max_sale_qty'] = this.maxSaleQty;
    data['use_config_backorders'] = this.useConfigBackorders;
    data['backorders'] = this.backorders;
    data['use_config_notify_stock_qty'] = this.useConfigNotifyStockQty;
    data['notify_stock_qty'] = this.notifyStockQty;
    data['use_config_qty_increments'] = this.useConfigQtyIncrements;
    data['qty_increments'] = this.qtyIncrements;
    data['use_config_enable_qty_inc'] = this.useConfigEnableQtyInc;
    data['enable_qty_increments'] = this.enableQtyIncrements;
    data['use_config_manage_stock'] = this.useConfigManageStock;
    data['manage_stock'] = this.manageStock;
    data['low_stock_date'] = this.lowStockDate;
    data['is_decimal_divided'] = this.isDecimalDivided;
    data['stock_status_changed_auto'] = this.stockStatusChangedAuto;
    return data;
  }
}