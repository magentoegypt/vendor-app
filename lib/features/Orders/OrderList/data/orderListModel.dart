import '../../../../core/utils/json_parser.dart';

class OrderListModel {
  List<OrderModel>? items;
  SearchCriteria? searchCriteria;
  int? totalCount;

  OrderListModel({this.items, this.searchCriteria, this.totalCount});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    items = JsonParser.toList(json['items'], OrderModel.fromJson);
    searchCriteria = JsonParser.toObject(json['search_criteria'], SearchCriteria.fromJson);
    totalCount = JsonParser.toInt(json['total_count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total_count'] = this.totalCount;
    return data;
  }
}


class OrderModel {
  int? entityId;
  int? vendorId;
  int? orderId;
  String? status;
  num? baseDiscountAmount;
  num? baseGrandTotal;
  num? baseShippingAmount;
  num? baseShippingTaxAmount;
  num? baseSubtotal;
  num? baseTaxAmount;
  num? discountAmount;
  num? grandTotal;
  num? shippingAmount;
  num? shippingTaxAmount;
  num? subtotal;
  num? taxAmount;
  num? totalQtyOrdered;
  num? taxInvoiced;
  num? baseTaxInvoiced;
  num? subtotalInclTax;
  num? baseSubtotalInclTax;
  num? weight;
  String? createdAt;
  String? updatedAt;
  num? shippingInclTax;
  num? baseShippingInclTax;
  num? totalDue;
  num? baseTotalDue;
  String? billingName;
  String? shippingName;
  BillingAddress? billingAddress;
  BillingAddress? shippingAddress;
  String? customerEmail;
  String? customerGroup;
  String? shippingAndHandling;
  String? customerName;
  String? paymentMethod;
  String? baseCurrencyCode;
  String? orderCurrencyCode;
  List<Product>? items;
  Payment? payment;
  bool? canCancel;
  bool? canInvoice;
  bool? canShip;
  bool? canCreditMemo;
  String? incrementId;

  OrderModel(
      {this.entityId,
        this.vendorId,
        this.orderId,
        this.status,
        this.baseDiscountAmount,
        this.baseGrandTotal,
        this.baseShippingAmount,
        this.baseShippingTaxAmount,
        this.baseSubtotal,
        this.baseTaxAmount,
        this.discountAmount,
        this.grandTotal,
        this.shippingAmount,
        this.shippingTaxAmount,
        this.subtotal,
        this.taxAmount,
        this.totalQtyOrdered,
        this.taxInvoiced,
        this.baseTaxInvoiced,
        this.subtotalInclTax,
        this.baseSubtotalInclTax,
        this.weight,
        this.createdAt,
        this.updatedAt,
        this.shippingInclTax,
        this.baseShippingInclTax,
        this.totalDue,
        this.baseTotalDue,
        this.billingName,
        this.shippingName,
        this.billingAddress,
        this.shippingAddress,
        this.customerEmail,
        this.customerGroup,
        this.shippingAndHandling,
        this.customerName,
        this.paymentMethod,
        this.baseCurrencyCode,
        this.orderCurrencyCode,
        this.items,
        this.payment,
        this.canCancel,
        this.canInvoice,
        this.canShip,
        this.canCreditMemo,
        this.incrementId});

  OrderModel.fromJson(Map<String, dynamic> json) {
    entityId = JsonParser.toInt(json['entity_id']);
    vendorId = JsonParser.toInt(json['vendor_id']);
    orderId = JsonParser.toInt(json['order_id']);
    status = JsonParser.toStr(json['status']);
    baseDiscountAmount = JsonParser.toNum(json['base_discount_amount']);
    baseGrandTotal = JsonParser.toNum(json['base_grand_total']);
    baseShippingAmount = JsonParser.toNum(json['base_shipping_amount']);
    baseShippingTaxAmount = JsonParser.toNum(json['base_shipping_tax_amount']);
    baseSubtotal = JsonParser.toNum(json['base_subtotal']);
    baseTaxAmount = JsonParser.toNum(json['base_tax_amount']);
    discountAmount = JsonParser.toNum(json['discount_amount']);
    grandTotal = JsonParser.toNum(json['grand_total']);
    shippingAmount = JsonParser.toNum(json['shipping_amount']);
    shippingTaxAmount = JsonParser.toNum(json['shipping_tax_amount']);
    subtotal = JsonParser.toNum(json['subtotal']);
    taxAmount = JsonParser.toNum(json['tax_amount']);
    totalQtyOrdered = JsonParser.toNum(json['total_qty_ordered']);
    taxInvoiced = JsonParser.toNum(json['tax_invoiced']);
    baseTaxInvoiced = JsonParser.toNum(json['base_tax_invoiced']);
    subtotalInclTax = JsonParser.toNum(json['subtotal_incl_tax']);
    baseSubtotalInclTax = JsonParser.toNum(json['base_subtotal_incl_tax']);
    weight = JsonParser.toNum(json['weight']);
    createdAt = JsonParser.toStr(json['created_at']);
    updatedAt = JsonParser.toStr(json['updated_at']);
    shippingInclTax = JsonParser.toNum(json['shipping_incl_tax']);
    baseShippingInclTax = JsonParser.toNum(json['base_shipping_incl_tax']);
    totalDue = JsonParser.toNum(json['total_due']);
    baseTotalDue = JsonParser.toNum(json['base_total_due']);

    billingName = JsonParser.toStr(json['billing_name']);
    shippingName = JsonParser.toStr(json['shipping_name']);
    billingAddress = JsonParser.toObject(json['billing_address'], BillingAddress.fromJson);
    shippingAddress = JsonParser.toObject(json['shipping_address'], BillingAddress.fromJson);
    customerEmail = JsonParser.toStr(json['customer_email']);
    customerGroup = JsonParser.toStr(json['customer_group']);
    shippingAndHandling = JsonParser.toStr(json['shipping_and_handling']);
    customerName = JsonParser.toStr(json['customer_name']);
    paymentMethod = JsonParser.toStr(json['payment_method']);
    baseCurrencyCode = JsonParser.toStr(json['base_currency_code']);
   orderCurrencyCode = JsonParser.toStr(json['order_currency_code']);
    items = JsonParser.toList(json['items'], Product.fromJson);
    payment = JsonParser.toObject(json['payment'], Payment.fromJson);
    canCancel = JsonParser.toBool(json['can_cancel']);
    canInvoice = JsonParser.toBool(json['can_invoice']);
    canShip = JsonParser.toBool(json['can_ship']);
    canCreditMemo = JsonParser.toBool(json['can_credit_memo']);
    incrementId = JsonParser.toStr(json['increment_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity_id'] = this.entityId;
    data['vendor_id'] = this.vendorId;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['base_discount_amount'] = this.baseDiscountAmount;
    data['base_grand_total'] = this.baseGrandTotal;
    data['base_shipping_amount'] = this.baseShippingAmount;
    data['base_shipping_tax_amount'] = this.baseShippingTaxAmount;
    data['base_subtotal'] = this.baseSubtotal;
    data['base_tax_amount'] = this.baseTaxAmount;
    data['discount_amount'] = this.discountAmount;
    data['grand_total'] = this.grandTotal;
    data['shipping_amount'] = this.shippingAmount;
    data['shipping_tax_amount'] = this.shippingTaxAmount;
    data['subtotal'] = this.subtotal;
    data['tax_amount'] = this.taxAmount;
    data['total_qty_ordered'] = this.totalQtyOrdered;
    data['tax_invoiced'] = this.taxInvoiced;
    data['base_tax_invoiced'] = this.baseTaxInvoiced;
    data['subtotal_incl_tax'] = this.subtotalInclTax;
    data['base_subtotal_incl_tax'] = this.baseSubtotalInclTax;
    data['weight'] = this.weight;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['shipping_incl_tax'] = this.shippingInclTax;
    data['base_shipping_incl_tax'] = this.baseShippingInclTax;
    data['total_due'] = this.totalDue;
    data['base_total_due'] = this.baseTotalDue;
    data['billing_name'] = this.billingName;
    data['shipping_name'] = this.shippingName;
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress!.toJson();
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    data['customer_email'] = this.customerEmail;
    data['customer_group'] = this.customerGroup;
    data['shipping_and_handling'] = this.shippingAndHandling;
    data['customer_name'] = this.customerName;
    data['payment_method'] = this.paymentMethod;
    data['base_currency_code'] = this.baseCurrencyCode;
    data['order_currency_code'] = this.orderCurrencyCode;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    data['can_cancel'] = this.canCancel;
    data['can_invoice'] = this.canInvoice;
    data['can_ship'] = this.canShip;
    data['can_credit_memo'] = this.canCreditMemo;
    data['increment_id'] = this.incrementId;
    return data;
  }
}

class BillingAddress {
  String? addressType;
  String? city;
  String? company;
  String? countryId;
  String? email;
  int? entityId;
  String? firstname;
  String? lastname;
  int? parentId;
  String? postcode;
  String? region;
  String? regionCode;
  int? regionId;
  List<String>? street;
  String? telephone;

  BillingAddress(
      {this.addressType,
        this.city,
        this.company,
        this.countryId,
        this.email,
        this.entityId,
        this.firstname,
        this.lastname,
        this.parentId,
        this.postcode,
        this.region,
        this.regionCode,
        this.regionId,
        this.street,
        this.telephone});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    addressType = JsonParser.toStr(json['address_type']);
    city = JsonParser.toStr(json['city']);
    company = JsonParser.toStr(json['company']);
    countryId = JsonParser.toStr(json['country_id']);
    email = JsonParser.toStr(json['email']);
    entityId = JsonParser.toInt(json['entity_id']);
    firstname = JsonParser.toStr(json['firstname']);
    lastname = JsonParser.toStr(json['lastname']);
    parentId = JsonParser.toInt(json['parent_id']);
    postcode = JsonParser.toStr(json['postcode']);
    region = JsonParser.toStr(json['region']);
    regionCode = JsonParser.toStr(json['region_code']);
    regionId = JsonParser.toInt(json['region_id']);
    street = JsonParser.toStringList(json['street']);
    telephone = JsonParser.toStr(json['telephone']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_type'] = this.addressType;
    data['city'] = this.city;
    data['company'] = this.company;
    data['country_id'] = this.countryId;
    data['email'] = this.email;
    data['entity_id'] = this.entityId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['parent_id'] = this.parentId;
    data['postcode'] = this.postcode;
    data['region'] = this.region;
    data['region_code'] = this.regionCode;
    data['region_id'] = this.regionId;
    data['street'] = this.street;
    data['telephone'] = this.telephone;
    return data;
  }
}

class Product {
  String? itemOptions;
  dynamic amountRefunded;
  String? appliedRuleIds;
  dynamic baseAmountRefunded;
  dynamic baseDiscountAmount;
  dynamic baseDiscountInvoiced;
  dynamic baseDiscountTaxCompensationAmount;
  dynamic baseOriginalPrice;
  dynamic basePrice;
  dynamic basePriceInclTax;
  dynamic baseRowInvoiced;
  dynamic baseRowTotal;
  dynamic baseRowTotalInclTax;
  dynamic baseTaxAmount;
  dynamic baseTaxInvoiced;
  String? createdAt;
  dynamic discountAmount;
  dynamic discountInvoiced;
  dynamic discountPercent;
  dynamic freeShipping;
  dynamic discountTaxCompensationAmount;
  dynamic isQtyDecimal;
  dynamic isVirtual;
  dynamic itemId;
  String? name;
  dynamic noDiscount;
  dynamic orderId;
  dynamic originalPrice;
  dynamic price;
  dynamic priceInclTax;
  dynamic productId;
  String? productType;
  dynamic qtyCanceled;
  dynamic qtyInvoiced;
  dynamic qtyOrdered;
  dynamic qtyRefunded;
  dynamic qtyShipped;
  dynamic quoteItemId;
  dynamic rowInvoiced;
  dynamic rowTotal;
  dynamic rowTotalInclTax;
  dynamic rowWeight;
  String? sku;
  dynamic storeId;
  dynamic taxAmount;
  dynamic taxInvoiced;
  dynamic taxPercent;
  String? updatedAt;
  dynamic weight;

  Product(
      {this.itemOptions,
        this.amountRefunded,
        this.appliedRuleIds,
        this.baseAmountRefunded,
        this.baseDiscountAmount,
        this.baseDiscountInvoiced,
        this.baseDiscountTaxCompensationAmount,
        this.baseOriginalPrice,
        this.basePrice,
        this.basePriceInclTax,
        this.baseRowInvoiced,
        this.baseRowTotal,
        this.baseRowTotalInclTax,
        this.baseTaxAmount,
        this.baseTaxInvoiced,
        this.createdAt,
        this.discountAmount,
        this.discountInvoiced,
        this.discountPercent,
        this.freeShipping,
        this.discountTaxCompensationAmount,
        this.isQtyDecimal,
        this.isVirtual,
        this.itemId,
        this.name,
        this.noDiscount,
        this.orderId,
        this.originalPrice,
        this.price,
        this.priceInclTax,
        this.productId,
        this.productType,
        this.qtyCanceled,
        this.qtyInvoiced,
        this.qtyOrdered,
        this.qtyRefunded,
        this.qtyShipped,
        this.quoteItemId,
        this.rowInvoiced,
        this.rowTotal,
        this.rowTotalInclTax,
        this.rowWeight,
        this.sku,
        this.storeId,
        this.taxAmount,
        this.taxInvoiced,
        this.taxPercent,
        this.updatedAt,
        this.weight});

  Product.fromJson(Map<String, dynamic> json) {
    // json.forEach((key, value){
    //   if(value is double) {
    //     print('key is $key');
    //     print('value is $value ');
    //   }
    // });
    itemOptions = JsonParser.toStr(json['item_options']);
    amountRefunded = json['amount_refunded'];
    appliedRuleIds = JsonParser.toStr(json['applied_rule_ids']);
    baseAmountRefunded = json['base_amount_refunded'];
    baseDiscountAmount = json['base_discount_amount'];
    baseDiscountInvoiced = json['base_discount_invoiced'];
    baseDiscountTaxCompensationAmount = json['base_discount_tax_compensation_amount'];
    baseOriginalPrice = json['base_original_price'];
    basePrice = json['base_price'];
    basePriceInclTax = json['base_price_incl_tax'];
    baseRowInvoiced = json['base_row_invoiced'];
    baseRowTotal = json['base_row_total'];
    baseRowTotalInclTax = json['base_row_total_incl_tax'];
    baseTaxAmount = json['base_tax_amount'];
    baseTaxInvoiced = json['base_tax_invoiced'];
    createdAt = JsonParser.toStr(json['created_at']);
    discountAmount = json['discount_amount'];
    discountInvoiced = json['discount_invoiced'];
    discountPercent = json['discount_percent'];
    freeShipping = json['free_shipping'];
    discountTaxCompensationAmount = json['discount_tax_compensation_amount'];
    isQtyDecimal = json['is_qty_decimal'];
    isVirtual = json['is_virtual'];
    itemId = json['item_id'];
    name = JsonParser.toStr(json['name']);
    noDiscount = json['no_discount'];
    orderId = json['order_id'];
    originalPrice = json['original_price'];
    price = json['price'];
    priceInclTax = json['price_incl_tax'];
    productId = json['product_id'];
    productType = JsonParser.toStr(json['product_type']);
    qtyCanceled = json['qty_canceled'];
    qtyInvoiced = json['qty_invoiced'];
    qtyOrdered = json['qty_ordered'];
    qtyRefunded = json['qty_refunded'];
    qtyShipped = json['qty_shipped'];
    quoteItemId = json['quote_item_id'];
    rowInvoiced = json['row_invoiced'];
    rowTotal = json['row_total'];
    rowTotalInclTax = json['row_total_incl_tax'];
    rowWeight = json['row_weight'];
    sku = JsonParser.toStr(json['sku']);
    storeId = json['store_id'];
    taxAmount = json['tax_amount'];
    taxInvoiced = json['tax_invoiced'];
    taxPercent = json['tax_percent'];
    updatedAt = JsonParser.toStr(json['updated_at']);
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_options'] = this.itemOptions;
    data['amount_refunded'] = this.amountRefunded;
    data['applied_rule_ids'] = this.appliedRuleIds;
    data['base_amount_refunded'] = this.baseAmountRefunded;
    data['base_discount_amount'] = this.baseDiscountAmount;
    data['base_discount_invoiced'] = this.baseDiscountInvoiced;
    data['base_discount_tax_compensation_amount'] =
        this.baseDiscountTaxCompensationAmount;
    data['base_original_price'] = this.baseOriginalPrice;
    data['base_price'] = this.basePrice;
    data['base_price_incl_tax'] = this.basePriceInclTax;
    data['base_row_invoiced'] = this.baseRowInvoiced;
    data['base_row_total'] = this.baseRowTotal;
    data['base_row_total_incl_tax'] = this.baseRowTotalInclTax;
    data['base_tax_amount'] = this.baseTaxAmount;
    data['base_tax_invoiced'] = this.baseTaxInvoiced;
    data['created_at'] = this.createdAt;
    data['discount_amount'] = this.discountAmount;
    data['discount_invoiced'] = this.discountInvoiced;
    data['discount_percent'] = this.discountPercent;
    data['free_shipping'] = this.freeShipping;
    data['discount_tax_compensation_amount'] =
        this.discountTaxCompensationAmount;
    data['is_qty_decimal'] = this.isQtyDecimal;
    data['is_virtual'] = this.isVirtual;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['no_discount'] = this.noDiscount;
    data['order_id'] = this.orderId;
    data['original_price'] = this.originalPrice;
    data['price'] = this.price;
    data['price_incl_tax'] = this.priceInclTax;
    data['product_id'] = this.productId;
    data['product_type'] = this.productType;
    data['qty_canceled'] = this.qtyCanceled;
    data['qty_invoiced'] = this.qtyInvoiced;
    data['qty_ordered'] = this.qtyOrdered;
    data['qty_refunded'] = this.qtyRefunded;
    data['qty_shipped'] = this.qtyShipped;
    data['quote_item_id'] = this.quoteItemId;
    data['row_invoiced'] = this.rowInvoiced;
    data['row_total'] = this.rowTotal;
    data['row_total_incl_tax'] = this.rowTotalInclTax;
    data['row_weight'] = this.rowWeight;
    data['sku'] = this.sku;
    data['store_id'] = this.storeId;
    data['tax_amount'] = this.taxAmount;
    data['tax_invoiced'] = this.taxInvoiced;
    data['tax_percent'] = this.taxPercent;
    data['updated_at'] = this.updatedAt;
    data['weight'] = this.weight;
    return data;
  }
}

class Payment {
  String? accountStatus;
  List<String>? additionalInformation;
  num? amountOrdered;
  num? baseAmountOrdered;
  num? baseShippingAmount;
  String? ccExpYear;
  String? ccLast4;
  String? ccSsStartMonth;
  String? ccSsStartYear;
  int? entityId;
  String? method;
  int? parentId;
  num? shippingAmount;

  Payment(
      {this.accountStatus,
        this.additionalInformation,
        this.amountOrdered,
        this.baseAmountOrdered,
        this.baseShippingAmount,
        this.ccExpYear,
        this.ccLast4,
        this.ccSsStartMonth,
        this.ccSsStartYear,
        this.entityId,
        this.method,
        this.parentId,
        this.shippingAmount});

  Payment.fromJson(Map<String, dynamic> json) {
    accountStatus = JsonParser.toStr(json['account_status']);
    additionalInformation = JsonParser.toStringList(json['additional_information']);
    amountOrdered = JsonParser.toNum(json['amount_ordered']);
    baseAmountOrdered = JsonParser.toNum(json['base_amount_ordered']);
    baseShippingAmount = JsonParser.toNum(json['base_shipping_amount']);
    ccExpYear = JsonParser.toStr(json['cc_exp_year']);
    ccLast4 = JsonParser.toStr(json['cc_last4']);
    ccSsStartMonth = JsonParser.toStr(json['cc_ss_start_month']);
    ccSsStartYear = JsonParser.toStr(json['cc_ss_start_year']);
    entityId = JsonParser.toInt(json['entity_id']);
    method = JsonParser.toStr(json['method']);
    parentId = JsonParser.toInt(json['parent_id']);
    shippingAmount = JsonParser.toNum(json['shipping_amount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_status'] = this.accountStatus;
    data['additional_information'] = this.additionalInformation;
    data['amount_ordered'] = this.amountOrdered;
    data['base_amount_ordered'] = this.baseAmountOrdered;
    data['base_shipping_amount'] = this.baseShippingAmount;
    data['cc_exp_year'] = this.ccExpYear;
    data['cc_last4'] = this.ccLast4;
    data['cc_ss_start_month'] = this.ccSsStartMonth;
    data['cc_ss_start_year'] = this.ccSsStartYear;
    data['entity_id'] = this.entityId;
    data['method'] = this.method;
    data['parent_id'] = this.parentId;
    data['shipping_amount'] = this.shippingAmount;
    return data;
  }
}

class SearchCriteria {

  int? pageSize;

  SearchCriteria({this.pageSize});

  SearchCriteria.fromJson(Map<String, dynamic> json) {

    pageSize = JsonParser.toInt(json['page_size']);
  }

}