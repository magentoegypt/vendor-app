import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor/core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/store_time.dart';
import '../../SingleOrder/view/single_order_widget.dart';
import '../data/orderListModel.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;
  final Function(String, String)? onCallBack;

  const OrderItem({
    super.key,
    required this.order,
    this.onCallBack,
  });

  @override
  Widget build(BuildContext context) {
    // The store's date, as on the web panel: created_at is UTC, so orders
    // placed just after midnight in Riyadh showed the day before.
    final placed = StoreTime.of(order.createdAt);

    return InkWell(
      onTap: onCallBack != null
          ? () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => SingleOrderWidget(
              orderId: '${order.entityId ?? 0}',
            ),
          ),
        );
      }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // One line, shrunk to fit its third of the row: the
                    // 10-digit number broke as "#30000001" / "48".
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        // The order number the vendor, customer and web panel
                        // use (3000000044), not the internal id (137).
                        '#${order.incrementId ?? order.orderId}',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      placed == null ? '' : DateFormat('MM/dd/yyyy').format(placed),
                      style: const TextStyle(fontSize: 10.0),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.person,
                          size: 12.0,
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: Text(
                            order.customerName ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Text(
                    Tools.getOrderStatus(context,order.status ?? ""),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12.0),
              )),
              Expanded(
                  child: Text("${Tools.getCurrencyCode(order.grandTotal ?? 0, currency: order.orderCurrencyCode)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12.0),
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(height: 1),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

}
