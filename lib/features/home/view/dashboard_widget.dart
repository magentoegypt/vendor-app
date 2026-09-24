import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/pref_keys.dart';
import '../../../core/config/tools.dart';
import '../../../features/home/data/DashboarModel.dart';
import '../../../features/home/view/sale_stats_chart.dart';
import '../../../features/home/view/sale_stats_widget.dart';
import '../../../features/home/view/vendor_order_list.dart';
import '../../../common/AppBars.dart';
import '../../../common/AppDrawer.dart';
import '../../../core/config/locator.dart';
import '../../../core/helper/loading_screen.dart';
import '../../../core/helper/shared_preferences_helpers.dart';
import '../../Orders/OrderList/data/orderListModel.dart';
import '../bloc/dashboard_bloc.dart';

//Widget for input

class DashboardWidget extends StatefulWidget {

  @override
  const DashboardWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardWidget> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
  DashboarModel? dashboardModel;
  List<OrderModel>? orderList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DashboardBloc>().add(const PerformDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBars(context,_scaffoldKey,AppLocalizations.of(context)!.dashboard,false,true),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh:  () async {
            context.read<DashboardBloc>().add(PerformDashboard());
          },
          child: Container(
            child: BlocListener<DashboardBloc, DasboardState>(
                listener: (context, state) async {
                  if (state is DashboardLoading) {
                    LoadingScreen().show(
                      context: context,
                      text: 'Please wait a moment',
                    );
                  } else {
                    LoadingScreen().hide();
                  }
                  if (state is DashboardLoaded) {
                    setState(() {
                      dashboardModel = state.dashboarModel;
                      context.read<DashboardBloc>().add(PerformUserDetail());
                      context.read<DashboardBloc>().add(PerformOrderList(query: 'searchCriteria[pageSize]=5'));
                    });
                  }else if (state is UserLoaded) {
                    setState(() {
                      _sharedPrefKeys.setStringData(key: userPrefKey, text:  jsonEncode(state.userModel.toJson()));
                    });
                  }else if (state is OrderLoaded) {
                  setState(() {
                    orderList = state.orderListModel.items;
                  });
                  }
                  if (state is DashboardError) {
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
                          const SizedBox(
                            height: 10.0,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 15),
                              SaleStatsWidget(
                                gradient: const LinearGradient(
                                    begin: Alignment(-1, -1),
                                    end: Alignment(1, 1),
                                    tileMode: TileMode.clamp,
                                    colors: [
                                      Color(0xFF1FF7FD),
                                      Color(0xFFB33BF6),
                                      Color(0xFFFF844B),
                                      // Color(0xFFFF844B),
                                    ],
                                    stops: [
                                      -0.4,
                                      0.4,
                                      1.0,
                                    ]),
                                title: AppLocalizations.of(context)!.creditAmount,
                                amount: dashboardModel?.creditAmount ?? "",
                              ),
                              SizedBox(width: 10),
                              SaleStatsWidget(
                                title: AppLocalizations.of(context)!.lifetimeSales,
                                amount: dashboardModel?.lifetimeSales ?? "",
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 15),
                              SaleStatsWidget(
                                gradient: const LinearGradient(
                                    begin: Alignment(-1, -1),
                                    end: Alignment(1, 1),
                                    tileMode: TileMode.clamp,
                                    colors: [
                                      Color(0xFF1FF7FD),
                                      Color(0xFFB33BF6),
                                      Color(0xFFFF844B),
                                      // Color(0xFFFF844B),
                                    ],
                                    stops: [
                                      -0.4,
                                      0.4,
                                      1.0,
                                    ]),
                                title: AppLocalizations.of(context)!.averageOrders,
                                amount: dashboardModel?.averageOrders ?? "",
                              ),
                              SizedBox(width: 10),
                              SaleStatsWidget(
                                title: AppLocalizations.of(context)!.totalProducts,
                                amount: (dashboardModel?.totalProducts ?? "").toString(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SaleStatsChart(key: UniqueKey(), saleStats: dashboardModel?.orderChartData ?? []),
                          const SizedBox(
                            height: 20.0,
                          ),
                          VendorOrderList(
                            orders:orderList ?? [], isAllOrder: false,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }


}
