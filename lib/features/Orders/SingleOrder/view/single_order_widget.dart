import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor/features/Orders/SingleOrder/bloc/single_order_event.dart';
import '../../../../common/AppBars.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/country_names.dart';
import '../../../../core/helper/loading_screen.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../SingleOrder/bloc/single_order_state.dart';
import '../../SingleOrder/data/OrderModel.dart';
import '../bloc/single_order_bloc.dart';


//Widget for input

class SingleOrderWidget extends StatefulWidget {

  final String orderId;

  @override
  SingleOrderWidget({
    Key? key, required this.orderId
  }) : super(key: key);

  @override
  State<SingleOrderWidget> createState() => _SingleOrderViewState();
}

class _SingleOrderViewState extends State<SingleOrderWidget> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
  OrderModel? orderModel;
  final fontSize = 16.0;
  DateTime? orderDate;
  @override
  void initState() {
    super.initState();
    context.read<SingleOrderBloc>().add(PerformSingleOrder(orderId: widget.orderId));
    CountryNames.load().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBars(context,_scaffoldKey,AppLocalizations.of(context)!.orders,true,true),
       // drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh:  () async {
            context.read<SingleOrderBloc>().add(PerformSingleOrder(orderId: widget.orderId));
          },
          child: Container(
            child: BlocListener<SingleOrderBloc, SingleOrderState>(
                listener: (context, state) async {
                  if (state is OrderLoading) {
                    LoadingScreen().show(
                      context: context,
                      text: 'Please wait a moment',
                    );
                  } else {
                    LoadingScreen().hide();
                  }
                   if (state is SingleOrderLoaded) {
                    setState(() {
                      orderModel = state.orderModel;
                      orderDate = _parseUtcDate(orderModel?.createdAt);
                    });
                  }
                  if (state is OrderError) {
                    Tools.showSnackBar(ScaffoldMessenger.of(context),state.errorMessage);
                  }
                },
                child:SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Card(
                        elevation: 4.0, // Adds shadow (higher values mean more shadow)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0), // Corner radius
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(AppLocalizations.of(context)!.orderAccountInformation),
                             // _buildRow('Order #', '000000017 (The order confirmation email is not sent)'),
                              _buildRow(AppLocalizations.of(context)!.orderNo, orderModel?.incrementId ?? '', singleLine: true),
                              _buildRow(AppLocalizations.of(context)!.orderDate, orderDate == null ? '' : DateFormat('d MMM yyyy, hh:mm:ss a').format(orderDate!.toLocal())),
                              _buildRow(AppLocalizations.of(context)!.orderstatus, Tools.getOrderStatus(context,orderModel?.status ?? "")),
                              // _buildRow('Purchased From', 'Main Website Store - Arabic'),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 7.0),
                                height: 1, // Set the height to 1 pixel
                                width: double.infinity, // Stretch the line across the width
                                color: Colors.black, // Set your desired color
                              ),
                              _buildRow(AppLocalizations.of(context)!.customerName, orderModel?.customerName ?? ''),
                              _buildRow(AppLocalizations.of(context)!.email, orderModel?.customerEmail ?? ''),
                            //  _buildRow('Customer Group', '${orderModel?.customerGroup}'),
                            ],
                          ),
                        ),
                      ),

                          SizedBox(height: 16),
                          Card(
                            elevation: 4.0, // Adds shadow (higher values mean more shadow)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0), // Corner radius
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionHeader(AppLocalizations.of(context)!.addressInformation),
                                  if(orderModel?.billingAddress != null)
                                  _buildAddress(AppLocalizations.of(context)!.billingAddress, orderModel!.billingAddress!),
                                  if(orderModel?.shippingAddress != null)
                                  _buildAddress(AppLocalizations.of(context)!.shippingAddress, orderModel!.shippingAddress!),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 16),

                          Card(
                            elevation: 4.0, // Adds shadow (higher values mean more shadow)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0), // Corner radius
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionHeader(AppLocalizations.of(context)!.paymentShippingMethod),
                                  _buildRow(AppLocalizations.of(context)!.paymentInformation, _paymentInformation()),
                                  if ((orderModel?.orderCurrencyCode ?? '').isNotEmpty)
                                    _buildRow('', AppLocalizations.of(context)!.orderPlacedInCurrency(orderModel!.orderCurrencyCode!)),
                                  _buildRow(AppLocalizations.of(context)!.shippingHandlingInformation, AppLocalizations.of(context)!.noShippinginformationavailable),
                                ],
                              ),
                            ),
                          ),

                          Card(
                            elevation: 4.0, // Adds shadow (higher values mean more shadow)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0), // Corner radius
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionHeader(AppLocalizations.of(context)!.itemsOrdered),
                                  for ( var item in orderModel?.items ?? [] )  _buildItemsRow(item)
                                ],
                              ),
                            ),
                          ),

                          Card(
                            elevation: 4.0, // Adds shadow (higher values mean more shadow)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0), // Corner radius
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionHeader(AppLocalizations.of(context)!.orderTotal),
                                  _buildOrderTotalRow(AppLocalizations.of(context)!.subtotal, getStringWithCurrencyCode(orderModel?.baseSubtotal, base: true)),
                                  if ((orderModel?.baseDiscountAmount ?? 0) != 0)
                                    _buildOrderTotalRow(AppLocalizations.of(context)!.discount, getStringWithCurrencyCode(orderModel?.baseDiscountAmount, base: true)),
                                  _buildOrderTotalRow(AppLocalizations.of(context)!.shippingHandling, getStringWithCurrencyCode(orderModel?.baseShippingAmount, base: true)),
                                  // Without it the totals did not add up: 500 + 0 shown as 550.
                                  _buildOrderTotalRow(AppLocalizations.of(context)!.tax, getStringWithCurrencyCode(orderModel?.baseTaxAmount, base: true)),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 7.0),
                                    height: 1, // Set the height to 1 pixel
                                    width: double.infinity, // Stretch the line across the width
                                    color: Colors.black, // Set your desired color
                                  ),
                                  _buildOrderTotalRow(AppLocalizations.of(context)!.grandTotal, getStringWithCurrencyCode(orderModel?.baseGrandTotal, base: true)),
                                  _buildOrderTotalRow(AppLocalizations.of(context)!.totalPaid, getStringWithCurrencyCode(orderModel?.baseTotalPaid, base: true)),
                                  _buildOrderTotalRow(AppLocalizations.of(context)!.totalRefunded, getStringWithCurrencyCode(orderModel?.baseTotalRefunded, base: true)),
                                  _buildOrderTotalRow(AppLocalizations.of(context)!.marketplaceCommission, getStringWithCurrencyCode(orderModel?.commission, base: true)),
                                  _buildOrderTotalRow(AppLocalizations.of(context)!.totalDue, getStringWithCurrencyCode(orderModel?.baseTotalDue, base: true)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          // DropdownButtonFormField<String>(
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: 'Status',
                          //   ),
                          //   items: [
                          //     DropdownMenuItem(
                          //       value: 'Under Review',
                          //       child: Text('قيد المراجعة'),
                          //     ),
                          //   ],
                          //   onChanged: (value) {},
                          // ),
                          // SizedBox(height: 16.0),
                          // _buildSectionHeader('Notes for this Order'),
                          // SizedBox(height: 8.0),
                          // TextField(
                          //   maxLines: 3,
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: 'Comment',
                          //   ),
                          // ),
                          // SizedBox(height: 8.0),
                          // Row(
                          //   children: [
                          //     Checkbox(value: false, onChanged: (value) {}),
                          //     Text('Notify Customer by Email'),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     Checkbox(value: false, onChanged: (value) {}),
                          //     Text('Visible on Storefront'),
                          //   ],
                          // ),
                          // SizedBox(height: 16.0),
                          // ElevatedButton(
                          //   onPressed: () {},
                          //   child: Text('Submit Comment'),
                          // ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Padding(
        padding: EdgeInsets.only(top: 8,bottom: 5),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 5),
        height: 1, // Set the height to 1 pixel
        width: double.infinity, // Stretch the line across the width
        color: Colors.black, // Set your desired color
      ),
    ],);
  }

  /// [singleLine] keeps a value such as the order number on one line, shrunk
  /// to fit, instead of wrapping.
  Widget _buildRow(String label, String value, {bool singleLine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 5,),
          Expanded(
            flex: 3,
            child: singleLine
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(value, maxLines: 1),
                  )
                : Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          // The amount keeps its full width: in a quarter of the row,
          // "AED 963,653.00" broke after "AED".
          Text(value, maxLines: 1),
        ],
      ),
    );
  }

  Widget _buildItemsRow(Items item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(AppLocalizations.of(context)!.product, item.name ?? ""),
          _buildRow(AppLocalizations.of(context)!.sku, item.sku ?? ""),
          _buildRow(AppLocalizations.of(context)!.itemStatus, item.extensionAttributes?.status ?? ""),
          _buildRow(AppLocalizations.of(context)!.originalPrice, getStringWithCurrencyCode(item.originalPrice)),
          _buildRow(AppLocalizations.of(context)!.price, getStringWithCurrencyCode(item.price)),
          _buildRow(AppLocalizations.of(context)!.qty, Tools.formatQty(item.qtyOrdered ?? 0)),
          // Subtotal is before tax and Row Total after it, as on the web
          // panel; the two were swapped.
          _buildRow(AppLocalizations.of(context)!.subtotal, getStringWithCurrencyCode(item.rowTotal)),
          _buildRow(AppLocalizations.of(context)!.taxAmount, getStringWithCurrencyCode(item.taxAmount)),
          _buildRow(AppLocalizations.of(context)!.taxPercent, '${Tools.formatQty(item.taxPercent ?? 0)}%'),
          _buildRow(AppLocalizations.of(context)!.discountAmount, getStringWithCurrencyCode(item.discountAmount)),
          _buildRow(AppLocalizations.of(context)!.rowTotal, getStringWithCurrencyCode(item.rowTotalWithTax)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 7.0),
            height: 1, // Set the height to 1 pixel
            width: double.infinity, // Stretch the line across the width
            color: Colors.black, // Set your desired color
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(String title,BillingAddress billingAddress) {
   // String title, String name, String street, String postalCode, String city, String phone
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text([billingAddress.firstname, billingAddress.lastname].whereType<String>().join(' ')),
        Text(billingAddress.street?.join(', ') ?? ''),
        // Region and country were left out: an address the vendor could not
        // ship to.
        Text([billingAddress.city, billingAddress.region, billingAddress.postcode]
            .whereType<String>().where((part) => part.trim().isNotEmpty).join(', ')),
        if ((billingAddress.countryId ?? '').isNotEmpty)
          Text(CountryNames.of(billingAddress.countryId) ?? billingAddress.countryId!),
        Text('T: ${billingAddress.telephone ?? ''}'),
        SizedBox(height: 8),
      ],
    );
  }

  /// Order totals are base_* amounts ([base]); item prices are in the order
  /// currency. Both used to be labelled EGP whatever the order was in.
  String getStringWithCurrencyCode(dynamic amount, {bool base = false}){
    final currency = base
        ? (orderModel?.baseCurrencyCode ?? orderModel?.orderCurrencyCode)
        : (orderModel?.orderCurrencyCode ?? orderModel?.baseCurrencyCode);
    return Tools.getCurrencyCode(amount ?? 0, currency: currency);
  }

  String _paymentInformation() {
    final info = orderModel?.payment?.additionalInformation;
    if (info != null && info.isNotEmpty) return info.first;
    return orderModel?.paymentMethod ?? '';
  }

  /// Magento sends created_at as UTC without a zone, e.g. "2026-09-13 12:47:22".
  DateTime? _parseUtcDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse('${value}Z') ?? DateTime.tryParse(value);
  }

}