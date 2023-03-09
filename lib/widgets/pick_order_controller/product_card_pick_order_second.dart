import 'package:cached_network_image/cached_network_image.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/product_model.dart';
import '../../services/firebase_services.dart';
import '../controller/constants.dart';

class ProductCardPickOrderSecond extends StatefulWidget {
  const ProductCardPickOrderSecond(
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
  State<ProductCardPickOrderSecond> createState() =>
      _ProductCardPickOrderSecondState();
}

class _ProductCardPickOrderSecondState
    extends State<ProductCardPickOrderSecond> {
  @override
  Widget build(BuildContext context) {
    RxBool finishPicked = widget.productModel[widget.index].finishPicked;
    RxInt realQty = widget.productModel[widget.index].realQty;
    RxInt qty = widget.productModel[widget.index].qty;
    RxString commentQty = widget.productModel[widget.index].commentQty;
    RxInt pallNr = widget.productModel[widget.index].pallNr;

    return Obx(
      () => GestureDetector(
        onDoubleTap: (){
          Get.defaultDialog(
            title: 'الكمية',

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
            onConfirm: () {
              // try {
                // qty = int.parse(
                //     textEditingController.text);
              // }catch(e){
              //   qty=1;
              // }
              // FirebaseServices().addProductToOrder(orderId:widget.orderModel.id,userID:widget.orderModel.userID,commentQty:widget.orderModel.comment,realQty:qty,productId:widget.productModel[widget.index].id,finishPicked: false,pallNr: 0);
              //
              // Get.back();
              // _showToast(context);

            },
            content:    CustomizableCounter(
              // borderColor: Colors.yellow,
              borderWidth: 2,
              borderRadius: 50,
              // backgroundColor: Colors.amberAccent,
              buttonText: "0",
              // textColor: Colors.white,
              textSize: 15,
              count: qty.toDouble(),
              step: 1,
              minCount: 0,
              maxCount: 100,
              incrementIcon: const Icon(
                Icons.add,
                // color: Colors.white,
              ),
              decrementIcon: const Icon(
                Icons.remove,
                // color: Colors.white,
              ),
              onCountChange: (count) {
                print('count:$count');
              },
              onIncrement: (count) {
                print('onIncrement:$count');
              },
              onDecrement: (count) {
                print('onDecrement:$count');

              },
            ),

          );
        },
        child: Container(
          height: Get.height * 0.15,
          decoration: BoxDecoration(
            color: (finishPicked.value && (realQty.value.isEqual(qty.value)))
                ? Colors.lightGreenAccent
                : (finishPicked.value && (!realQty.value.isEqual(qty.value)))
                    ? Colors.orangeAccent
                    : Colors.white,
            // borderRadius: BorderRadius.circular(5),
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
                          FirebaseServices().updatePickedOrder(
                              orderId: widget.orderId,
                              userID: widget.userId,
                              commentQty: commentQty.value,
                              realQty: realQty.value,
                              productId: widget.productModel[widget.index].id,
                              finishPicked: finishPicked.value,
                              pallNr: pallNr.value);
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
                            if (realQty.value.isEqual(0)) {
                              realQty.value = qty.value;
                            }

                            FirebaseServices().updatePickedOrder(
                                orderId: widget.orderId,
                                userID: widget.userId,
                                commentQty: commentQty.value,
                                realQty: realQty.value,
                                productId: widget.productModel[widget.index].id,
                                finishPicked: finishPicked.value,
                                pallNr: pallNr.value);
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
                            realQty.value = 0;
                            finishPicked.value = true;
                            FirebaseServices().updatePickedOrder(
                                orderId: widget.orderId,
                                userID: widget.userId,
                                commentQty: commentQty.value,
                                realQty: realQty.value,
                                productId: widget.productModel[widget.index].id,
                                finishPicked: finishPicked.value,
                                pallNr: pallNr.value);
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
                        text: qty.toString(),
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
                    realQty.value = qty.value;
                    FirebaseServices().updatePickedOrder(
                        orderId: widget.orderId,
                        userID: widget.userId,
                        commentQty: commentQty.value,
                        realQty: realQty.value,
                        productId: widget.productModel[widget.index].id,
                        finishPicked: finishPicked.value,
                        pallNr: pallNr.value);
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
                          text: realQty.toString(),
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
}
