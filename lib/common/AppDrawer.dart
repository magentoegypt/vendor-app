
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/features/home/view/dashboard_widget.dart';
import '../core/config/colors.dart';
import '../core/config/locator.dart';
import '../features/Products/ProductList/view/products_widget.dart';
import '../core/helper/shared_preferences_helpers.dart';
import '../features/Orders/OrderList/view/orders_widget.dart';
import '../features/home/data/UserModel.dart';
import '../features/profile/view/profile_view.dart';
import '../main.dart';


typedef  OnNavigationItemSelect(int index);
UserModel? userModel;
class AppDrawer extends StatelessWidget {
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
  final OnNavigationItemSelect? onNavigationItemSelect;

   AppDrawer({Key? key, this.onNavigationItemSelect})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Painted by the drawer's own Material: a coloured Container here would
      // cover the ListTile ink splashes (Flutter 3.44 asserts on that).
      backgroundColor: AppColors.primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context,false),
          Divider(color: Colors.white,),
          _createDrawerItem(context: context, icon: Icons.person, text: AppLocalizations.of(context)!.sellerProfile,index: 1, onTap: () {onNavigationItemSelect!(1);  }),
          _createDrawerItem(context: context, icon: Icons.card_travel, text: AppLocalizations.of(context)!.products,index: 2, onTap: () {onNavigationItemSelect!(2);  }),
          _createDrawerItem(context: context,icon: Icons.account_balance_wallet, text: AppLocalizations.of(context)!.orders,index: 3, onTap: () {onNavigationItemSelect!(3);  }),
          _createDrawerItem(context: context,icon: Icons.settings, text: AppLocalizations.of(context)!.changeLanguage,index: 4, onTap: () {onNavigationItemSelect!(4);  }),
         // _createDrawerItem(icon: Icons.logout, text: AppLocalizations.of(context)!.logout,index: 4, onTap: () {onNavigationItemSelect!(4);  }),
          // ListTile(title: Text('0.0.1'), onTap: () {},),
        ],
      ),
    );
  }

  void _showSimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                MainApp.setLocale(context, Locale("en", ""));
              },
              child: Text('English'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle Option 2 action
                MainApp.setLocale(context, Locale("ar", ""));
              },
              child: Text('عربي'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  Widget _createHeader(BuildContext context,bool isUpdate) {
    if(userModel == null || isUpdate){
      _sharedPrefKeys.getUser().then((object) {
        userModel = object;
      });
    }

    return Center(
      child: FutureBuilder<UserModel>(
        future: _sharedPrefKeys.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: InkWell(
                  onTap: (){
                    // The dashboard builds AppDrawer() without a callback.
                    onNavigationItemSelect?.call(0);
                  },
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20,bottom: 10),
                      child: CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage("assets/icons/icon-user.png")),
                    ),
                    Divider(height: 5,color: Colors.transparent,),
                    Text(
                      "${snapshot.data?.firstname ?? ""} ${snapshot.data?.lastname ?? ""}",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme.primary,fontSize: 17),
                    ),
                  ]),
                )
            );
          }
        },
      ),
    );

  }

  Widget _createDrawerItem(

      {required BuildContext context,required IconData icon, required String text, required GestureTapCallback onTap, required int index}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0,right: 8),
            child: Text(text),
          )
        ],
      ),
      onTap: () {
        if(index == 1){
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) =>  ProfileViewWidget(userModel: userModel,))).then((value){
            _createHeader(context,true);
          });
        }else if(index == 2){
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => ProductsWidget()));
        }else if(index == 3){
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => OrdersWidget()));
        }else if(index == 4){
          _showSimpleDialog(context);
        }
       // onNavigationItemSelect!(index);
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    throw UnimplementedError();
  }

}