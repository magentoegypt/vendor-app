import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/AppBars.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/loading_screen.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../../home/view/vendor_order_list.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_bloc.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_event.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_state.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orderListModel.dart';

//Widget for input

class OrdersWidget extends StatefulWidget {

  @override
  OrdersWidget({
    Key? key
  }) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersWidget> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
  List<OrderModel>? orderList;

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(PerformOrdersList(query: 'searchCriteria[pageSize]=20'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBars(context,_scaffoldKey,AppLocalizations.of(context)!.orders,true,true),
       // drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh:  () async {
            context.read<OrdersBloc>().add(PerformOrdersList(query: 'searchCriteria[pageSize]=20'));
          },
          child: Container(
            child: BlocListener<OrdersBloc, OrdersState>(
                listener: (context, state) async {
                  if (state is OrdersLoading) {
                    LoadingScreen().show(
                      context: context,
                      text: 'Please wait a moment',
                    );
                  } else {
                    LoadingScreen().hide();
                  }
                   if (state is OrderLoaded) {
                    setState(() {
                      orderList = state.orderListModel.items;
                    });
                  }
                  if (state is OrderError) {
                    Tools.showSnackBar(ScaffoldMessenger.of(context),state.errorMessage);
                  }
                },
                child:SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          VendorOrderList(
                            orders:orderList ?? [], isAllOrder: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }

}