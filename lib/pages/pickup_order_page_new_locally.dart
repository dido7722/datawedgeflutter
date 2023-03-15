import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../core/model/order_model.dart';
import '../core/model/product_model.dart';
import '../core/view_model/cart_products_view_model.dart';
import '../core/view_model/order_products_view_model.dart';
import '../core/view_model/products_view_model.dart';
import '../services/pages_arguments.dart';
import '../widgets/controller/constants.dart';
import '../widgets/controller/custom_action_bar.dart';
import '../widgets/pick_order_controller/product_card_pick_order_kund.dart';
import '../widgets/pick_order_controller/product_card_pick_order_new.dart';

class PickOrderPageNewLocally extends StatefulWidget {
  PickOrderPageNewLocally({Key? key}) : super(key: key);

  @override
  State<PickOrderPageNewLocally> createState() => _PickOrderPageNewLocallyState();
}

class _PickOrderPageNewLocallyState extends State<PickOrderPageNewLocally> {
  final appSetting = GetStorage(); // instance of getStorage class

  final RxString barcodeCode = ''.obs;

  final RxString findCode = ''.obs;

  final barcodeController = TextEditingController();

  final findController = TextEditingController();

  static const MethodChannel methodChannel =
      MethodChannel('com.darryncampbell.datawedgeflutter/command');
  static const EventChannel scanChannel =
      EventChannel('com.darryncampbell.datawedgeflutter/scan');

  Future<void> _createProfile(String profileName) async {
    try {
      await methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  RxBool _isAdd = true.obs;
  RxString _itemName = ''.obs;

  String _barcodeString = "Barcode will be shown here";
  final RxBool connected = true.obs;

  @override
  void initState() {
    super.initState();
    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _createProfile("DataWedgeFlutterDemo");
  }

  Future<void> _onEvent(event) async {
    setState(() {
      Map barcodeScan = jsonDecode(event);
      _barcodeString = barcodeScan['scanData'];
    });
    if (connected.value) {
      getItem(_barcodeString, orderModel, productsViewModel, context);
    }
  }

  void _onError(Object error) {
    setState(() {
      _barcodeString = "Barcode: error";
    });
  }

  // CartProductsViewModel controller = Get.find();

  final ProductsViewModel productsViewModel = Get.find();
  late OrderModel orderModel;
  List localList = [];
  final itemScrollController = ItemScrollController();

  OrderProductsViewModel orderProductsViewModel =Get.find();


  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as OrderPageArguments;
    orderModel = args.orderModel;
    productsViewModel.productsLocal.clear();
    productsViewModel.keyValue = 'key-${orderModel.sort}';

    if (appSetting.hasData(productsViewModel.keyValue)) {
      final String musicsString = appSetting.read(productsViewModel.keyValue);
      productsViewModel.productsLocal.addAll(ProductModel.decode(musicsString));
      calculateQuantity(productsViewModel.productsLocal);
    } else {
      appSetting.write(productsViewModel.keyValue,
          ProductModel.encode(orderProductsViewModel.productsList));
      final String musicsString = appSetting.read(productsViewModel.keyValue);
      productsViewModel.productsLocal.addAll(ProductModel.decode(musicsString));
      calculateQuantity(productsViewModel.productsLocal);

    }

    return new Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          connected.value = connectivity != ConnectivityResult.none;
          return new Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                height: 24.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: connected.value ? Color(0xFF00EE44) : Color(0xFFEE4400),
                  child: Center(
                    child: Text("${connected.value ? 'ONLINE' : 'OFFLINE'}"),
                  ),
                ),
              ),
              Center(
                child:
                // Obx(() =>
                // (controller.loading.value)
                //     ? const Center(child: CircularProgressIndicator())
                //     :
                SafeArea(
                  child: Obx(
                        () => Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              CustomActionBar(
                                title: '${orderModel.userName} - ${orderModel.sort}',
                                hasBackArrowWidget: true,
                                hasSearchWidget: false,
                                hasTitleWidget: true,
                                hasCartQtyWidget: false,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('المطلوبة: ${productsViewModel.totalProduct.value}'),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('الكمية المعبئة: ${productsViewModel.realTotalProduct.value}'),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'الباقي: ${productsViewModel.totalProduct.value -
                                          productsViewModel.realTotalProduct.value}',
                                      style: const TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('عدد البالات: ${productsViewModel.countPalls.value}'),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(

                                      child: PrimaryText(text: ' ${_itemName.value} // $_barcodeString',color: _isAdd.value? Colors.green:Colors.redAccent,size: 10.sp,),
                                    ),
                                  ),
                                  CupertinoSwitch(
                                    trackColor: Colors.redAccent,
                                    value: _isAdd.value,
                                    onChanged: (value) {
                                      setState(() {
                                        _isAdd.value = value;
                                      });
                                    },
                                  ),

                                ],
                              ),
                              TextField(
                                controller: findController,
                                onChanged: (value) {
                                  findCode.value = value;
                                },
                                onTap: () {

                                },
                                onSubmitted: (value) {
                                  findCode.value = value;

                                },

                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(
                                      Icons.find_in_page,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: CloseButton(
                                      onPressed: () {
                                        findController.clear();
                                        findCode.value = '';
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                    hintText: "بحث عن صنف",
                                    fillColor: Colors.grey,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 15.0,
                                    )),
                                style: TextStyle(
                                    fontSize: 11.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent),
                              ),

                              Flexible(
                                child: DefaultTabController(
                                  length: 2,
                                  child: Column(

                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ButtonsTabBar(
                                            backgroundColor: AppColors.activeColor,
                                            unselectedBackgroundColor: Colors.grey[300],
                                            unselectedLabelStyle:
                                            const TextStyle(color: Colors.black),
                                            labelStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            tabs:  [
                                              Tab(
                                                icon: Icon(Icons.pause),
                                                text: 'في الانتظار',
                                              ),
                                              Tab(
                                                icon: Icon(Icons.done),
                                                text: "معالجة",
                                              ),

                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, '/SearchPage2',arguments:OrderPageArguments(
                                                      orderModel) );
                                                  // productsViewModel.update();
                                                },
                                                icon: Icon(Icons.add)),
                                          ),

                                        ],
                                      ),

                                      Expanded(
                                        child: TabBarView(
                                          children: [
                                            ListView.builder(
                                              itemCount: productsViewModel.productsLocal.where((p0) => !p0.finishPicked.value && p0.toString().toLowerCase().contains(findCode.toLowerCase())).length,
                                              itemBuilder: (_, index) {
                                                return ProductCardPickOrderNew(
                                                  index: index,
                                                  productModel: productsViewModel
                                                      .productsLocal.where((p0) => !p0.finishPicked.value && p0.toString().toLowerCase().contains(findCode.toLowerCase()))
                                                      .toList(),
                                                  orderId: orderModel.id,
                                                  userId: orderModel.userID,
                                                  findCode: barcodeCode,
                                                );
                                              },
                                            ),
                                            ListView.builder(
                                              itemCount: productsViewModel.productsLocal.where((p0) => p0.finishPicked.value && p0.toString().toLowerCase().contains(findCode.toLowerCase())).length,
                                              itemBuilder: (_, index) {
                                                return ProductCardPickOrderNew(
                                                  index: index,
                                                  productModel: productsViewModel
                                                      .productsLocal.
                                                  where((p0) => p0.finishPicked.value && p0.toString().toLowerCase().contains(findCode.toLowerCase())) .toList(),
                                                  orderId: orderModel.id,
                                                  userId: orderModel.userID,
                                                  findCode: barcodeCode,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ),

              ),
            ],
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'There are no bottons to push :)',
            ),
            new Text(
              'Just turn off your internet.',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getItem(String value, OrderModel orderModel,
      ProductsViewModel productsViewModel, BuildContext context) async {
    if (productsViewModel.productsList
        .where((p0) => p0.idAmeen == value || p0.barcode1 ==value|| p0.barcode2 ==value|| p0.barcode3 ==value)
        .isNotEmpty) {
      var prod = productsViewModel.productsList
          .where((p0) => p0.idAmeen == value  || p0.barcode1 ==value|| p0.barcode2 ==value|| p0.barcode3 ==value)
          .first;
      addRemoveItem(prod.idAmeen);
      calculateQuantity(productsViewModel.productsLocal);
    } else {
      Get.snackbar("خطأ".tr, "الصنف غير موجود في الطلبية او غير معرف",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void addRemoveItem(String value) {
    if(productsViewModel.productsLocal.where((p0) => p0.idAmeen==value || p0.barcode1.value==value || p0.barcode2.value==value || p0.barcode3.value==value).isNotEmpty) {
      var product = productsViewModel.productsLocal
          .where((p0) => p0.idAmeen == value || p0.barcode1.value==value || p0.barcode2.value==value || p0.barcode3.value==value)
          .first;
      _itemName.value = product.names[1];

      if(_isAdd.value) {
        if (product.finishPicked.value) {
          Get.snackbar("خطأ".tr, "الصنف معبأ مسبقاً",
              snackPosition: SnackPosition.BOTTOM);
        } else {
          if (product.realQty != product.qty) {
            if (product.realQty.value + 1 == product.qty.value) {
              product.finishPicked.value = true;
            }
            product.realQty.value +=1;
          } else {
            Get.snackbar("خطأ".tr, "خطأ 331",
                snackPosition: SnackPosition.BOTTOM);
          }
        }

        appSetting.write(productsViewModel.keyValue,
                    ProductModel.encode(productsViewModel.productsLocal));
      }
      else{
        if (product.realQty.value.isEqual(0)) {
          Get.snackbar("خطأ".tr, "الصنف $value غير معبأ مسبقاً",
              snackPosition: SnackPosition.BOTTOM);
        } else {
          if (product.realQty.value == product.qty.value) {
            _itemName.value = product.names[1];
            product.realQty.value -=1;
            product.finishPicked.value =false;
            appSetting.write(productsViewModel.keyValue,
                ProductModel.encode(productsViewModel.productsLocal));

          } else {
            product.realQty.value -=1;

            product.finishPicked.value =false;
            appSetting.write(productsViewModel.keyValue,
                ProductModel.encode(productsViewModel.productsLocal));
          }
        }
        appSetting.write(productsViewModel.keyValue,
            ProductModel.encode(productsViewModel.productsLocal));

      }
    }else{
      Get.snackbar("خطأ".tr, "الصنف $value  غير موجود في الطلبية",
          snackPosition: SnackPosition.BOTTOM);
      _itemName.value = 'غير موجود في الطلبية';


    }
    // if (_isAdd.value) {
    //   if (productsViewModel.productsLocal
    //       .where((p0) => p0.idAmeen == idAmeen)
    //       .isNotEmpty) {
    //     var product = productsViewModel.productsLocal
    //         .where((p0) => p0.idAmeen == idAmeen)
    //         .first;
    //     if (product.qty.value == 0) {
    //       product.qty.value = 1;
    //       productsViewModel.productsLocal.add(product);
    //     } else {
    //       var product = productsViewModel.productsLocal
    //           .where((p0) => p0.idAmeen == idAmeen)
    //           .first;
    //       product.qty.value += 1;
    //       productsViewModel.productsLocal
    //           .removeWhere((p0) => p0.idAmeen == idAmeen);
    //       productsViewModel.productsLocal.add(product);
    //     }
    //     appSetting.write(productsViewModel.keyValue,
    //         ProductModel.encode(productsViewModel.productsLocal));
    //     _itemName.value =
    //         'اضافة ${product.idAmeen} - ${product.names[1]} - ${product.qty.value} صندوق';
    //   } else {
    //     productsViewModel.productsLocal.add(productsViewModel.productsList
    //         .where((p0) => p0.idAmeen == idAmeen)
    //         .first);
    //     _itemName.value =
    //         'اضافة ${productsViewModel.productsList.where((p0) => p0.idAmeen == idAmeen).first.idAmeen} - ${productsViewModel.productsList.where((p0) => p0.idAmeen == idAmeen).first.names[1]}  - ${productsViewModel.productsList.where((p0) => p0.idAmeen == idAmeen).first.qty.value} صندوق';
    //     appSetting.write(productsViewModel.keyValue,
    //         ProductModel.encode(productsViewModel.productsLocal));
    //   }
    //   if (productsViewModel.productsLocal.length > 1) {
    //     itemScrollController.jumpTo(
    //         index: productsViewModel.productsLocal.length);
    //   }
    // } else {
    //   if (productsViewModel.productsLocal
    //       .where((p0) => p0.idAmeen == idAmeen)
    //       .isNotEmpty) {
    //     var product = productsViewModel.productsLocal
    //         .where((p0) => p0.idAmeen == idAmeen)
    //         .first;
    //     if (product.qty.value == 1) {
    //       productsViewModel.productsLocal.remove(product);
    //     } else {
    //       productsViewModel.productsLocal
    //           .where((p0) => p0.idAmeen == idAmeen)
    //           .first
    //           .qty
    //           .value -= 1;
    //     }
    //     _itemName.value =
    //         'حذف  ${product.idAmeen} - ${product.names[1]} - ${product.qty.value} صندوق';
    //
    //     appSetting.write(productsViewModel.keyValue,
    //         ProductModel.encode(productsViewModel.productsLocal));
    //   } else {
    //     _itemName.value = 'الصنف غير معبا مسبقاً';
    //     Get.snackbar("خطأ".tr, "الصنف غير معبا مسبقاً",
    //         snackPosition: SnackPosition.BOTTOM);
    //   }
    // }
  }

  // void removeItem(String idAmeen) {
  //   if (productsViewModel.productsLocal
  //       .where((p0) => p0.idAmeen == idAmeen)
  //       .isNotEmpty) {
  //     var product = productsViewModel.productsLocal
  //         .where((p0) => p0.idAmeen == idAmeen)
  //         .first;
  //     productsViewModel.productsLocal.remove(product);
  //
  //     _itemName.value =
  //         'حذف  ${product.idAmeen} - ${product.names[1]} - ${product.qty.value} صندوق';
  //
  //     appSetting.write(productsViewModel.keyValue,
  //         ProductModel.encode(productsViewModel.productsLocal));
  //   } else {
  //     _itemName.value = 'الصنف غير معبا مسبقاً';
  //     Get.snackbar("خطأ".tr, "الصنف غير معبا مسبقاً",
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  void calculateQuantity(List<ProductModel> products){
    productsViewModel.totalProduct.value=products.fold(0, (previousValue, element) => previousValue +  element.qty.value);
    productsViewModel.realTotalProduct.value=products.fold(0, (previousValue, element) => previousValue +  element.realQty.value);
    productsViewModel.countProduct.value=products.length;
    productsViewModel.countPalls.value=products.reduce((current, next) => current.pallNr.value > next.pallNr.value ? current : next).pallNr.value;

  }
}
