import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor/core/config/locator.dart';
import '../../../../core/config/tools.dart';
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
                    Text(
                      '#${order.orderId}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                       DateFormat('MM/dd/yyyy').format(Tools.stringtoDate(order.createdAt ?? "", "yyyy-MM-dd HH:mm:ss")),
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
                  child: Text("${Tools.getCurrencyCode(order.grandTotal ?? 0)}",
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
