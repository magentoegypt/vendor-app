
class OrderModel {
  int? commission;
  int? entityId;
  int? vendorId;
  int? orderId;
  String? status;
  int? baseDiscountAmount;
  int? baseGrandTotal;
  int? baseShippingInvoiced;
  int? baseShippingRefunded;
  int? baseShippingAmount;
  int? baseShippingTaxAmount;
  int? baseShippingTaxRefunded;
  int? baseSubtotal;
  int? baseTotalInvoiced;
  int? baseTotalPaid;
  int? baseTotalRefunded;
  int? baseTaxAmount;
  int? discountAmount;
  int? grandTotal;
  int? shippingAmount;
  int? shippingInvoiced;
  int? shippingRefunded;
  int? shippingTaxAmount;
  int? shippingTaxRefunded;
  int? subtotal;
  int? taxAmount;
  int? totalInvoiced;
  int? totalPaid;
  int? totalQtyOrdered;
  int? totalRefunded;
  int? taxRefunded;
  int? baseTaxRefunded;
  int? taxInvoiced;
  int? baseTaxInvoiced;
  int? subtotalInclTax;
  int? baseSubtotalInclTax;
  int? weight;
  String? createdAt;
  String? updatedAt;
  int? shippingInclTax;
  int? baseShippingInclTax;
  int? totalDue;
  int? baseTotalDue;
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
    commission = json['commission'];
    entityId = json['entity_id'];
    vendorId = json['vendor_id'];
    orderId = json['order_id'];
    status = json['status'];
    baseDiscountAmount = json['base_discount_amount'];
    baseGrandTotal = json['base_grand_total'];
    baseShippingInvoiced = json['base_shipping_invoiced'];
    baseShippingRefunded = json['base_shipping_refunded'];
    baseShippingAmount = json['base_shipping_amount'];
    baseShippingTaxAmount = json['base_shipping_tax_amount'];
    baseShippingTaxRefunded = json['base_shipping_tax_refunded'];
    baseSubtotal = json['base_subtotal'];
    baseTotalInvoiced = json['base_total_invoiced'];
    baseTotalPaid = json['base_total_paid'];
    baseTotalRefunded = json['base_total_refunded'];
    baseTaxAmount = json['base_tax_amount'];
    discountAmount = json['discount_amount'];
    grandTotal = json['grand_total'];
    shippingAmount = json['shipping_amount'];
    shippingInvoiced = json['shipping_invoiced'];
    shippingRefunded = json['shipping_refunded'];
    shippingTaxAmount = json['shipping_tax_amount'];
    shippingTaxRefunded = json['shipping_tax_refunded'];
    subtotal = json['subtotal'];
    taxAmount = json['tax_amount'];
    totalInvoiced = json['total_invoiced'];
    totalPaid = json['total_paid'];
    totalQtyOrdered = json['total_qty_ordered'];
    totalRefunded = json['total_refunded'];
    taxRefunded = json['tax_refunded'];
    baseTaxRefunded = json['base_tax_refunded'];
    taxInvoiced = json['tax_invoiced'];
    baseTaxInvoiced = json['base_tax_invoiced'];
    subtotalInclTax = json['subtotal_incl_tax'];
    baseSubtotalInclTax = json['base_subtotal_incl_tax'];
    weight = json['weight'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shippingInclTax = json['shipping_incl_tax'];
    baseShippingInclTax = json['base_shipping_incl_tax'];
    totalDue = json['total_due'];
    baseTotalDue = json['base_total_due'];
    billingName = json['billing_name'];
    shippingName = json['shipping_name'];
    billingAddress = json['billing_address'] != null
        ? new BillingAddress.fromJson(json['billing_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? new BillingAddress.fromJson(json['shipping_address'])
        : null;
    customerEmail = json['customer_email'];
    customerGroup = json['customer_group'];
    shippingAndHandling = json['shipping_and_handling'];
    customerName = json['customer_name'];
    paymentMethod = json['payment_method'];
    baseCurrencyCode = json['base_currency_code'];
    orderCurrencyCode = json['order_currency_code'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    payment =
    json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    canCancel = json['can_cancel'];
    canInvoice = json['can_invoice'];
    canShip = json['can_ship'];
    canCreditMemo = json['can_credit_memo'];
    incrementId = json['increment_id'];
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
    addressType = json['address_type'];
    city = json['city'];
    company = json['company'];
    countryId = json['country_id'];
    customerAddressId = json['customer_address_id'];
    email = json['email'];
    entityId = json['entity_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    parentId = json['parent_id'];
    postcode = json['postcode'];
    street = json['street'].cast<String>();
    telephone = json['telephone'];
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
  Null? itemOptions;
  int? amountRefunded;
  String? appliedRuleIds;
  int? baseAmountRefunded;
  int? baseDiscountAmount;
  int? baseDiscountInvoiced;
  int? baseDiscountRefunded;
  int? baseDiscountTaxCompensationAmount;
  int? baseDiscountTaxCompensationInvoiced;
  int? baseDiscountTaxCompensationRefunded;
  int? baseOriginalPrice;
  int? basePrice;
  int? basePriceInclTax;
  int? baseRowInvoiced;
  int? baseRowTotal;
  int? baseRowTotalInclTax;
  int? baseTaxAmount;
  int? baseTaxInvoiced;
  int? baseTaxRefunded;
  String? createdAt;
  int? discountAmount;
  int? discountInvoiced;
  int? discountPercent;
  int? discountRefunded;
  int? freeShipping;
  int? discountTaxCompensationAmount;
  int? discountTaxCompensationInvoiced;
  int? discountTaxCompensationRefunded;
  int? isQtyDecimal;
  int? isVirtual;
  int? itemId;
  String? name;
  int? noDiscount;
  int? orderId;
  int? originalPrice;
  int? price;
  int? priceInclTax;
  int? productId;
  String? productType;
  int? qtyCanceled;
  int? qtyInvoiced;
  int? qtyOrdered;
  int? qtyRefunded;
  int? qtyShipped;
  int? quoteItemId;
  int? rowInvoiced;
  int? rowTotal;
  int? rowTotalInclTax;
  int? rowWeight;
  String? sku;
  int? storeId;
  int? taxAmount;
  int? taxInvoiced;
  int? taxPercent;
  int? taxRefunded;
  String? updatedAt;
  String? weeeTaxApplied;
  int? weight;
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
    thumbnail = json['thumbnail'];
    itemOptions = json['item_options'];
    amountRefunded = json['amount_refunded'];
    appliedRuleIds = json['applied_rule_ids'];
    baseAmountRefunded = json['base_amount_refunded'];
    baseDiscountAmount = json['base_discount_amount'];
    baseDiscountInvoiced = json['base_discount_invoiced'];
    baseDiscountRefunded = json['base_discount_refunded'];
    baseDiscountTaxCompensationAmount =
    json['base_discount_tax_compensation_amount'];
    baseDiscountTaxCompensationInvoiced =
    json['base_discount_tax_compensation_invoiced'];
    baseDiscountTaxCompensationRefunded =
    json['base_discount_tax_compensation_refunded'];
    baseOriginalPrice = json['base_original_price'];
    basePrice = json['base_price'];
    basePriceInclTax = json['base_price_incl_tax'];
    baseRowInvoiced = json['base_row_invoiced'];
    baseRowTotal = json['base_row_total'];
    baseRowTotalInclTax = json['base_row_total_incl_tax'];
    baseTaxAmount = json['base_tax_amount'];
    baseTaxInvoiced = json['base_tax_invoiced'];
    baseTaxRefunded = json['base_tax_refunded'];
    createdAt = json['created_at'];
    discountAmount = json['discount_amount'];
    discountInvoiced = json['discount_invoiced'];
    discountPercent = json['discount_percent'];
    discountRefunded = json['discount_refunded'];
    freeShipping = json['free_shipping'];
    discountTaxCompensationAmount = json['discount_tax_compensation_amount'];
    discountTaxCompensationInvoiced =
    json['discount_tax_compensation_invoiced'];
    discountTaxCompensationRefunded =
    json['discount_tax_compensation_refunded'];
    isQtyDecimal = json['is_qty_decimal'];
    isVirtual = json['is_virtual'];
    itemId = json['item_id'];
    name = json['name'];
    noDiscount = json['no_discount'];
    orderId = json['order_id'];
    originalPrice = json['original_price'];
    price = json['price'];
    priceInclTax = json['price_incl_tax'];
    productId = json['product_id'];
    productType = json['product_type'];
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
    sku = json['sku'];
    storeId = json['store_id'];
    taxAmount = json['tax_amount'];
    taxInvoiced = json['tax_invoiced'];
    taxPercent = json['tax_percent'];
    taxRefunded = json['tax_refunded'];
    updatedAt = json['updated_at'];
    weeeTaxApplied = json['weee_tax_applied'];
    weight = json['weight'];
    extensionAttributes = json['extension_attributes'] != null
        ? new ExtensionAttributes.fromJson(json['extension_attributes'])
        : null;
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
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

class Payment {
  Null? accountStatus;
  List<String>? additionalInformation;
  int? amountOrdered;
  int? amountPaid;
  int? amountRefunded;
  int? baseAmountOrdered;
  int? baseAmountPaid;
  int? baseAmountRefunded;
  int? baseShippingAmount;
  int? baseShippingCaptured;
  int? baseShippingRefunded;
  String? ccExpYear;
  Null? ccLast4;
  String? ccSsStartMonth;
  String? ccSsStartYear;
  int? entityId;
  String? method;
  int? parentId;
  int? shippingAmount;
  int? shippingCaptured;
  int? shippingRefunded;

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
    additionalInformation = json['additional_information'].cast<String>();
    amountOrdered = json['amount_ordered'];
    amountPaid = json['amount_paid'];
    amountRefunded = json['amount_refunded'];
    baseAmountOrdered = json['base_amount_ordered'];
    baseAmountPaid = json['base_amount_paid'];
    baseAmountRefunded = json['base_amount_refunded'];
    baseShippingAmount = json['base_shipping_amount'];
    baseShippingCaptured = json['base_shipping_captured'];
    baseShippingRefunded = json['base_shipping_refunded'];
    ccExpYear = json['cc_exp_year'];
    ccLast4 = json['cc_last4'];
    ccSsStartMonth = json['cc_ss_start_month'];
    ccSsStartYear = json['cc_ss_start_year'];
    entityId = json['entity_id'];
    method = json['method'];
    parentId = json['parent_id'];
    shippingAmount = json['shipping_amount'];
    shippingCaptured = json['shipping_captured'];
    shippingRefunded = json['shipping_refunded'];
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