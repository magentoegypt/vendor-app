import '../../../../core/utils/json_parser.dart';

class OrderModel {
  num? commission;
  int? entityId;
  int? vendorId;
  int? orderId;
  String? status;
  num? baseDiscountAmount;
  num? baseGrandTotal;
  num? baseShippingInvoiced;
  num? baseShippingRefunded;
  num? baseShippingAmount;
  num? baseShippingTaxAmount;
  num? baseShippingTaxRefunded;
  num? baseSubtotal;
  num? baseTotalInvoiced;
  num? baseTotalPaid;
  num? baseTotalRefunded;
  num? baseTaxAmount;
  num? discountAmount;
  num? grandTotal;
  num? shippingAmount;
  num? shippingInvoiced;
  num? shippingRefunded;
  num? shippingTaxAmount;
  num? shippingTaxRefunded;
  num? subtotal;
  num? taxAmount;
  num? totalInvoiced;
  num? totalPaid;
  num? totalQtyOrdered;
  num? totalRefunded;
  num? taxRefunded;
  num? baseTaxRefunded;
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
  List<Items>? items;
  Payment? payment;
  bool? canCancel;
  bool? canInvoice;
  bool? canShip;
  bool? canCreditMemo;
  String? incrementId;

  OrderModel(
      {this.commission,
        this.entityId,
        this.vendorId,
        this.orderId,
        this.status,
        this.baseDiscountAmount,
        this.baseGrandTotal,
        this.baseShippingInvoiced,
        this.baseShippingRefunded,
        this.baseShippingAmount,
        this.baseShippingTaxAmount,
        this.baseShippingTaxRefunded,
        this.baseSubtotal,
        this.baseTotalInvoiced,
        this.baseTotalPaid,
        this.baseTotalRefunded,
        this.baseTaxAmount,
        this.discountAmount,
        this.grandTotal,
        this.shippingAmount,
        this.shippingInvoiced,
        this.shippingRefunded,
        this.shippingTaxAmount,
        this.shippingTaxRefunded,
        this.subtotal,
        this.taxAmount,
        this.totalInvoiced,
        this.totalPaid,
        this.totalQtyOrdered,
        this.totalRefunded,
        this.taxRefunded,
        this.baseTaxRefunded,
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
    commission = JsonParser.toNum(json['commission']);
    entityId = JsonParser.toInt(json['entity_id']);
    vendorId = JsonParser.toInt(json['vendor_id']);
    orderId = JsonParser.toInt(json['order_id']);
    status = JsonParser.toStr(json['status']);
    baseDiscountAmount = JsonParser.toNum(json['base_discount_amount']);
    baseGrandTotal = JsonParser.toNum(json['base_grand_total']);
    baseShippingInvoiced = JsonParser.toNum(json['base_shipping_invoiced']);
    baseShippingRefunded = JsonParser.toNum(json['base_shipping_refunded']);
    baseShippingAmount = JsonParser.toNum(json['base_shipping_amount']);
    baseShippingTaxAmount = JsonParser.toNum(json['base_shipping_tax_amount']);
    baseShippingTaxRefunded = JsonParser.toNum(json['base_shipping_tax_refunded']);
    baseSubtotal = JsonParser.toNum(json['base_subtotal']);
    baseTotalInvoiced = JsonParser.toNum(json['base_total_invoiced']);
    baseTotalPaid = JsonParser.toNum(json['base_total_paid']);
    baseTotalRefunded = JsonParser.toNum(json['base_total_refunded']);
    baseTaxAmount = JsonParser.toNum(json['base_tax_amount']);
    discountAmount = JsonParser.toNum(json['discount_amount']);
    grandTotal = JsonParser.toNum(json['grand_total']);
    shippingAmount = JsonParser.toNum(json['shipping_amount']);
    shippingInvoiced = JsonParser.toNum(json['shipping_invoiced']);
    shippingRefunded = JsonParser.toNum(json['shipping_refunded']);
    shippingTaxAmount = JsonParser.toNum(json['shipping_tax_amount']);
    shippingTaxRefunded = JsonParser.toNum(json['shipping_tax_refunded']);
    subtotal = JsonParser.toNum(json['subtotal']);
    taxAmount = JsonParser.toNum(json['tax_amount']);
    totalInvoiced = JsonParser.toNum(json['total_invoiced']);
    totalPaid = JsonParser.toNum(json['total_paid']);
    totalQtyOrdered = JsonParser.toNum(json['total_qty_ordered']);
    totalRefunded = JsonParser.toNum(json['total_refunded']);
    taxRefunded = JsonParser.toNum(json['tax_refunded']);
    baseTaxRefunded = JsonParser.toNum(json['base_tax_refunded']);
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
    items = JsonParser.toList(json['items'], Items.fromJson);
    payment = JsonParser.toObject(json['payment'], Payment.fromJson);
    canCancel = JsonParser.toBool(json['can_cancel']);
    canInvoice = JsonParser.toBool(json['can_invoice']);
    canShip = JsonParser.toBool(json['can_ship']);
    canCreditMemo = JsonParser.toBool(json['can_credit_memo']);
    incrementId = JsonParser.toStr(json['increment_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission'] = this.commission;
    data['entity_id'] = this.entityId;
    data['vendor_id'] = this.vendorId;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['base_discount_amount'] = this.baseDiscountAmount;
    data['base_grand_total'] = this.baseGrandTotal;
    data['base_shipping_invoiced'] = this.baseShippingInvoiced;
    data['base_shipping_refunded'] = this.baseShippingRefunded;
    data['base_shipping_amount'] = this.baseShippingAmount;
    data['base_shipping_tax_amount'] = this.baseShippingTaxAmount;
    data['base_shipping_tax_refunded'] = this.baseShippingTaxRefunded;
    data['base_subtotal'] = this.baseSubtotal;
    data['base_total_invoiced'] = this.baseTotalInvoiced;
    data['base_total_paid'] = this.baseTotalPaid;
    data['base_total_refunded'] = this.baseTotalRefunded;
    data['base_tax_amount'] = this.baseTaxAmount;
    data['discount_amount'] = this.discountAmount;
    data['grand_total'] = this.grandTotal;
    data['shipping_amount'] = this.shippingAmount;
    data['shipping_invoiced'] = this.shippingInvoiced;
    data['shipping_refunded'] = this.shippingRefunded;
    data['shipping_tax_amount'] = this.shippingTaxAmount;
    data['shipping_tax_refunded'] = this.shippingTaxRefunded;
    data['subtotal'] = this.subtotal;
    data['tax_amount'] = this.taxAmount;
    data['total_invoiced'] = this.totalInvoiced;
    data['total_paid'] = this.totalPaid;
    data['total_qty_ordered'] = this.totalQtyOrdered;
    data['total_refunded'] = this.totalRefunded;
    data['tax_refunded'] = this.taxRefunded;
    data['base_tax_refunded'] = this.baseTaxRefunded;
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
  int? customerAddressId;
  String? email;
  int? entityId;
  String? firstname;
  String? lastname;
  int? parentId;
  String? postcode;
  List<String>? street;
  String? telephone;

  BillingAddress(
      {this.addressType,
        this.city,
        this.company,
        this.countryId,
        this.customerAddressId,
        this.email,
        this.entityId,
        this.firstname,
        this.lastname,
        this.parentId,
        this.postcode,
        this.street,
        this.telephone});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    addressType = JsonParser.toStr(json['address_type']);
    city = JsonParser.toStr(json['city']);
    company = JsonParser.toStr(json['company']);
    countryId = JsonParser.toStr(json['country_id']);
    customerAddressId = JsonParser.toInt(json['customer_address_id']);
    email = JsonParser.toStr(json['email']);
    entityId = JsonParser.toInt(json['entity_id']);
    firstname = JsonParser.toStr(json['firstname']);
    lastname = JsonParser.toStr(json['lastname']);
    parentId = JsonParser.toInt(json['parent_id']);
    postcode = JsonParser.toStr(json['postcode']);
    street = JsonParser.toStringList(json['street']);
    telephone = JsonParser.toStr(json['telephone']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_type'] = this.addressType;
    data['city'] = this.city;
    data['company'] = this.company;
    data['country_id'] = this.countryId;
    data['customer_address_id'] = this.customerAddressId;
    data['email'] = this.email;
    data['entity_id'] = this.entityId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['parent_id'] = this.parentId;
    data['postcode'] = this.postcode;
    data['street'] = this.street;
    data['telephone'] = this.telephone;
    return data;
  }
}

class Items {
  String? thumbnail;
  dynamic itemOptions;
  num? amountRefunded;
  String? appliedRuleIds;
  num? baseAmountRefunded;
  num? baseDiscountAmount;
  num? baseDiscountInvoiced;
  num? baseDiscountRefunded;
  num? baseDiscountTaxCompensationAmount;
  num? baseDiscountTaxCompensationInvoiced;
  num? baseDiscountTaxCompensationRefunded;
  num? baseOriginalPrice;
  num? basePrice;
  num? basePriceInclTax;
  num? baseRowInvoiced;
  num? baseRowTotal;
  num? baseRowTotalInclTax;
  num? baseTaxAmount;
  num? baseTaxInvoiced;
  num? baseTaxRefunded;
  String? createdAt;
  num? discountAmount;
  num? discountInvoiced;
  num? discountPercent;
  num? discountRefunded;
  int? freeShipping;
  num? discountTaxCompensationAmount;
  num? discountTaxCompensationInvoiced;
  num? discountTaxCompensationRefunded;
  int? isQtyDecimal;
  int? isVirtual;
  int? itemId;
  String? name;
  int? noDiscount;
  int? orderId;
  num? originalPrice;
  num? price;
  num? priceInclTax;
  int? productId;
  String? productType;
  num? qtyCanceled;
  num? qtyInvoiced;
  num? qtyOrdered;
  num? qtyRefunded;
  num? qtyShipped;
  int? quoteItemId;
  num? rowInvoiced;
  num? rowTotal;
  num? rowTotalInclTax;
  num? rowWeight;
  String? sku;
  int? storeId;
  num? taxAmount;
  num? taxInvoiced;
  num? taxPercent;
  num? taxRefunded;
  String? updatedAt;
  String? weeeTaxApplied;
  num? weight;
  ExtensionAttributes? extensionAttributes;

  Items(
      {this.thumbnail,
        this.itemOptions,
        this.amountRefunded,
        this.appliedRuleIds,
        this.baseAmountRefunded,
        this.baseDiscountAmount,
        this.baseDiscountInvoiced,
        this.baseDiscountRefunded,
        this.baseDiscountTaxCompensationAmount,
        this.baseDiscountTaxCompensationInvoiced,
        this.baseDiscountTaxCompensationRefunded,
        this.baseOriginalPrice,
        this.basePrice,
        this.basePriceInclTax,
        this.baseRowInvoiced,
        this.baseRowTotal,
        this.baseRowTotalInclTax,
        this.baseTaxAmount,
        this.baseTaxInvoiced,
        this.baseTaxRefunded,
        this.createdAt,
        this.discountAmount,
        this.discountInvoiced,
        this.discountPercent,
        this.discountRefunded,
        this.freeShipping,
        this.discountTaxCompensationAmount,
        this.discountTaxCompensationInvoiced,
        this.discountTaxCompensationRefunded,
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
        this.taxRefunded,
        this.updatedAt,
        this.weeeTaxApplied,
        this.weight,
        this.extensionAttributes});

  Items.fromJson(Map<String, dynamic> json) {
    thumbnail = JsonParser.toStr(json['thumbnail']);
    itemOptions = json['item_options'];
    amountRefunded = JsonParser.toNum(json['amount_refunded']);
    appliedRuleIds = JsonParser.toStr(json['applied_rule_ids']);
    baseAmountRefunded = JsonParser.toNum(json['base_amount_refunded']);
    baseDiscountAmount = JsonParser.toNum(json['base_discount_amount']);
    baseDiscountInvoiced = JsonParser.toNum(json['base_discount_invoiced']);
    baseDiscountRefunded = JsonParser.toNum(json['base_discount_refunded']);
    baseDiscountTaxCompensationAmount = JsonParser.toNum(json['base_discount_tax_compensation_amount']);
    baseDiscountTaxCompensationInvoiced = JsonParser.toNum(json['base_discount_tax_compensation_invoiced']);
    baseDiscountTaxCompensationRefunded = JsonParser.toNum(json['base_discount_tax_compensation_refunded']);
    baseOriginalPrice = JsonParser.toNum(json['base_original_price']);
    basePrice = JsonParser.toNum(json['base_price']);
    basePriceInclTax = JsonParser.toNum(json['base_price_incl_tax']);
    baseRowInvoiced = JsonParser.toNum(json['base_row_invoiced']);
    baseRowTotal = JsonParser.toNum(json['base_row_total']);
    baseRowTotalInclTax = JsonParser.toNum(json['base_row_total_incl_tax']);
    baseTaxAmount = JsonParser.toNum(json['base_tax_amount']);
    baseTaxInvoiced = JsonParser.toNum(json['base_tax_invoiced']);
    baseTaxRefunded = JsonParser.toNum(json['base_tax_refunded']);
    createdAt = JsonParser.toStr(json['created_at']);
    discountAmount = JsonParser.toNum(json['discount_amount']);
    discountInvoiced = JsonParser.toNum(json['discount_invoiced']);
    discountPercent = JsonParser.toNum(json['discount_percent']);
    discountRefunded = JsonParser.toNum(json['discount_refunded']);
    freeShipping = JsonParser.toInt(json['free_shipping']);
    discountTaxCompensationAmount = JsonParser.toNum(json['discount_tax_compensation_amount']);
    discountTaxCompensationInvoiced = JsonParser.toNum(json['discount_tax_compensation_invoiced']);
    discountTaxCompensationRefunded = JsonParser.toNum(json['discount_tax_compensation_refunded']);
    isQtyDecimal = JsonParser.toInt(json['is_qty_decimal']);
    isVirtual = JsonParser.toInt(json['is_virtual']);
    itemId = JsonParser.toInt(json['item_id']);
    name = JsonParser.toStr(json['name']);
    noDiscount = JsonParser.toInt(json['no_discount']);
    orderId = JsonParser.toInt(json['order_id']);
    originalPrice = JsonParser.toNum(json['original_price']);
    price = JsonParser.toNum(json['price']);
    priceInclTax = JsonParser.toNum(json['price_incl_tax']);
    productId = JsonParser.toInt(json['product_id']);
    productType = JsonParser.toStr(json['product_type']);
    qtyCanceled = JsonParser.toNum(json['qty_canceled']);
    qtyInvoiced = JsonParser.toNum(json['qty_invoiced']);
    qtyOrdered = JsonParser.toNum(json['qty_ordered']);
    qtyRefunded = JsonParser.toNum(json['qty_refunded']);
    qtyShipped = JsonParser.toNum(json['qty_shipped']);
    quoteItemId = JsonParser.toInt(json['quote_item_id']);
    rowInvoiced = JsonParser.toNum(json['row_invoiced']);
    rowTotal = JsonParser.toNum(json['row_total']);
    rowTotalInclTax = JsonParser.toNum(json['row_total_incl_tax']);
    rowWeight = JsonParser.toNum(json['row_weight']);
    sku = JsonParser.toStr(json['sku']);
    storeId = JsonParser.toInt(json['store_id']);
    taxAmount = JsonParser.toNum(json['tax_amount']);
    taxInvoiced = JsonParser.toNum(json['tax_invoiced']);
    taxPercent = JsonParser.toNum(json['tax_percent']);
    taxRefunded = JsonParser.toNum(json['tax_refunded']);
    updatedAt = JsonParser.toStr(json['updated_at']);
    weeeTaxApplied = JsonParser.toStr(json['weee_tax_applied']);
    weight = JsonParser.toNum(json['weight']);
    extensionAttributes = JsonParser.toObject(json['extension_attributes'], ExtensionAttributes.fromJson);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumbnail'] = this.thumbnail;
    data['item_options'] = this.itemOptions;
    data['amount_refunded'] = this.amountRefunded;
    data['applied_rule_ids'] = this.appliedRuleIds;
    data['base_amount_refunded'] = this.baseAmountRefunded;
    data['base_discount_amount'] = this.baseDiscountAmount;
    data['base_discount_invoiced'] = this.baseDiscountInvoiced;
    data['base_discount_refunded'] = this.baseDiscountRefunded;
    data['base_discount_tax_compensation_amount'] =
        this.baseDiscountTaxCompensationAmount;
    data['base_discount_tax_compensation_invoiced'] =
        this.baseDiscountTaxCompensationInvoiced;
    data['base_discount_tax_compensation_refunded'] =
        this.baseDiscountTaxCompensationRefunded;
    data['base_original_price'] = this.baseOriginalPrice;
    data['base_price'] = this.basePrice;
    data['base_price_incl_tax'] = this.basePriceInclTax;
    data['base_row_invoiced'] = this.baseRowInvoiced;
    data['base_row_total'] = this.baseRowTotal;
    data['base_row_total_incl_tax'] = this.baseRowTotalInclTax;
    data['base_tax_amount'] = this.baseTaxAmount;
    data['base_tax_invoiced'] = this.baseTaxInvoiced;
    data['base_tax_refunded'] = this.baseTaxRefunded;
    data['created_at'] = this.createdAt;
    data['discount_amount'] = this.discountAmount;
    data['discount_invoiced'] = this.discountInvoiced;
    data['discount_percent'] = this.discountPercent;
    data['discount_refunded'] = this.discountRefunded;
    data['free_shipping'] = this.freeShipping;
    data['discount_tax_compensation_amount'] =
        this.discountTaxCompensationAmount;
    data['discount_tax_compensation_invoiced'] =
        this.discountTaxCompensationInvoiced;
    data['discount_tax_compensation_refunded'] =
        this.discountTaxCompensationRefunded;
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
    data['tax_refunded'] = this.taxRefunded;
    data['updated_at'] = this.updatedAt;
    data['weee_tax_applied'] = this.weeeTaxApplied;
    data['weight'] = this.weight;
    if (this.extensionAttributes != null) {
      data['extension_attributes'] = this.extensionAttributes!.toJson();
    }
    return data;
  }
}

class ExtensionAttributes {
  String? status;

  ExtensionAttributes({this.status});

  ExtensionAttributes.fromJson(Map<String, dynamic> json) {
    status = JsonParser.toStr(json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

class Payment {
  dynamic accountStatus;
  List<String>? additionalInformation;
  num? amountOrdered;
  num? amountPaid;
  num? amountRefunded;
  num? baseAmountOrdered;
  num? baseAmountPaid;
  num? baseAmountRefunded;
  num? baseShippingAmount;
  num? baseShippingCaptured;
  num? baseShippingRefunded;
  String? ccExpYear;
  dynamic ccLast4;
  String? ccSsStartMonth;
  String? ccSsStartYear;
  int? entityId;
  String? method;
  int? parentId;
  num? shippingAmount;
  num? shippingCaptured;
  num? shippingRefunded;

  Payment(
      {this.accountStatus,
        this.additionalInformation,
        this.amountOrdered,
        this.amountPaid,
        this.amountRefunded,
        this.baseAmountOrdered,
        this.baseAmountPaid,
        this.baseAmountRefunded,
        this.baseShippingAmount,
        this.baseShippingCaptured,
        this.baseShippingRefunded,
        this.ccExpYear,
        this.ccLast4,
        this.ccSsStartMonth,
        this.ccSsStartYear,
        this.entityId,
        this.method,
        this.parentId,
        this.shippingAmount,
        this.shippingCaptured,
        this.shippingRefunded});

  Payment.fromJson(Map<String, dynamic> json) {
    accountStatus = json['account_status'];
    additionalInformation = JsonParser.toStringList(json['additional_information']);
    amountOrdered = JsonParser.toNum(json['amount_ordered']);
    amountPaid = JsonParser.toNum(json['amount_paid']);
    amountRefunded = JsonParser.toNum(json['amount_refunded']);
    baseAmountOrdered = JsonParser.toNum(json['base_amount_ordered']);
    baseAmountPaid = JsonParser.toNum(json['base_amount_paid']);
    baseAmountRefunded = JsonParser.toNum(json['base_amount_refunded']);
    baseShippingAmount = JsonParser.toNum(json['base_shipping_amount']);
    baseShippingCaptured = JsonParser.toNum(json['base_shipping_captured']);
    baseShippingRefunded = JsonParser.toNum(json['base_shipping_refunded']);
    ccExpYear = JsonParser.toStr(json['cc_exp_year']);
    ccLast4 = json['cc_last4'];
    ccSsStartMonth = JsonParser.toStr(json['cc_ss_start_month']);
    ccSsStartYear = JsonParser.toStr(json['cc_ss_start_year']);
    entityId = JsonParser.toInt(json['entity_id']);
    method = JsonParser.toStr(json['method']);
    parentId = JsonParser.toInt(json['parent_id']);
    shippingAmount = JsonParser.toNum(json['shipping_amount']);
    shippingCaptured = JsonParser.toNum(json['shipping_captured']);
    shippingRefunded = JsonParser.toNum(json['shipping_refunded']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_status'] = this.accountStatus;
    data['additional_information'] = this.additionalInformation;
    data['amount_ordered'] = this.amountOrdered;
    data['amount_paid'] = this.amountPaid;
    data['amount_refunded'] = this.amountRefunded;
    data['base_amount_ordered'] = this.baseAmountOrdered;
    data['base_amount_paid'] = this.baseAmountPaid;
    data['base_amount_refunded'] = this.baseAmountRefunded;
    data['base_shipping_amount'] = this.baseShippingAmount;
    data['base_shipping_captured'] = this.baseShippingCaptured;
    data['base_shipping_refunded'] = this.baseShippingRefunded;
    data['cc_exp_year'] = this.ccExpYear;
    data['cc_last4'] = this.ccLast4;
    data['cc_ss_start_month'] = this.ccSsStartMonth;
    data['cc_ss_start_year'] = this.ccSsStartYear;
    data['entity_id'] = this.entityId;
    data['method'] = this.method;
    data['parent_id'] = this.parentId;
    data['shipping_amount'] = this.shippingAmount;
    data['shipping_captured'] = this.shippingCaptured;
    data['shipping_refunded'] = this.shippingRefunded;
    return data;
  }
}