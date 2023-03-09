import 'dart:convert';

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
import '../core/view_model/products_view_model.dart';
import '../services/pages_arguments.dart';
import '../widgets/controller/constants.dart';
import '../widgets/controller/custom_action_bar.dart';
import '../widgets/pick_order_controller/product_card_pick_order_kund.dart';

class PickOrderPageLocally extends StatefulWidget {
  PickOrderPageLocally({Key? key}) : super(key: key);

  @override
  State<PickOrderPageLocally> createState() => _PickOrderPageLocallyState();
}

class _PickOrderPageLocallyState extends State<PickOrderPageLocally> {
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

  CartProductsViewModel controller = Get.find();

  ProductsViewModel productsViewModel = Get.find();
  late OrderModel orderModel;
  List localList = [];
  final itemScrollController = ItemScrollController();
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as OrderPageArguments;
    orderModel = args.orderModel;
    productsViewModel.productsLocal.clear();
    productsViewModel.keyValue = 'key-${orderModel.sort}';

    if (appSetting.hasData(productsViewModel.keyValue)) {
      final String musicsString = appSetting.read(productsViewModel.keyValue);
      productsViewModel.productsLocal.addAll(ProductModel.decode(musicsString));
    } else {
      final String encodedData = ProductModel.encode([]);
      appSetting.write(productsViewModel.keyValue, encodedData);
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
                  color:
                      connected.value ? Color(0xFF00EE44) : Color(0xFFEE4400),
                  child: Center(
                    child: Text("${connected.value ? 'ONLINE' : 'OFFLINE'}"),
                  ),
                ),
              ),
              Center(
                child:
                    // Container()
                    Obx(
                  () => (controller.loading.value)
                      ? const Center(child: CircularProgressIndicator())
                      : SafeArea(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    CustomActionBar(
                                      title:
                                          '${orderModel.userName} - ${orderModel.nickName}',
                                      hasBackArrowWidget: true,
                                      hasSearchWidget: false,
                                      hasTitleWidget: true,
                                      hasCartQtyWidget: false,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                              'الكمية المعبئة: ${productsViewModel.productsLocal.fold(0, (int previousValue, element) => previousValue + element.qty.value)}'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                              'عدد الأقلام: ${productsViewModel.productsLocal.length}'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/SearchPage');
                                                productsViewModel.update();
                                                // itemScrollController.jumpTo(index: productsViewModel. productsLocal.length);
                                              },
                                              icon: Icon(Icons.search)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: Get.width * 0.6,
                                            child: PrimaryText(
                                              text: ' ${_itemName.value}',
                                              color: _isAdd.value
                                                  ? Colors.green
                                                  : Colors.redAccent,
                                              size: 12.sp,
                                              maxLine: 2,
                                            ),
                                          ),
                                        ),
                                        CupertinoSwitch(
                                          trackColor: Colors.redAccent,
                                          value: _isAdd.value,
                                          onChanged: (value) {
                                            setState(() {
                                              _itemName.value = '';
                                              _isAdd.value = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: ScrollablePositionedList
                                                .builder(
                                              reverse: true,
                                              itemCount: productsViewModel
                                                  .productsLocal.length,
                                              itemScrollController:
                                                  itemScrollController,
                                              itemBuilder: (_, index) {
                                                return productsViewModel
                                                        .productsLocal
                                                        .isNotEmpty
                                                    ? Dismissible(
                                                        key: ValueKey(
                                                            productsViewModel
                                                                .productsLocal[
                                                                    index]
                                                                .toString()),
                                                        confirmDismiss:
                                                            (direction) async {
                                                          return await showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title:
                                                                    Text('حذف'),
                                                                content: Text(
                                                                    ' هل انت متاكد من حذف: \n${productsViewModel.productsLocal[index].names[1]} ${productsViewModel.productsLocal[index].size[0]}'),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        removeItem(productsViewModel
                                                                            .productsLocal[index]
                                                                            .idAmeen);
                                                                        Navigator.of(context)
                                                                            .pop(true);
                                                                      },
                                                                      child: Text(
                                                                          "حذف")),
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(false),
                                                                    child: Text(
                                                                        "الفاء"),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        onDismissed:
                                                            (DismissDirection
                                                                direction) {},
                                                        background: Container(
                                                          color:
                                                              Colors.redAccent,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        child: GestureDetector(
                                                          onDoubleTap: () {
                                                            Get.defaultDialog(
                                                              title: 'إضافة/حذف'
                                                                  .tr,
                                                              backgroundColor: _isAdd
                                                                      .value
                                                                  ? Colors
                                                                      .greenAccent
                                                                  : Colors
                                                                      .redAccent,
                                                              middleText: _isAdd
                                                                      .value
                                                                  ? 'هل تريد' +
                                                                      'اضافة ' +
                                                                      productsViewModel
                                                                              .productsLocal[index].names[
                                                                          1]
                                                                  : 'هل تريد' +
                                                                      'حذف ' +
                                                                      productsViewModel
                                                                          .productsLocal[
                                                                              index]
                                                                          .names[1],
                                                              middleTextStyle:
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                              textConfirm:
                                                                  "confirm".tr,
                                                              textCancel:
                                                                  "cancel".tr,
                                                              confirmTextColor:
                                                                  Colors.white,
                                                              cancelTextColor:
                                                                  Colors.white,
                                                              // buttonColor: Colors.white,
                                                              // barrierDismissible: false,
                                                              radius: 30,
                                                              onConfirm: () {
                                                                addRemoveItem(
                                                                    productsViewModel
                                                                        .productsLocal[
                                                                            index]
                                                                        .idAmeen);
                                                                Get.back();
                                                              },
                                                            );
                                                          },
                                                          child:
                                                              ProductCardPickOrderKund(
                                                            index: index,
                                                            productModel:
                                                                productsViewModel
                                                                    .productsLocal
                                                                    .toList(),
                                                            orderId:
                                                                orderModel.id,
                                                            userId: orderModel
                                                                .userID,
                                                            findCode:
                                                                barcodeCode,
                                                          ),
                                                        ),
                                                      )
                                                    : Container();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
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
    } else {
      Get.snackbar("خطأ".tr, "الصنف غير موجود او غير معرف",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void addRemoveItem(String idAmeen) {
    if (_isAdd.value) {
      if (productsViewModel.productsLocal
          .where((p0) => p0.idAmeen == idAmeen)
          .isNotEmpty) {
        var product = productsViewModel.productsLocal
            .where((p0) => p0.idAmeen == idAmeen)
            .first;
        if (product.qty.value == 0) {
          product.qty.value = 1;
          productsViewModel.productsLocal.add(product);
        } else {
          var product = productsViewModel.productsLocal
              .where((p0) => p0.idAmeen == idAmeen)
              .first;
          product.qty.value += 1;
          productsViewModel.productsLocal
              .removeWhere((p0) => p0.idAmeen == idAmeen);
          productsViewModel.productsLocal.add(product);
        }
        appSetting.write(productsViewModel.keyValue,
            ProductModel.encode(productsViewModel.productsLocal));
        _itemName.value =
            'اضافة ${product.idAmeen} - ${product.names[1]} - ${product.qty.value} صندوق';
      } else {
        productsViewModel.productsLocal.add(productsViewModel.productsList
            .where((p0) => p0.idAmeen == idAmeen)
            .first);
        _itemName.value =
            'اضافة ${productsViewModel.productsList.where((p0) => p0.idAmeen == idAmeen).first.idAmeen} - ${productsViewModel.productsList.where((p0) => p0.idAmeen == idAmeen).first.names[1]}  - ${productsViewModel.productsList.where((p0) => p0.idAmeen == idAmeen).first.qty.value} صندوق';
        appSetting.write(productsViewModel.keyValue,
            ProductModel.encode(productsViewModel.productsLocal));
      }
      if (productsViewModel.productsLocal.length > 1) {
        itemScrollController.jumpTo(
            index: productsViewModel.productsLocal.length);
      }
    } else {
      if (productsViewModel.productsLocal
          .where((p0) => p0.idAmeen == idAmeen)
          .isNotEmpty) {
        var product = productsViewModel.productsLocal
            .where((p0) => p0.idAmeen == idAmeen)
            .first;
        if (product.qty.value == 1) {
          productsViewModel.productsLocal.remove(product);
        } else {
          productsViewModel.productsLocal
              .where((p0) => p0.idAmeen == idAmeen)
              .first
              .qty
              .value -= 1;
        }
        _itemName.value =
            'حذف  ${product.idAmeen} - ${product.names[1]} - ${product.qty.value} صندوق';

        appSetting.write(productsViewModel.keyValue,
            ProductModel.encode(productsViewModel.productsLocal));
      } else {
        _itemName.value = 'الصنف غير معبا مسبقاً';
        Get.snackbar("خطأ".tr, "الصنف غير معبا مسبقاً",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void removeItem(String idAmeen) {
    if (productsViewModel.productsLocal
        .where((p0) => p0.idAmeen == idAmeen)
        .isNotEmpty) {
      var product = productsViewModel.productsLocal
          .where((p0) => p0.idAmeen == idAmeen)
          .first;
      productsViewModel.productsLocal.remove(product);

      _itemName.value =
          'حذف  ${product.idAmeen} - ${product.names[1]} - ${product.qty.value} صندوق';

      appSetting.write(productsViewModel.keyValue,
          ProductModel.encode(productsViewModel.productsLocal));
    } else {
      _itemName.value = 'الصنف غير معبا مسبقاً';
      Get.snackbar("خطأ".tr, "الصنف غير معبا مسبقاً",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
