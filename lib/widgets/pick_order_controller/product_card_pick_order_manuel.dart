import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/product_model.dart';
import '../../services/firebase_services.dart';
import '../controller/constants.dart';

class ProductCardPickOrderManuel extends StatefulWidget {
  const ProductCardPickOrderManuel(
      {required this.productModel, required this.index,required this.userId,required this.orderId ,Key? key})
      : super(key: key);
  final List<ProductModel> productModel;
  final int index;
  final String orderId;
  final String userId;

  @override
  State<ProductCardPickOrderManuel> createState() => _ProductCardPickOrderManuelState();
}

class _ProductCardPickOrderManuelState extends State<ProductCardPickOrderManuel> {
  @override
  Widget build(BuildContext context) {
    RxBool finishPicked = widget.productModel[widget.index].finishPicked;
    RxInt realQty = widget.productModel[widget.index].realQty;
    RxInt qty = widget.productModel[widget.index].qty;
    RxString commentQty = widget.productModel[widget.index].commentQty;
    RxInt pallNr = widget.productModel[widget.index].pallNr;
    final text1 = TextEditingController(text: commentQty.value);
    return Obx(
      () => Container(
        height: Get.height * 0.2,
        decoration: BoxDecoration(
          color: (finishPicked.value && (realQty.value.isEqual(qty.value)))
              ? Colors.lightGreenAccent
              : (finishPicked.value && (!realQty.value.isEqual(qty.value)))
                  ? Colors.orangeAccent
                  : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xff73747e),
            width: 1.5,
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
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ///Card Details
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
                        FirebaseServices().updatePickedOrder(orderId:widget.orderId,userID:widget.userId,commentQty:commentQty.value,realQty:realQty.value,productId:widget.productModel[widget.index].id,finishPicked: finishPicked.value,pallNr: pallNr.value);

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: SizedBox(
                      width: 10.w,
                      child: IconButton(
                        color: Colors.greenAccent,
                        onPressed: () {
                          finishPicked.value = true;
                          if(realQty.value.isEqual(0)){
                            realQty.value=qty.value;
                          }
                          FirebaseServices().updatePickedOrder(orderId:widget.orderId,userID:widget.userId,commentQty:commentQty.value,realQty:realQty.value,productId:widget.productModel[widget.index].id,finishPicked: finishPicked.value,pallNr: pallNr.value);
                        }, icon: Icon(Icons.done_all),
                        // style: ElevatedButton.styleFrom(
                        //   primary: Colors.lightGreen,
                        //   elevation: 0,
                        // ),
                        // child: Container(
                        //     color: Colors.lightGreen,
                        //     alignment: Alignment.center,
                        //     child: const Center(child: Icon(Icons.done_all))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: SizedBox(
                      width: 10.w,
                      child: IconButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          realQty.value = 0;
                          finishPicked.value = true;
                          FirebaseServices().updatePickedOrder(orderId:widget.orderId,userID:widget.userId,commentQty:commentQty.value,realQty:realQty.value,productId:widget.productModel[widget.index].id,finishPicked: finishPicked.value,pallNr: pallNr.value);

                        }, icon: Icon(Icons.cancel_outlined,),
                        // style: ElevatedButton.styleFrom(
                        //   primary: Colors.redAccent,
                        // ),
                        // child: const Icon(
                        //   Icons.cancel_outlined,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () {
                if (!finishPicked.value) {
                  realQty.value = qty.value;
                  FirebaseServices().updatePickedOrder(orderId:widget.orderId,userID:widget.userId,commentQty:commentQty.value,realQty:realQty.value,productId:widget.productModel[widget.index].id,finishPicked: finishPicked.value,pallNr: pallNr.value);

                }
              },
              child: Column(
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
            ),
            Visibility(
              visible: !finishPicked.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('الكمبة'),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: AppColors.lighterGrayColor,
                      border: Border.all(
                        color: Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 20.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      verticalDirection: VerticalDirection.up,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: 26,
                            height: 26,
                            child:  FloatingActionButton(
                              onPressed: () {
                                if (realQty.value <= 0) {
                                  realQty.value = 0;
                                } else {
                                  realQty.value -= 1;
                                  FirebaseServices().updatePickedOrder(orderId:widget.orderId,userID:widget.userId,commentQty:commentQty.value,realQty:realQty.value,productId:widget.productModel[widget.index].id,finishPicked: finishPicked.value,pallNr: pallNr.value);
                                }

                              },
                              backgroundColor: Colors.redAccent,
                              child: const Icon(Icons.remove_outlined),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 26,
                              height: 26,
                              child: PrimaryText(
                                text: realQty.value.toString(),
                                size: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: 26,
                            height: 26,
                            child: FloatingActionButton(
                              onPressed: () {
                                realQty.value += 1;
                                FirebaseServices().updatePickedOrder(orderId:widget.orderId,userID:widget.userId,commentQty:commentQty.value,realQty:realQty.value,productId:widget.productModel[widget.index].id,finishPicked: finishPicked.value,pallNr: pallNr.value);

                              },
                              backgroundColor: Colors.redAccent,
                              child:
                                  const Center(child: Icon(Icons.add_outlined)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !finishPicked.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('رقم البال'),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: 20.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Flexible(
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child:  FloatingActionButton(
                                onPressed: () {
                                  if (pallNr.value <= 0 || pallNr.value -1 ==0 ) {
                                    pallNr.value = 1;
                                  } else {
                                    pallNr.value -= 1;
                                    FirebaseServices().updatePickedOrder(orderId:widget.orderId,userID:widget.userId,commentQty:commentQty.value,realQty:realQty.value,productId:widget.productModel[widget.index].id,finishPicked: finishPicked.value,pallNr: pallNr.value);
                                  }

                                },
                                backgroundColor: Colors.redAccent,
                                child: const Icon(Icons.remove_outlined),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Container(
                                alignment: Alignment.center,
                                width: 26,
                                height: 26,
                                child: PrimaryText(
                                  text: pallNr.value.toString(),
                                  size: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: FloatingActionButton(
                                onPressed: () {
                                  pallNr.value += 1;
                                  FirebaseServices().updatePickedOrder(orderId:widget.orderId,userID:widget.userId,commentQty:commentQty.value,realQty:realQty.value,productId:widget.productModel[widget.index].id,finishPicked: finishPicked.value,pallNr: pallNr.value);
                                },
                                backgroundColor: Colors.redAccent,
                                child:
                                    const Center(child: Icon(Icons.add_outlined)),
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
            Visibility(
              visible: finishPicked.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('المعبئة'),
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
                        text: realQty.value.toString(),
                        size: 15.sp,
                        fontWeight: FontWeight.w600,
                        // color: Color(0xff73747e),
                        maxLine: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: finishPicked.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('رقم البال'),
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
                        text: pallNr.value.toString(),
                        size: 15.sp,
                        fontWeight: FontWeight.w600,
                        // color: Color(0xff73747e),
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
    );
  }
}
