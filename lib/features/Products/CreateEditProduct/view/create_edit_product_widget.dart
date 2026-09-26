import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor/common/AppDrawer.dart';
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/view/widgets/ImagePicker.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/view/widgets/list_image_select.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/view/widgets/product_date_widget.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/view/widgets/product_info_dropdown.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/view/widgets/product_switch_button.dart';
import 'package:multi_vendor/features/Products/ProductList/data/productListModel.dart';
import '../../../../common/AppBars.dart';
import '../../../../common/edit_product_info_widget.dart';
import '../../../../core/config/categories_tree/flutter_tree.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/helper/loading_screen.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../../../core/utils/json_parser.dart';
import '../../../../core/utils/numeric_input_formatter.dart';
import '../../../../core/utils/product_url_key.dart';
import '../bloc/create_edit_product_bloc.dart';
import '../bloc/create_edit_product_event.dart';
import '../bloc/create_edit_product_state.dart';
import '../data/ProductAttributeModel.dart';
import '../data/ProductAttributeSetList.dart';




//Widget for input

class CreateEditProductWidget extends StatefulWidget {

   final String productSku;

  @override
  CreateEditProductWidget({
    Key? key,required this.productSku
  }) : super(key: key);

  @override
  State<CreateEditProductWidget> createState() => _CreateEditProductViewState();
}

class _CreateEditProductViewState extends State<CreateEditProductWidget> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
  List<ProductAttributeModel> list = [];
  List<ProductAttributeSetList> attributelist = [];
  List<String> attributes = [];
  ProductItem? productItem;
  var attributeSetId = 4;
  ProductAttributeModel attributeproductAttributeModel = ProductAttributeModel();
  ProductAttributeModel quantityAttributeModel = ProductAttributeModel();
  ProductAttributeModel galleryproductAttributeModel = ProductAttributeModel();
  // "approval" is the admin's decision: the web vendor panel does not offer
  // it, and new products are queued as Pending New without it.
  List<String> skipAttributeName = ["approval","credit_type","credit_value_fixed","credit_value_dropdown",
    "credit_value_custom","credit_price","credit_rate","links_exist","quantity_and_stock_status","select_from_product_id",
    "links_title","samples_title","links_purchased_separately","image_label","shipment_type","page_layout",
    "special_price","gift_message_available","extragallery_glr_type","mgs_template","mgs_image_dimention",
    "mgs_image_dimention_more_view","mgs_j360","custom_design","special_from_date","special_to_date","cost",
    "custom_layout","tier_price","price_type","msrp","msrp_display_actual_price_type","minimal_price","price_view",
    "options_container","custom_layout_update_file","custom_layout_update","old_id","weight_type","sku_type",
    "vendor_id","custom_design_to","custom_design_from","news_from_date","news_to_date","small_image_label","thumbnail_label",
    "mgs_lookbook","product_page_type","product_image_size","custom_block","custom_block_2","tax_class_id","meta_keyword","meta_title",
    "meta_description","visibility","ves_enable_order","ves_enable_quote","sw_featured","is_featured","category_ids","url_key","ves_category_ids",""];

  List<Map<String, dynamic>> treeListData = [];

  //默认数据
  List<Map<String, dynamic>> initialTreeData = [];

  List<String> category_ids = [];

  bool isRTL = false;
  bool isExpanded = true;

  /// One controller per attribute, kept across rebuilds. Creating them in
  /// build() replaced the field's controller on every rebuild (each frame of
  /// the keyboard animation), which reset the text and cursor while typing.
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(ProductAttributeModel attribute) {
    return _controllers.putIfAbsent(attribute.attributeCode ?? '',
        () => TextEditingController(text: _displayValue(attribute)));
  }

  /// Pushes model values into the text fields after data is (re)loaded.
  void _syncControllers() {
    for (final attribute in list) {
      _controllers[attribute.attributeCode ?? '']?.text = _displayValue(attribute);
    }
  }

  String _displayValue(ProductAttributeModel attribute) {
    final value = attribute.value;
    if (value == null) return '';
    return value is num ? Tools.formatQty(value) : value.toString();
  }

  bool _isNumeric(ProductAttributeModel attribute) {
    return ["price", "weight"].contains(attribute.frontendInput) ||
        attribute.attributeCode == "product_quantity";
  }

  /// The SKU typed by the vendor, or null to fall back to the product name.
  String? _enteredSku() {
    for (final attribute in list) {
      if (attribute.attributeCode == "sku") {
        final sku = attribute.value?.toString().trim() ?? '';
        return sku.isEmpty ? null : sku;
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ImagePicker.checkGrantedPermission();
    quantityAttributeModel.attributeCode = "product_quantity";
    context.read<CreateEditProductBloc>().add(PerformProductAttributeList(query: '$attributeSetId/attributes'));
    context.read<CreateEditProductBloc>().add(const PerformProductAttributeSetList(query: 'searchCriteria[pageSize]=50'));
    if(widget.productSku.isNotEmpty){
      context.read<CreateEditProductBloc>().add(PerformSingleProduct(productSku: widget.productSku));
    }else {
      context.read<CreateEditProductBloc>().add(const PerformProductCategories());
    }
   // treeListData = initialTreeData;
  }

  void setData(){

    list.forEach((attributeModel){
      if(attributeModel.attributeCode == "sku"){
        if(widget.productSku.isNotEmpty){
          attributeModel.value = widget.productSku;
        }
      }else if(attributeModel.attributeCode == "name"){
        attributeModel.value = productItem?.name;
      }else if(attributeModel.attributeCode == "price"){
        attributeModel.value = productItem?.price;
      }else if(attributeModel.attributeCode == "weight"){
        attributeModel.value = productItem?.weight;
      }else if(attributeModel.attributeCode == "product_quantity"){
        attributeModel.value = productItem?.stockItemQunatityModel?.qty;
      }else if(attributeModel.attributeCode == "status"){
        attributeModel.options?.forEach((option)  async {
          if(option.value == productItem?.status){
            attributeModel.value = option.label;
          }
        });
      }else if(attributeModel.attributeCode == "visibility"){
        attributeModel.options?.forEach((option) async {
          if(option.value == productItem?.visibility){
            attributeModel.value = option.label;
          }
        });
      }else if(["multiselect","select"].contains(attributeModel.frontendInput)){
        productItem?.customAttributes?.forEach((attribute){
          if(attribute.attributeCode == attributeModel.attributeCode) {
            attributeModel.options?.forEach((option) async {
              if (option.value == attribute.value) {
                attributeModel.value = option.label;
              }
            });
          }
        });
      }else if(attributeModel.frontendInput == "boolean"){
        productItem?.customAttributes?.forEach((attribute){
          if(attribute.attributeCode == attributeModel.attributeCode){
            if(attribute.value.toString() == "1"){
              attributeModel.value = true;
            }else{
              attributeModel.value = false;
            }
          }
        });
      }else{
        productItem?.customAttributes?.forEach((attribute){
           if(attribute.attributeCode == attributeModel.attributeCode){
             attributeModel.value = attribute.value;
           }
        });
      }
    });
      galleryproductAttributeModel.galleryImages.clear();
      productItem?.mediaGalleryEntries?.forEach((elment){
        galleryproductAttributeModel.galleryImages.add(baseProductImageUrl+(elment.file ?? ""));
      });
      _syncControllers();
  }

  void getAttributeList(){
    attributes.clear();
    list.forEach((attributeModel){
      if(attributeModel.attributeCode == "sku"){
        if(attributeModel.value != productItem?.sku){
          attributes.add(attributeModel.attributeCode ?? "");
        }
      }else if(attributeModel.attributeCode == "name"){
        if(attributeModel.value != productItem?.name){
          attributes.add(attributeModel.attributeCode ?? "");
        }
      }else if(attributeModel.attributeCode == "price"){
        if(attributeModel.value != productItem?.price){
          attributes.add(attributeModel.attributeCode ?? "");
        }
      }else if(attributeModel.attributeCode == "weight"){
        if(attributeModel.value != productItem?.weight){
          attributes.add(attributeModel.attributeCode ?? "");
        }
      }else if(attributeModel.attributeCode == "product_quantity"){
        if(attributeModel.value != productItem?.stockItemQunatityModel?.qty){
          attributes.add("stock_item");
        }
      }else if(attributeModel.attributeCode == "status"){
        if(attributeModel.value != productItem?.status){
          attributes.add(attributeModel.attributeCode ?? "");
        }
      }else if(attributeModel.attributeCode == "visibility"){
        if(attributeModel.value != productItem?.visibility){
          attributes.add(attributeModel.attributeCode ?? "");
        }
      }else if(["multiselect","select"].contains(attributeModel.frontendInput)){
        bool isFound = false;
        productItem?.customAttributes?.forEach((attribute){
          if(attribute.attributeCode == attributeModel.attributeCode) {
            isFound = true;
            attributeModel.options?.forEach((option) async {
              if (option.value == attribute.value) {
                if(attributeModel.value != option.label)
                {
                  attributes.add(attributeModel.attributeCode ?? "");
                }
              }
            });
          }
        });
        if(!isFound){
         // attributes.add(attributeModel.attributeCode ?? "");
        }
      }else if(attributeModel.frontendInput == "boolean"){
        productItem?.customAttributes?.forEach((attribute){
          if(attribute.attributeCode == attributeModel.attributeCode){

            if(attribute.value.toString() == "1" && !attributeModel.value){
              attributes.add(attributeModel.attributeCode ?? "");
            }else if(attribute.value.toString() == "0" && attributeModel.value){
              attributes.add(attributeModel.attributeCode ?? "");
            }
          }
        });
      }else{
        bool isFound = false;
        productItem?.customAttributes?.forEach((attribute){
           if(attribute.attributeCode == attributeModel.attributeCode){
            isFound = true;
            if(attributeModel.value != attribute.value){
              attributes.add(attributeModel.attributeCode ?? "");
            }
          }
        });
        if(!isFound && attributeModel.value.toString().isNotEmpty && attributeModel.frontendInput != "gallery" && attributeModel.frontendInput != "media_image"  && !skipAttributeName.contains(attributeModel.attributeCode ?? "")){
          attributes.add(attributeModel.attributeCode ?? "");
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBars(context,_scaffoldKey,AppLocalizations.of(context)!.product,true,true),
        // drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh:  () async {
            context.read<CreateEditProductBloc>().add(PerformProductAttributeList(query: '$attributeSetId/attributes'));
          },
          child: Container(
            child: BlocListener<CreateEditProductBloc, CreateEditProductState>(
                listener: (context, state) async {
                  if (state is ProductsLoading) {
                    LoadingScreen().show(
                      context: context,
                      text: 'Please wait a moment',
                    );
                  } else {
                    LoadingScreen().hide();
                  }
                  if (state is ProductsAttributeLoaded) {
                    setState(() {
                      list.clear();
                      state.productAttributeModel.forEach((object){
                         if(!skipAttributeName.contains(object.attributeCode)){
                           list.add(object);
                         }
                      });
                     // list = state.productAttributeModel;
                      list.forEach((_){
                        for (var action in list) {
                          if(action.attributeCode == "status"){
                            list.remove(action);
                            list.insert(0, action);
                          }else if(action.attributeCode == "name"){
                            list.remove(action);
                            list.insert(1, action);
                          }else if(action.attributeCode == "sku"){
                            list.remove(action);
                            // if(selectedLanguage == 'ar'){
                            //   action.value = productItem?.sku ?? "1_${DateTime.now().millisecondsSinceEpoch}_${userModel?.id}";
                            // }else{
                            //   action.value = productItem?.sku ?? "${userModel?.id}_${DateTime.now().millisecondsSinceEpoch}_1";
                            // }
                            list.insert(2, action);
                          }else if(action.attributeCode == "price"){
                            list.remove(action);
                            list.insert(3, action);
                          }else if(action.attributeCode == "weight"){
                            list.remove(action);
                            list.insert(5, action);
                          }else if(action.attributeCode == "category_ids"){
                            list.remove(action);
                            list.insert(6, action);
                          }else if(action.attributeCode == "approval"){
                            list.remove(action);
                            list.insert(7, action);
                          }else if(action.attributeCode == "description"){
                            list.remove(action);
                            list.insert(8, action);
                          }else if(action.attributeCode == "short_description"){
                            list.remove(action);
                            list.insert(9, action);
                          }else if(action.attributeCode == "url_key"){
                            list.remove(action);
                            list.insert(10, action);
                          }
                        }
                      });

                      // for (var action in list) {
                      //   if(action.attributeCode == "status"){
                      //     list.remove(action);
                      //     list.insert(0, action);
                      //   }else if(action.attributeCode == "name"){
                      //     list.remove(action);
                      //     list.insert(1, action);
                      //   }
                      // }
                      quantityAttributeModel.defaultFrontendLabel = AppLocalizations.of(context)!.qty;
                      if(list.length>4){
                        list.insert(4, quantityAttributeModel);
                      }else{
                        list.insert(0, quantityAttributeModel);
                      }
                      setData();
                    });
                  }else if (state is ProductsAttributeSetLoaded) {
                    setState(() {
                      attributelist = state.productAttributeSetList;
                    });
                  }else if (state is ProductCategoriesLoaded) {
                    treeListData.clear();
                    for (var item in state.treeListData) {
                      treeListData.add(item);
                    }
                    setState(() {

                    });
                  }else if (state is SaveProductLoaded) {
                    Navigator.pop(context);
                  }else if (state is SingleProductLoaded) {
                    setState(() {
                      productItem = state.productItem;
                      productItem?.customAttributes?.forEach((attribute){
                        if(attribute.attributeCode == "category_ids"){
                          attribute.value.forEach((value){
                            category_ids.add(value);
                          });
                        }
                      });
                      setData();
                      context.read<CreateEditProductBloc>().add(const PerformProductCategories());
                    });
                  }
                  if (state is ProductsError) {
                    Tools.showSnackBar(ScaffoldMessenger.of(context),state.errorMessage);
                  }
                },
                child:SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          ProductInfoDropdownWidget(
                            label:AppLocalizations.of(context)!.attributeSet,
                            productAttributeModel: attributeproductAttributeModel,
                            onChangedCustom:  (value) {
                              if (value != null) {
                                int index = attributelist.indexWhere((item) => item.attributeSetName == value);
                                attributeSetId = attributelist[index].attributeSetId ?? 4;
                                context.read<CreateEditProductBloc>().add(PerformProductAttributeList(query: '$attributeSetId/attributes'));
                              }
                            },
                            list: attributelist.length > 0 ? attributelist.map((value) => value.attributeSetName ?? "").toList() : ["Default"],
                          ),

                          ...List.generate(
                            list.length ?? 0,
                                (index) {
                              if(skipAttributeName.contains(list[index].attributeCode)){
                                return const SizedBox();
                              }else if((list[index].defaultFrontendLabel ?? "").isEmpty || list[index].defaultFrontendLabel  == "[]"){
                                return const SizedBox();
                              }else if((list[index].attributeCode ?? "") == "product_quantity"){
                                final attribute = list[index];
                                return EditProductInfoWidget(
                                  controller: _controllerFor(attribute),
                                  label: attribute.defaultFrontendLabel ?? "",
                                  onChanged: (val) {
                                    attribute.value = val;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [NumericInputFormatter(decimal: false)],
                                );
                              }else if(list[index].attributeCode == "news_from_date"){
                                ProductAttributeModel productDateTo = list.firstWhere((e) => e.attributeCode == 'news_to_date');
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 15,
                                        bottom: 5
                                      ),
                                      child: Text(
                                        list[index].defaultFrontendLabel ?? "",
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: EditProductInfoDateWidget(
                                          label: "",
                                          productAttributeModel: list[index],
                                          onChanged: (val) {
                                            print(val);
                                            list[index].value = val;
                                          },
                                        )),
                                        Expanded(
                                          child: EditProductInfoDateWidget(
                                            label: "",
                                            productAttributeModel: productDateTo,
                                            onChanged: (val) {
                                              productDateTo.value = val;
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }
                              switch(list[index].frontendInput){
                                  case "text":
                                    final attribute = list[index];
                                    // The SKU identifies the product in Magento's API, so it
                                    // is editable when creating but fixed once saved.
                                    final enable = attribute.attributeCode != "sku" || widget.productSku.isEmpty;
                                  return EditProductInfoWidget(
                                    controller: _controllerFor(attribute),
                                  label: attribute.defaultFrontendLabel ?? "",
                                  onChanged: (val) {
                                    attribute.value = val;
                                  },
                                  keyboardType: TextInputType.multiline,
                                    enable: enable,
                                  );
                                case "textarea":
                                  final attribute = list[index];
                                  return EditProductInfoWidget(
                                    controller: _controllerFor(attribute),
                                    label: attribute.defaultFrontendLabel ?? "",
                                    onChanged: (val) {
                                      attribute.value = val;
                                    },
                                    isMultiline: true,
                                    keyboardType: TextInputType.multiline,
                                  );
                                case "price" || "weight":
                                  final attribute = list[index];
                                  return EditProductInfoWidget(
                                    controller: _controllerFor(attribute),
                                    label: attribute.defaultFrontendLabel ?? "",
                                    onChanged: (val) {
                                      attribute.value = val;
                                    },
                                    // TextInputType.number has no decimal key on iOS.
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [NumericInputFormatter()],
                                  );
                                case "date":
                                  return EditProductInfoDateWidget(
                                    label: list[index].defaultFrontendLabel ?? "",
                                    productAttributeModel: list[index],
                                    onChanged: (val) {
                                      list[index].value = val;
                                    },
                                  );
                                case "select":
                                  var optionlist = list[index].options?.map((value) => value.label ?? "").toList() ?? [];
                                  if(optionlist.length == 0){
                                    return const SizedBox();
                                  }
                                  if(list[index].value == null){
                                    list[index].value = optionlist.first;
                                  }
                                  return ProductInfoDropdownWidget(
                                    label:list[index].defaultFrontendLabel ?? "",
                                    productAttributeModel: list[index],
                                    list: list[index].options?.map((value) => value.label ?? "").toList() ?? [],
                                  );
                                case "boolean":
                                  if(list[index].value == null){
                                    list[index].value = false;
                                  }
                                  return ProductInfoSwitchWidget(
                                    label:list[index].defaultFrontendLabel ?? "",
                                    productAttributeModel: list[index],
                                  );
                                case "media_image":
                                  return const SizedBox();
                                  // return ImageSelect(
                                  //    image: list[index].featuredImage,
                                  //   label:list[index].defaultFrontendLabel,
                                  //   onSelect: (image) {
                                  //     list[index].updateFeatureImage(image);
                                  //   },
                                  // );
                                case "gallery":
                                  return const SizedBox();
                                // return ListImageSelect(
                                //     images: list[index].galleryImages,
                                //   label:list[index].defaultFrontendLabel,
                                //   onSelect: (images) {
                                //     list[index].updateImages(images ?? []);
                                //   },
                                // );
                                case "multiselect":
                                  var optionlist = list[index].options?.map((value) => value.label ?? "").toList() ?? [];
                                  if(optionlist.length == 0){
                                    return const SizedBox();
                                  }
                                  if(list[index].value == null){
                                    list[index].value = optionlist.first;
                                  }
                                  return ProductInfoDropdownWidget(
                                    label:list[index].defaultFrontendLabel ?? "",
                                    productAttributeModel: list[index],
                                    list: list[index].options?.map((value) => value.label ?? "").toList() ?? [],
                                  );
                              }
                              return Container();
                              // return VendorAdminProductListCardWidget(
                              //   product: products?[index],
                              // );
                            },
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                              //  left: 15,
                              // right: 15,
                              top: 15,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.categoriesProduct,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if(treeListData.length >= 1)
                            SizedBox(
                              height: 300,
                              child: FlutterTreePro(
                                initialSelectValue: 1402,
                                isSingleSelect: false,
                                isRTL: isRTL,
                                isExpanded: isExpanded,
                                listData: treeListData,
                                checkedListIds: category_ids,
                                initialListData: initialTreeData,
                                config: const Config(
                                    parentId: 'parent_id',
                                    dataType: DataType.DataList,
                                    label: 'name',
                                    id: 'id',
                                    value: 'position',
                                    children: 'children_data'
                                ),
                                onChecked: (List<Map<String, dynamic>> checkedList) {
                                  setState(() {
                                    if(checkedList.isNotEmpty){
                                      var id = checkedList.first['id'];
                                      if(category_ids.contains(id)){
                                        category_ids.remove(id.toString());
                                      }else{
                                        category_ids.add(id.toString());
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                           SizedBox(height: 10,),
                           if(list.length>0 && (productItem != null || widget.productSku.isEmpty))
                             ListImageSelect(
                               images: galleryproductAttributeModel.galleryImages,
                               label:AppLocalizations.of(context)!.imageGallery.toUpperCase(),
                               onSelect: (images) {
                                 galleryproductAttributeModel.updateImages(images ?? []);
                               },
                               onDeleteImage: (image){
                                 productItem?.mediaGalleryEntries?.forEach((_element){
                                   if((image ?? "").contains(_element.file ?? "")){

                                     context.read<CreateEditProductBloc>().add(PerformProductDeleteMedia(sku: widget.productSku,mediaGalleryEntry: _element));
                                   }
                                 });
                               },
                             ),
                          InkWell(
                            onTap: () async {
                              // if(_allValidation()){
                              //   Map<String, dynamic> loginMap = {
                              //     "username": _emailController.text,
                              //     "password": _passwordController.text.trim(),
                              //   };
                              //   /// init Login event
                              //   context.read<LoginBloc>().add(
                              //     PerformUserLogin(
                              //       requestValueMap: loginMap,
                              //     ),
                              //   );
                              // }
                              list.forEach((attributeModel) async {
                                  // if(attributeModel.frontendInput == "media_image"){
                                  //   if(attributeModel.featuredImage != null){
                                  //     var base64 = await ImagePicker.compressImage(attributeModel.featuredImage);
                                  //     print(base64);
                                  //   }
                                  // }
                              });
                              final Map<String, dynamic> product = new Map<String, dynamic>();
                              final Map<String, dynamic> custom_attributes = new Map<String, dynamic>();
                              final Map<String, dynamic> extension_attributes = new Map<String, dynamic>();
                              List<Map<String, dynamic>> media_gallery_entries = [];

                              product['type_id'] = "simple";
                              product['attributeSetId'] = attributeSetId;
                              for (int index = 0; index < list.length; index++) {
                                if(skipAttributeName.contains(list[index].attributeCode) ||
                                    (list[index].defaultFrontendLabel ?? "").isEmpty ||
                                    list[index].defaultFrontendLabel  == "[]" ||
                                    list[index].attributeCode  == "sku") {

                                }else{
                                  if((list[index].isRequired ?? false) && (list[index].value == null || list[index].value.toString().trim().isEmpty)){
                                    Tools.showSnackBar(ScaffoldMessenger.of(context),"${list[index].defaultFrontendLabel} ${AppLocalizations.of(context)!.isrequired}");
                                    return;
                                  }
                                  if(_isNumeric(list[index]) && (list[index].value?.toString() ?? "").isNotEmpty && JsonParser.toNum(list[index].value) == null){
                                    Tools.showSnackBar(ScaffoldMessenger.of(context),"${list[index].defaultFrontendLabel} ${AppLocalizations.of(context)!.invalidNumber}");
                                    return;
                                  }
                                  if(list[index].attributeCode == "sku"){

                                    // else{
                                    //   product['sku'] = list[index].value;
                                    // }
                                    //.replaceAll(" ","_");
                                  }else if(list[index].attributeCode == "name"){
                                    product['name'] = list[index].value;
                                    if(productItem == null){
                                      product['sku'] = _enteredSku() ?? list[index].value;
                                    }else if(productItem != null){
                                      product['sku'] = widget.productSku;
                                    }
                                  }else if(list[index].attributeCode == "price"){
                                    product['price'] = JsonParser.toNum(list[index].value);
                                  }else if(list[index].attributeCode == "weight"){
                                    final weight = JsonParser.toNum(list[index].value);
                                    if(weight != null) {
                                      product['weight'] = weight;
                                    }
                                  }else if(list[index].attributeCode == "product_quantity"){
                                   final qty = JsonParser.toNum(list[index].value) ?? 0;
                                   Map<String, dynamic> stock_item = new Map<String, dynamic>();
                                    stock_item['qty'] = qty;
                                    if(qty <= 0){
                                      stock_item['is_in_stock'] = 0;
                                      stock_item['manage_stock'] = 0;
                                    }else{
                                      stock_item['is_in_stock'] = 1;
                                      stock_item['manage_stock'] = 1;
                                    }
                                   extension_attributes["stock_item"] = stock_item;
                                  }else if(list[index].attributeCode == "news_from_date"){
                                    ProductAttributeModel productDateTo = list.firstWhere((e) => e.attributeCode == 'news_to_date');
                                    if(list[index].value != null)
                                    custom_attributes[list[index].attributeCode ?? ""] = list[index].value;
                                    if(productDateTo.value != null)
                                    custom_attributes[productDateTo.attributeCode ?? ""] = productDateTo.value;
                                  }else if(["multiselect","select"].contains(list[index].frontendInput)){
                                    list[index].options?.forEach((option) async {
                                       if(option.label == list[index].value){
                                         if(list[index].attributeCode == "status"){
                                           product['status'] = option.value;
                                         }else if(list[index].attributeCode == "visibility"){
                                           product['visibility'] = option.value;
                                         }else{
                                           if((option.value ?? "").isNotEmpty)
                                           custom_attributes[list[index].attributeCode ?? ""] = option.value;
                                         }
                                       }
                                    });
                                  }else if(list[index].frontendInput == "boolean"){
                                    if(list[index].value == true){
                                      custom_attributes[list[index].attributeCode ?? ""] = 1;
                                    }else{
                                      custom_attributes[list[index].attributeCode ?? ""] = 0;
                                    }
                                  }else {
                                    if(list[index].value != null){
                                      custom_attributes[list[index].attributeCode ?? ""] = list[index].value;
                                    }
                                  }
                                }
                              }
                              for (int index = 0; index < galleryproductAttributeModel.galleryImages.length; index++) {
                                if(galleryproductAttributeModel.galleryImages[index]  is String){
                                  productItem?.mediaGalleryEntries?.forEach((_element){
                                    if((galleryproductAttributeModel.galleryImages[index] ?? "").contains(_element.file ?? "")){
                                      media_gallery_entries.add(_element.toJson());
                                    }
                                  });
                                }else{
                                  var base64 = await ImagePicker.compressImage(galleryproductAttributeModel.galleryImages[index]);
                                  var imageName = await ImagePicker.getImageName(galleryproductAttributeModel.galleryImages[index]);
                                  var extension = await ImagePicker.formatImage(galleryproductAttributeModel.galleryImages[index]);
                                  if(index == 0){
                                    media_gallery_entries.add(
                                        {
                                          "media_type": "image",
                                          "label": "Main Image",
                                          "position": index+1,
                                          "disabled": false,
                                          "types": ["image","thumbnail"],
                                          // "types": [
                                          //   "image",
                                          //   "small_image",
                                          //   "thumbnail",
                                          //   "swatch_image"
                                          // ],
                                          "content": {
                                            "base64_encoded_data": base64,
                                            "name": imageName,
                                            "type": extension
                                          }
                                        }
                                    );
                                  }else{
                                    media_gallery_entries.add(
                                        {
                                          "media_type": "image",
                                          "label": "Main Image",
                                          "position": index+1,
                                          "disabled": false,
                                          "types": [],
                                          // "types": [
                                          //   "image",
                                          //   "small_image",
                                          //   "thumbnail",
                                          //   "swatch_image"
                                          // ],
                                          "content": {
                                            "base64_encoded_data": base64,
                                            "name": imageName,
                                            "type": extension
                                          }
                                        }
                                    );
                                  }

                                }
                              }
                              custom_attributes['category_ids'] = category_ids;
                              final Map<String, dynamic> data = new Map<String, dynamic>();
                              product["extension_attributes"] = extension_attributes;
                              product["media_gallery_entries"] = media_gallery_entries;
                              if(productItem != null){

                                List<Map<String, dynamic>> listcustomAttributes = [];
                                custom_attributes.forEach((key,value){
                                  listcustomAttributes.add({
                                    "attribute_code": key,
                                    "value": value
                                  });
                                });
                                product['id'] = productItem?.id;
                                product["custom_attributes"] = listcustomAttributes;
                                getAttributeList();
                                attributes.add("media_gallery_entries");
                                attributes.add("category_ids");
                                data["attributes"] = attributes;
                                data["product"] = product;
                                print(json.encode(data));
                                context.read<CreateEditProductBloc>().add(PerformSaveProduct(requestValueMap: data,isUpdate:true));
                              }else{
                                custom_attributes['url_key'] = productUrlKey(product['name']?.toString(), product['sku']?.toString());
                                List<Map<String, dynamic>> listcustomAttributes = [];
                                custom_attributes.forEach((key,value){
                                  listcustomAttributes.add({
                                    "attribute_code": key,
                                    "value": value
                                  });
                                });
                                product["custom_attributes"] = listcustomAttributes;//custom_attributes;
                                data["product"] = product;
                                context.read<CreateEditProductBloc>().add(PerformSaveProduct(requestValueMap: data,isUpdate:false));
                              }
                            },
                            child: Container(
                              height: 44,
                              width: 200,
                              margin: EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.save.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),


                          // EditProductInfoWidget(
                          //   onChanged: (val) {
                          //
                          //   },
                          //   label: "shortDescription",
                          // ),
                          //
                          // EditProductInfoWidget(
                          //   label: "S.of(context).description",
                          //   onChanged: (val) {
                          //     print(val);
                          //   },
                          //   isMultiline: true,
                          //   keyboardType: TextInputType.multiline,
                          // ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }


}

