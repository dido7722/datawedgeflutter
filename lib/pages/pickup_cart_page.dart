import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../core/model/order_model.dart';
import '../core/model/product_model.dart';
import '../core/view_model/cart_products_view_model.dart';
import '../core/view_model/products_view_model.dart';
import '../services/firebase_services.dart';
import '../services/pages_arguments.dart';
import '../widgets/controller/constants.dart';
import '../widgets/controller/custom_action_bar.dart';
import '../widgets/pick_order_controller/product_card_pick_order_kund.dart';

class PickCartPage extends StatefulWidget {
  PickCartPage({Key? key}) : super(key: key);

  @override
  State<PickCartPage> createState() => _PickCartPageState();
}

class _PickCartPageState extends State<PickCartPage> {
  final RxString barcodeCode = ''.obs;

  final RxString findCode = ''.obs;

  final barcodeController = TextEditingController();

  final findController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as OrderPageArguments;
    orderModel = args.orderModel;
    return new Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          connected.value = connectivity != ConnectivityResult.none;
          // connected.value=true;
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
                child: Obx(
                  () => (controller.loading.value)
                      ? const Center(child: CircularProgressIndicator())
                      : SafeArea(
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
                                                'الكمية المعبئة: ${controller.realTotalProduct.value}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                                'عدد الأقلام: ${controller.productsList.length}'),
                                          ),
                                        ],
                                      ),

                                      Flexible(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: ListView.builder(
                                                reverse: true,
                                                itemCount: controller
                                                    .productsList.length,
                                                itemBuilder: (_, index) {
                                                  return
                                                    ProductCardPickOrderKund(
                                                      index: index,
                                                      productModel: controller
                                                          .productsList
                                                          .toList(),
                                                      orderId: orderModel.id,
                                                      userId: orderModel.userID,
                                                      findCode: barcodeCode,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!connected.value)
                                  Center(
                                      child: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    color: Colors.redAccent,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('جاري انتظار الاتصال بالانترنت'),
                                        CircularProgressIndicator(),
                                      ],
                                    ),
                                  )),
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

  Future<void> getItem(String value, OrderModel orderModel,
      ProductsViewModel productsViewModel, BuildContext context) async {

    if (controller.productsList.where((p0) => p0.idAmeen == value).isNotEmpty) {
      ProductModel product =
          controller.productsList.where((p0) => p0.idAmeen == value).first;

      await FirebaseServices().addOrderProduct(orderModel.id, product);
    } else if (productsViewModel.productsList
            .where((p0) => p0.idAmeen == value)
            .length ==
        1) {
      ProductModel product = productsViewModel.productsList
          .where((p0) => p0.idAmeen == value)
          .first;
      await FirebaseServices().addOrderProduct(orderModel.id, product);
      Get.back();
    } else if (productsViewModel.productsList
            .where((p0) => p0.idAmeen == value)
            .length >
        1) {
      var products = productsViewModel.productsList
          .where((p0) => p0.idAmeen == value)
          .toList();
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return DraggableScrollableSheet(
                  expand: false,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Column(children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            controller: scrollController,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FadeInImage(
                                      image:
                                          NetworkImage(products[index].image),
                                      width: 12.w,
                                      height: 12.h,
                                      fit: BoxFit.fitWidth,
                                      placeholder: const AssetImage(
                                          'assets/images/icons/placeholder.jpg'),
                                    ),
                                    PrimaryText(
                                      text: products[index].names[1],
                                      size: 12.sp,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          orderModel.productModel
                                              .add(products[index]);
                                          await FirebaseServices().addOrderProduct(
                                              orderModel.id,
                                              products[
                                                  index]); // await FirebaseServices().addOrderProduct(orderModel.id, list);
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.add))
                                  ],
                                ),
                              );
                            }),
                      )
                    ]);
                  });
            });
          });
    } else {
      Get.snackbar("خطأ".tr, "الصنف غير موجود او غير معرف",
          snackPosition: SnackPosition.BOTTOM);
    }

  }

}
