import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/Products/ProductList/view/product_list_card_widget.dart';
import '../../../../common/AppBars.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/loading_screen.dart';
import '../../CreateEditProduct/view/create_edit_product_widget.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../data/productListModel.dart';



//Widget for input

class ProductsWidget extends StatefulWidget {


  @override
  ProductsWidget({
    Key? key
  }) : super(key: key);

  @override
  State<ProductsWidget> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsWidget> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ProductItem>? products;

  /// Why the list could not be loaded, shown with a Retry button while there
  /// is no list to show.
  String? _error;

  // Every load asks for the same page: reloading with 20 after an edit left
  // out the rest of a bigger catalogue.
  void _load() => context
      .read<ProductsBloc>()
      .add(const PerformProductList(query: 'searchCriteria[pageSize]=100'));

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBars(context,_scaffoldKey,AppLocalizations.of(context)!.products,true,true),
        // drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh:  () async => _load(),
          child: Container(

            child: BlocListener<ProductsBloc, ProductsState>(
                listener: (context, state) async {
                  if (state is ProductsLoading) {
                    LoadingScreen().show(
                      context: context,
                      text: 'Please wait a moment',
                    );
                  } else {
                    LoadingScreen().hide();
                  }
                  if (state is ProductsLoaded) {
                    setState(() {
                      products = state.productListModel.products;
                      _error = null;
                    });
                  }
                  if (state is ProductsError) {
                    if (products == null && state.errorMessage.trim().isNotEmpty) {
                      setState(() => _error = state.errorMessage);
                    } else {
                      // A refresh failed: keep the list that is showing.
                      Tools.showSnackBar(ScaffoldMessenger.of(context),state.errorMessage);
                    }
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
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => CreateEditProductWidget(productSku: '',))).then((value) => _load());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.add,size: 20,),
                                Text(
                                  AppLocalizations.of(context)!.addProduct,
                                  style: Theme.of(context).textTheme.titleSmall,)
                              ],
                            ),
                          ),
                          ...List.generate(
                            products?.length ?? 0,
                                (index) {
                              return VendorAdminProductListCardWidget(
                                product: products?[index],
                                onTap: (){
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => CreateEditProductWidget(productSku: products?[index].sku ?? '',))).then((value) => _load());
                                },
                              );
                            },
                          ),
                          if (_error != null && products == null) _errorView(context),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }

  Widget _errorView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, size: 48, color: Theme.of(context).disabledColor),
          const SizedBox(height: 12),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            key: const Key('productsRetry'),
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }
}
