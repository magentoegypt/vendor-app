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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ProductsBloc>().add(PerformProductList(query: 'searchCriteria[pageSize]=100'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBars(context,_scaffoldKey,AppLocalizations.of(context)!.products,true,true),
        // drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh:  () async {
            context.read<ProductsBloc>().add(PerformProductList(query: 'searchCriteria[pageSize]=50'));
          },
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
                    });
                  }
                  if (state is ProductsError) {
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
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => CreateEditProductWidget(productSku: '',))).then((value) {
                                context.read<ProductsBloc>().add(PerformProductList(query: 'searchCriteria[pageSize]=20'));
                              });
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
                                      builder: (context) => CreateEditProductWidget(productSku: products?[index].sku ?? '',))).then((value) {
                                    context.read<ProductsBloc>().add(const PerformProductList(query: 'searchCriteria[pageSize]=20'));
                                  });
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }


}
