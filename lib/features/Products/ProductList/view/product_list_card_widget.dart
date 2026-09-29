import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../common/flux_image.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../CreateEditProduct/view/create_edit_product_widget.dart';
import '../data/productListModel.dart';



class VendorAdminProductListCardWidget extends StatelessWidget {
  final ProductItem? product;
  final onTap;

  const VendorAdminProductListCardWidget({super.key, this.product,this.onTap});

  /// Types whose price and stock belong to their options or parts, so the
  /// product's own price is 0 and its qty 0 (the store shows "from" prices).
  static const compositeTypes = {'configurable', 'grouped', 'bundle'};

  /// The original file of the image listings use (thumbnail, then
  /// small_image, then the main image, then the first one). thumbnail_url is
  /// a small copy the server pads to a square with white, which showed blurred
  /// and with white bars above and below.
  static String? listImageUrl(ProductItem? product) {
    final entries = (product?.mediaGalleryEntries ?? const <MediaGalleryEntries>[])
        .where((e) => e.disabled != true && (e.file ?? '').isNotEmpty)
        .toList()
      ..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));
    for (final role in const ['thumbnail', 'small_image', 'image']) {
      for (final entry in entries) {
        if (entry.types?.contains(role) ?? false) return '$baseProductImageUrl${entry.file}';
      }
    }
    if (entries.isNotEmpty) return '$baseProductImageUrl${entries.first.file}';
    return product?.thumbnailUrl;
  }

  @override
  Widget build(BuildContext context) {
    final composite = compositeTypes.contains(product?.typeId?.toLowerCase());
    final showPrice = !composite || (product?.price ?? 0) > 0;

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
                  imageUrl: listImageUrl(product) ?? kDefaultImage,
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
                    product?.name ?? '',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (showPrice)
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
                        child: composite
                            ? const SizedBox()
                            : Text('${AppLocalizations.of(context)!.qty}: ${Tools.formatQty(product?.qty ?? 0)}',
                                style: const TextStyle(fontSize: 12.0),
                              ),
                      ),
                        // One line: a fixed 80 px broke "DOWNLOADABLE" in two.
                        Container(
                          constraints: const BoxConstraints(minWidth: 80, maxWidth: 130),
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            widthFactor: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text((getProductType(context,product?.typeId ?? "")).toUpperCase(),
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
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
    final texts = AppLocalizations.of(context)!;
    switch (type.toLowerCase()) {
      case "simple":
        return texts.simple;
      case "virtual":
        return texts.virtual;
      case "downloadable":
        return texts.downloadable;
      case "configurable":
        return texts.configurable;
      case "grouped":
        return texts.grouped;
      case "bundle":
        return texts.bundle;
    }
    return type;
  }
}
