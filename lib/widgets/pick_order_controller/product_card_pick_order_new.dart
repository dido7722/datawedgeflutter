import 'package:cached_network_image/cached_network_image.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:datawedgeflutter/core/view_model/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/product_model.dart';
import '../../services/firebase_services.dart';
import '../controller/constants.dart';

class ProductCardPickOrderNew extends StatefulWidget {
  const ProductCardPickOrderNew(
      {required this.productModel,
      required this.index,
      required this.userId,
      required this.orderId,
      required this.findCode,
      Key? key})
      : super(key: key);
  final List<ProductModel> productModel;
  final int index;
  final String orderId;
  final String userId;
  final RxString findCode;

  @override
  State<ProductCardPickOrderNew> createState() =>
      _ProductCardPickOrderNewState();
}

class _ProductCardPickOrderNewState
    extends State<ProductCardPickOrderNew> {
  final appSetting = GetStorage(); // instance of getStorage class

  RxInt oldQty =0.obs;
  RxInt oldRealQty=0.obs;
  ProductsViewModel productsViewModel=Get.find();
  @override
  Widget build(BuildContext context) {

    RxBool finishPicked = widget.productModel[widget.index].finishPicked;
     oldRealQty = widget.productModel[widget.index].realQty;
     oldQty = widget.productModel[widget.index].qty;
    RxString commentQty = widget.productModel[widget.index].commentQty;
    RxInt pallNr = widget.productModel[widget.index].pallNr;
    return Obx(
      () => GestureDetector(
        onDoubleTap: (){
          RxInt newQty =oldQty.value.obs;
          RxInt newRealQty =oldRealQty.value.obs;
          Get.defaultDialog(
            title: 'الكميات',

            middleText: 'ما الكمية التي تريد إضافتها',
            // middleTextStyle:
            // TextStyle(
            //     color: Colors
            //         .white),
            textConfirm:
            "confirm".tr,
            textCancel:
            "cancel".tr,
            confirmTextColor:
            Colors.black,
            cancelTextColor:
            Colors.black,
            // buttonColor: Colors.black,
            barrierDismissible: false,
            radius: 30,
            onConfirm: () async{
              if(newRealQty.value> newQty.value ) {
                _showToast1(context);
              }else{
                if (oldRealQty != newRealQty) {
                  if (newRealQty == newQty) {
                    widget.productModel[widget.index].finishPicked.value = true;
                  } else {
                    widget.productModel[widget.index].finishPicked.value =
                    false;
                  }
                  widget.productModel[widget.index].realQty.value =
                      newRealQty.value;
                  productsViewModel.update();
                  appSetting.write(productsViewModel.keyValue,
                      ProductModel.encode(productsViewModel.productsLocal));
                  _showToast(context);
                }

                if (oldQty != newQty) {
                  if (newQty == newRealQty) {
                    widget.productModel[widget.index].finishPicked.value = true;
                  } else {
                    widget.productModel[widget.index].finishPicked.value =
                    false;
                  }
                  widget.productModel[widget.index].qty.value = newQty.value;
                  productsViewModel.update();
                  appSetting.write(productsViewModel.keyValue,
                      ProductModel.encode(productsViewModel.productsLocal));
                  _showToast(context);
                }

              }
              Get.back();

            },
            content:    Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('الكمية المطلوبة:'),
                      CustomizableCounter(
                        borderWidth: 2,
                        borderRadius: 50,
                        buttonText: "0",
                        textSize: 15,
                        count: oldQty.toDouble(),
                        step: 1,
                        minCount: 0,
                        maxCount: 100,
                        incrementIcon: const Icon(
                          Icons.add,
                        ),
                        decrementIcon: const Icon(
                          Icons.remove,
                        ),
                        onCountChange: (count) {
                          newQty.value=count.toInt();
                        },
                        onIncrement: (count) {
                          newQty.value=count.toInt();
                        },
                        onDecrement: (count) {
                          newQty.value=count.toInt();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('الكمية المعبئة:'),
                      CustomizableCounter(
                        borderWidth: 2,
                        borderRadius: 50,
                        buttonText: "0",
                        textSize: 15,
                        count: oldRealQty.toDouble(),
                        step: 1,
                        minCount: 0,
                        maxCount: 100,
                        incrementIcon: const Icon(
                          Icons.add,
                        ),
                        decrementIcon: const Icon(
                          Icons.remove,
                        ),
                        onCountChange: (count) {
                          newRealQty.value=count.toInt();
                        },
                        onIncrement: (count) {
                          newRealQty.value=count.toInt();
                        },
                        onDecrement: (count) {
                          newRealQty.value=count.toInt();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

          );
        },
        onLongPress: () async {
          Future updateBarcode() =>
              productsViewModel.updateBarcodes(
                  productModel:
                  widget.productModel[widget.index],
                  barcode1: '7318826540734',
                  barcode2: '',
                  barcode3: '',
                  barcodeNr: 1);
          List list=[];
          await   updateBarcode().then((value) => list=value);
          Get.back(closeOverlays: true);
          Get.defaultDialog(title: list[0],middleText: list[1],backgroundColor: list[2]=='true'?Colors.greenAccent:Colors.redAccent);
        },
        child: Container(
          height: Get.height * 0.15,
          decoration: BoxDecoration(
            color: (finishPicked.value && (oldRealQty.value.isEqual(oldQty.value)))
                ? Colors.lightGreenAccent
                : (finishPicked.value && (!oldRealQty.value.isEqual(oldQty.value)))
                    ? Colors.orangeAccent
                    : Colors.white,
            border: Border.all(
              color: const Color(0xff73747e),
              // width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ///Card Details
              GestureDetector(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (_) => Dialog(
                            child: Container(
                                child: PhotoView(
                                    imageProvider: CachedNetworkImageProvider(
                                        widget
                                            .productModel[widget.index].image))),
                          ));
                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl:
                        '${widget.productModel[widget.index].image}?${widget.productModel[widget.index].dateImage}',
                    maxWidthDiskCache: 50,
                    maxHeightDiskCache: 50,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_not_supported,
                      size: 25,
                      // color: Colors.red,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PrimaryText(
                      text: widget.productModel[widget.index].names[1],
                      fontWeight: FontWeight.w600,
                      size: 10.0.sp,
                      maxLine: 2,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PrimaryText(
                      text: widget.productModel[widget.index].brand[1] +
                          '  -  ' +
                          widget.productModel[widget.index].size[1],
                      size: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff73747e),
                      maxLine: 1,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: finishPicked.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: ElevatedButton(
                        clipBehavior: Clip.none,
                        onPressed: () {
                          finishPicked.value = false;
                          appSetting.write(productsViewModel.keyValue,
                              ProductModel.encode(productsViewModel.productsLocal));

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                          elevation: 0,
                        ),
                        child: Container(
                            color: Colors.lightGreen,
                            alignment: Alignment.center,
                            child: const Center(child: Text('تعديل'))),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: !finishPicked.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: SizedBox(
                        width: 15.w,
                        height: 5.w,
                        child: ElevatedButton(
                          clipBehavior: Clip.none,
                          onPressed: () {
                            finishPicked.value = true;
                              oldRealQty.value = oldQty.value;
                            appSetting.write(productsViewModel.keyValue,
                                ProductModel.encode(productsViewModel.productsLocal));

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            elevation: 0,
                          ),
                          child: Container(
                              color: Colors.lightGreen,
                              alignment: Alignment.center,
                              child: Center(
                                  child: PrimaryText(
                                text: 'All',
                                size: 10.sp,
                                color: Colors.white,
                              ))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: SizedBox(
                        width: 15.w,
                        height: 5.w,
                        child: ElevatedButton(
                          onPressed: () {
                            oldRealQty.value = 0;
                            finishPicked.value = true;
                            appSetting.write(productsViewModel.keyValue,
                                ProductModel.encode(productsViewModel.productsLocal));

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            elevation: 0,
                          ),
                          child: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.center,
                              child: Center(
                                  child: PrimaryText(
                                text: 'No',
                                size: 10.sp,
                                color: Colors.white,
                              ))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('المطلوبة'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color(0xff73747e),
                          // width: 1.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xff73747e),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(2, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      width: 30,
                      alignment: Alignment.center,
                      child: PrimaryText(
                        text: oldQty.toString(),
                        size: 15.sp,
                        fontWeight: FontWeight.w600,
                        // color: Color(0xff73747e),
                        maxLine: 1,
                      ),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onDoubleTap: () {
                  if (!finishPicked.value) {
                    oldRealQty.value = oldQty.value;
                    appSetting.write(productsViewModel.keyValue,
                        ProductModel.encode(productsViewModel.productsLocal));
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('المعبئة'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: const Color(0xff73747e),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xff73747e),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(2, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 30,
                        alignment: Alignment.center,
                        child: PrimaryText(
                          text: oldRealQty.toString(),
                          size: 15.sp,
                          fontWeight: FontWeight.w600,
                          maxLine: 1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('${widget.productModel[widget.index].names[1]}  ${widget.productModel[widget.index].size[0]}'),
        duration:const Duration(milliseconds: 2500),
        action: SnackBarAction(label: 'تم التعديل الى $oldQty صندوق', onPressed: scaffold.hideCurrentSnackBar,textColor: Colors.white,),
      ),
    );
  }
  void _showToast1(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('لا يمكنك تعبئة كمية اكثر من المطلوبة'),
        duration:const Duration(milliseconds: 2500),
        action: SnackBarAction(label: '${widget.productModel[widget.index].names[1]}  ${widget.productModel[widget.index].size[0]}', onPressed: scaffold.hideCurrentSnackBar,textColor: Colors.white,),
      ),
    );
  }

}
