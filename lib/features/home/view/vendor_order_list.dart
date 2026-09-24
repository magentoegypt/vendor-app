import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/config/locator.dart';
import '../../Orders/OrderList/data/orderListModel.dart';
import '../../Orders/OrderList/view/order_item.dart';
import '../../Orders/OrderList/view/orders_widget.dart';



class VendorOrderList extends StatelessWidget {
  final List<OrderModel> orders;
  final bool isAllOrder;
  final int? maxOrder;

  const VendorOrderList({
    super.key,
    required this.orders,
    required this.isAllOrder,
    this.maxOrder,
  });

  @override
  Widget build(BuildContext context) {
    int? maxOrderLength = 0;
    if (maxOrder != null && orders.isNotEmpty) {
      if (orders.length >= maxOrder!) {
        maxOrderLength = maxOrder;
      } else {
        maxOrderLength = orders.length;
      }
    } else if (orders.isNotEmpty) {
      maxOrderLength = orders.length;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).primaryColorLight,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        children: [
          if(!isAllOrder)
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.allOrders,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const Expanded(
                  child: SizedBox(
                width: 1,
              )),
              Expanded(
                child: GestureDetector(
                  key: const Key('seeAllOrdersButton'),
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => OrdersWidget()));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.seeAll,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.orderNo,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.orderstatus,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.total,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
            Column(
              children: List.generate(
                  maxOrderLength!,
                  (index) => OrderItem(
                        order: orders[index],
                        onCallBack: (String status, String customerNote) {

                        },
                      )),
            ),
        ],
      ),
    );
  }


}
