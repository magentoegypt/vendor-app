import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../common/flux_image.dart';
import '../../../../core/config/app_constants.dart';
import '../../CreateEditProduct/view/create_edit_product_widget.dart';
import '../data/productListModel.dart';



class VendorAdminProductListCardWidget extends StatelessWidget {
  final ProductItem? product;
  final onTap;

  const VendorAdminProductListCardWidget({super.key, this.product,this.onTap});




  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: FluxImage(
                  imageUrl: product?.thumbnailUrl ?? kDefaultImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 5.0),
                  Text(
                    product!.name!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${Tools.getCurrencyCode(product?.price ?? 0)}",
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text('${AppLocalizations.of(context)!.qty}: ${product!.qty ?? 0}',
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ),
                        Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Text((getProductType(context,product!.typeId ??"")).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getProductType(BuildContext context, String type){
    if(type.toLowerCase() == "simple"){
      return AppLocalizations.of(context)!.simple;
    }else if(type.toLowerCase() == "virtual"){
      return AppLocalizations.of(context)!.virtual;
    }
    return type;
  }
}
