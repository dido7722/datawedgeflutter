import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../core/model/order_model.dart';
import '../core/view_model/order_products_view_model.dart';
import '../services/firebase_services.dart';
import '../services/pages_arguments.dart';
import '../widgets/controller/constants.dart';
import '../widgets/controller/custom_action_bar.dart';
import '../widgets/pick_order_controller/product_card_pick_order_second.dart';

class PickOrderPageBarcode extends StatefulWidget {

   PickOrderPageBarcode({Key? key}) : super(key: key);

  @override
  State<PickOrderPageBarcode> createState() => _PickOrderPageBarcodeState();
}

class _PickOrderPageBarcodeState extends State<PickOrderPageBarcode> {
  final RxString barcodeCode = ''.obs;

  final RxString findCode = ''.obs;

  final myController = TextEditingController();

  final findController = TextEditingController();

  OrderProductsViewModel controller=Get.find();
  static const MethodChannel methodChannel =
  MethodChannel('com.darryncampbell.datawedgeflutter/command');
  static const EventChannel scanChannel =
  EventChannel('com.darryncampbell.datawedgeflutter/scan');


  Future<void> _createProfile(String profileName) async {
    try {
      await methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
    }
  }

  String _barcodeString = "بدا التعبئة";
  RxBool _isAdd=true.obs;
  RxString _itemName=''.obs;
  @override
  void initState() {
    super.initState();
    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _createProfile("DataWedgeFlutterDemo");
  }

  Future<void> _onEvent(event) async {
    setState(()  {
      Map barcodeScan = jsonDecode(event);
      _barcodeString =  barcodeScan['scanData'];
    });
    addItem(_barcodeString, orderModel);

  }
  late OrderModel orderModel;
  void _onError(Object error) {
    setState(() {
      _barcodeString = "Barcode: error";
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as OrderPageArguments;
     orderModel = args.orderModel;

    return
      new Scaffold(
        body: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
              ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return new Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  height: 24.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                    child: Center(
                      child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                    ),
                  ),
                ),
                Center(
                  child:
                  Obx(() => (controller.loading.value)
                      ? const Center(child: CircularProgressIndicator())
                      :
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
                                        child: Text('المطلوبة: ${controller.totalProduct.value}'),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text('الكمية المعبئة: ${controller.realTotalProduct.value}'),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          'الباقي: ${controller.totalProduct.value -
                                              controller.realTotalProduct.value}',
                                          style: const TextStyle(color: Colors.redAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text('عدد البالات: ${controller.countPalls.value}'),
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

                                          child: PrimaryText(text: ' ${_itemName.value} // $_barcodeString',color: _isAdd.value? Colors.green:Colors.redAccent,size: 14.sp,),
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

                                          Expanded(
                                            child: TabBarView(
                                              children: [
                                                ListView.builder(
                                                  itemCount: controller.productsList.where((p0) => !p0.finishPicked.value && p0.toString().toLowerCase().contains(findCode.toLowerCase())).length,
                                                  itemBuilder: (_, index) {
                                                    return ProductCardPickOrderSecond(
                                                      index: index,
                                                      productModel: controller
                                                          .productsList.where((p0) => !p0.finishPicked.value && p0.toString().toLowerCase().contains(findCode.toLowerCase()))
                                                          .toList(),
                                                      orderId: orderModel.id,
                                                      userId: orderModel.userID,
                                                      findCode: barcodeCode,
                                                    );
                                                  },
                                                ),
                                                ListView.builder(
                                                  itemCount: controller.productsList.where((p0) => p0.finishPicked.value && p0.toString().toLowerCase().contains(findCode.toLowerCase())).length,
                                                  itemBuilder: (_, index) {
                                                    return ProductCardPickOrderSecond(
                                                      index: index,
                                                      productModel: controller
                                                          .productsList.
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

  void addItem(String value, OrderModel orderModel) {

    if(controller.productsList.where((p0) => p0.idAmeen==value).isNotEmpty) {
      var product = controller.productsList
          .where((p0) => p0.idAmeen == value)
          .first;
      _itemName.value = product.names[1];

      if(_isAdd.value) {
        if (product.finishPicked.value) {
          Get.snackbar("خطأ".tr, "الصنف معبأ مسبقاً",
              snackPosition: SnackPosition.BOTTOM);
        } else {
          if (product.realQty != product.qty) {
            RxBool finished = false.obs;
            if (product.realQty.value + 1 == product.qty.value) {
              finished.value = true;
            }
            FirebaseServices().updatePickedOrder(orderId: orderModel.id,
                userID: orderModel.userID,
                commentQty: '',
                realQty: product.realQty.value + 1,
                productId: product.id,
                finishPicked: finished.value,
                pallNr: 1);
          } else {
            Get.snackbar("خطأ".tr, "خطأ 331",
                snackPosition: SnackPosition.BOTTOM);
          }
        }
      }
      else{
        if (product.realQty.value.isEqual(0)) {
          Get.snackbar("خطأ".tr, "الصنف $value غير معبأ مسبقاً",
              snackPosition: SnackPosition.BOTTOM);
        } else {
          if (product.realQty.value == product.qty.value) {
            RxBool finished = false.obs;
            // if (product.realQty.value - 1 == product.qty.value) {
            //   finished.value = true;
            // }
            _itemName.value = product.names[1];
            FirebaseServices().updatePickedOrder(orderId: orderModel.id,
                userID: orderModel.userID,
                commentQty: '',
                realQty: product.realQty.value - 1,
                productId: product.id,
                finishPicked: finished.value,
                pallNr: 1);
          } else {
            RxBool finished = false.obs;
            FirebaseServices().updatePickedOrder(orderId: orderModel.id,
                userID: orderModel.userID,
                commentQty: '',
                realQty: product.realQty.value - 1,
                productId: product.id,
                finishPicked: finished.value,
                pallNr: 1);
          }
        }

      }
    }else{
      Get.snackbar("خطأ".tr, "الصنف $value  غير موجود في الطلبية",
          snackPosition: SnackPosition.BOTTOM);
      _itemName.value = 'غير موجود في الطلبية';


    }
  }
}
