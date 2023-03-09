import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/model/product_model.dart';
import '../../services/firebase_services.dart';
import '../controller/constants.dart';

class ProductCard extends StatefulWidget {
  ProductCard({required this.productModel, required this.index, Key? key})
      : super(key: key);
  final List<ProductModel> productModel;
  final int index;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ProductCardState extends State<ProductCard> {
  static const MethodChannel methodChannel =
      MethodChannel('com.darryncampbell.datawedgeflutter/command');
  static const EventChannel scanChannel =
      EventChannel('com.darryncampbell.datawedgeflutter/scan');
  String _barcodeString = "Barcode will be shown here";
  @override
  void initState() {
    super.initState();
    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _createProfile("DataWedgeFlutterDemo");
  }

  Future<void> _onEvent(event) async {
    if (mounted) {
      setState(() {
        Map barcodeScan = jsonDecode(event);
        _barcodeString = barcodeScan['scanData'];
      });
    }
  }

  RxBool flag = false.obs;
  Future<void> _createProfile(String profileName) async {
    try {
      await methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  void _onError(Object error) {
    setState(() {
      _barcodeString = "Barcode: error";
    });
  }

  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var dateImg = DateTime.parse(widget.productModel[widget.index].dateImage)
        .millisecondsSinceEpoch;

    String barcode1 = widget.productModel[widget.index].barcode1.value;
    String barcode2 = widget.productModel[widget.index].barcode2.value;
    String barcode3 = widget.productModel[widget.index].barcode3.value;

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Color(0xff73747e),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff73747e),
              spreadRadius: 0,
              blurRadius: 1,
              offset: Offset(2, 0), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ///Image
            Container(
              // width: MediaQuery.of(context).size.width * 0.30,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: Container(
                                child: PhotoView(
                                    imageProvider: CachedNetworkImageProvider(
                                        widget.productModel[widget.index].image
                                    )
                                )
                            ),
                          )
                      );

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xff73747e),
                          width: 0.1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff73747e),
                            spreadRadius: 0,
                            blurRadius: 0.1,
                            offset: Offset(0.1, 0),
                          ),
                        ],
                      ),
                      margin:
                          EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
                      child: Container(
                        width: 75,
                        height: 75,
                        child: CachedNetworkImage(
                          width: 75,
                          height: 75,
                          imageUrl: widget.productModel[widget.index].image +
                              '?' +
                              dateImg.toString(),
                          maxWidthDiskCache: 75,
                          maxHeightDiskCache: 75,
                          errorWidget: (context, url, error) => Icon(
                            Icons.image_not_supported,
                            size: 25,
                            // color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ), //Image
                ],
              ),
            ),

            ///Card Details

            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Title
                  Container(
                    child: PrimaryText(
                      text: widget.productModel[widget.index].names[1],
                      fontWeight: FontWeight.w600,
                      size: 12.sp,
                      maxLine: 2,
                    ),

                    ///Title
                  ),
                  Container(
                      child: PrimaryText(
                    text: widget.productModel[widget.index].brand[1],
                    size: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff73747e),
                    maxLine: 1,
                  )

                      ///brand
                      ),
                  Container(
                      child: PrimaryText(
                    text: widget.productModel[widget.index].size[1],
                    size: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff73747e),
                    maxLine: 1,
                  ) //size

                      ),
                  Container(
                      child: PrimaryText(
                    text: widget.productModel[widget.index].categoryName
                        .toString(),
                    size: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff73747e),
                    maxLine: 1,
                  ) //size

                      ),
                  Container(
                      child: PrimaryText(
                    text: widget.productModel[widget.index].id.toString(),
                    size: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff73747e),
                    maxLine: 1,
                  ) //size

                      ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            PrimaryText(
                              text: 'طباعة'.tr,
                              fontWeight: FontWeight.w600,
                              size: 11.0.sp,
                              maxLine: 1,
                            ),
                            Container(
                              child: Checkbox(
                                onChanged: (bool? value) {
                                  setState(() {
                                    widget.productModel[widget.index].isPrint
                                            .value =
                                        !widget.productModel[widget.index]
                                            .isPrint.value;
                                  });
                                },
                                value: widget
                                    .productModel[widget.index].isPrint.value,
                              ),

                              ///Title
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              // alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      flag.value = true;
                      TextEditingController textEditingController =
                          TextEditingController();
                      textEditingController.text = barcode1;
                      _focusNode.addListener(() {
                        if (_focusNode.hasFocus) {
                          textEditingController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: textEditingController.text.length);
                        }
                      });

                      Get.defaultDialog(
                        title: 'باركود1'.tr,
                        textConfirm: "confirm".tr,
                        textCancel: "cancel".tr,
                        buttonColor: AppColors.activeColor,
                        barrierDismissible: false,
                        radius: 30,
                        onConfirm: () {
                          widget.productModel[widget.index].barcode1.value =
                              barcode1;
                          Future updateBarcode() =>
                              FirebaseServices().updateBarcode(
                                  productModel:
                                      widget.productModel[widget.index]);
                          updateBarcode();
                          Get.back(closeOverlays: true);
                        },
                        onCancel: () {
                          flag = false.obs;
                        },
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          TextField(
                            autofocus: true,
                            controller: textEditingController,
                            onChanged: (value) {
                              barcode1 = value;
                            },
                            focusNode: _focusNode,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'barcode 1'.tr,
                                hintMaxLines: 1,
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 4.0))),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                        ]),
                      );
                    },
                    child: Flexible(
                      child: Container(
                        width: 65,
                        child: Text(
                          widget.productModel[widget.index].barcode1.value,
                          overflow: TextOverflow.clip,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget
                              .productModel[widget.index].barcode1.value.length
                              .isGreaterThan(0)
                          ? Colors.redAccent
                          : Colors.blueAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      TextEditingController textEditingController =
                          TextEditingController();
                      textEditingController.text = barcode2;
                      _focusNode.addListener(() {
                        if (_focusNode.hasFocus) {
                          textEditingController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: textEditingController.text.length);
                        }
                      });

                      Get.defaultDialog(
                        title: 'باركود2'.tr,
                        textConfirm: "confirm".tr,
                        textCancel: "cancel".tr,
                        buttonColor: AppColors.activeColor,
                        barrierDismissible: false,
                        radius: 30,
                        onConfirm: () {
                          widget.productModel[widget.index].barcode2.value =
                              barcode2;
                          Future updateBarcode() =>
                              FirebaseServices().updateBarcode(
                                  productModel:
                                      widget.productModel[widget.index]);
                          updateBarcode();
                          Get.back(closeOverlays: true);
                        },
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          TextField(
                            autofocus: true,
                            controller: textEditingController,
                            onChanged: (value) {
                              barcode2 = value;
                            },
                            focusNode: _focusNode,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'barcode 2'.tr,
                                hintMaxLines: 1,
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 4.0))),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                        ]),
                      );
                    },
                    child: Flexible(
                      child: Container(
                        width: 65,
                        child: Text(
                          widget.productModel[widget.index].barcode2.value,
                          overflow: TextOverflow.clip,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget
                              .productModel[widget.index].barcode2.value.length
                              .isGreaterThan(0)
                          ? Colors.redAccent
                          : Colors.blueAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      TextEditingController textEditingController =
                          TextEditingController();
                      textEditingController.text = barcode3;
                      _focusNode.addListener(() {
                        if (_focusNode.hasFocus) {
                          textEditingController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: textEditingController.text.length);
                        }
                      });

                      Get.defaultDialog(
                        title: 'باركود3'.tr,
                        textConfirm: "confirm".tr,
                        textCancel: "cancel".tr,
                        buttonColor: AppColors.activeColor,
                        barrierDismissible: false,
                        radius: 30,
                        onConfirm: () {
                          widget.productModel[widget.index].barcode3.value =
                              barcode3;
                          Future updateBarcode() =>
                              FirebaseServices().updateBarcode(
                                  productModel:
                                      widget.productModel[widget.index]);
                          updateBarcode();
                          Get.back(closeOverlays: true);
                        },
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          TextField(
                            autofocus: true,
                            controller: textEditingController,
                            onChanged: (value) {
                              barcode3 = value;
                            },
                            focusNode: _focusNode,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'barcode 3'.tr,
                                hintMaxLines: 1,
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 4.0))),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                        ]),
                      );
                    },
                    child: Flexible(
                      child: Container(
                        width: 65,
                        child: Text(
                          widget.productModel[widget.index].barcode3.value,
                          overflow: TextOverflow.clip,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget
                              .productModel[widget.index].barcode3.value.length
                              .isGreaterThan(0)
                          ? Colors.redAccent
                          : Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
