import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/AppBars.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/helper/loading_screen.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../../home/view/vendor_order_list.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_bloc.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_event.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_state.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orderListModel.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/order_pages.dart';

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
  final ScrollController _scroll = ScrollController();
  List<OrderModel> orderList = [];

  /// Orders come a page at a time, newest first; scrolling near the end
  /// loads the next, older page. The list used to stop at the first 20.
  static const _pageSize = 20;
  int _page = 1;
  bool _loadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _load(1);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _load(int page) {
    _page = page;
    _loadingMore = page > 1;
    context.read<OrdersBloc>().add(PerformOrdersList(
        query: 'searchCriteria[pageSize]=$_pageSize&searchCriteria[currentPage]=$page&$newestOrdersFirst'));
  }

  void _onScroll() {
    if (_hasMore && !_loadingMore && _scroll.position.extentAfter < 400) {
      _load(_page + 1);
    }
  }

  void _showPage(OrderListModel model) {
    final result = addOrderPage(orderList, model, pageNumber: _page, pageSize: _pageSize);
    orderList = result.orders;
    _hasMore = result.hasMore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBars(context,_scaffoldKey,AppLocalizations.of(context)!.orders,true,true),
       // drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh:  () async {
            _load(1);
          },
          child: Container(
            child: BlocListener<OrdersBloc, OrdersState>(
                listener: (context, state) async {
                  // The next page shows a spinner under the list instead.
                  if (state is OrdersLoading) {
                    if (!_loadingMore) {
                      LoadingScreen().show(
                        context: context,
                        text: 'Please wait a moment',
                      );
                    }
                  } else {
                    LoadingScreen().hide();
                  }
                   if (state is OrderLoaded) {
                    setState(() {
                      _showPage(state.orderListModel);
                      _loadingMore = false;
                    });
                  }
                  if (state is OrderError) {
                    setState(() => _loadingMore = false);
                    Tools.showSnackBar(ScaffoldMessenger.of(context),state.errorMessage);
                  }
                },
                child:SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      controller: _scroll,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          VendorOrderList(
                            orders:orderList, isAllOrder: true,
                          ),
                          if (_loadingMore)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
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
