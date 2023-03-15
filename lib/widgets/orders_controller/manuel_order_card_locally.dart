import 'package:datawedgeflutter/core/view_model/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/order_model.dart';
import '../../core/model/product_model.dart';
import '../../services/firebase_services.dart';
import '../../services/pages_arguments.dart';
import '../controller/constants.dart';

class ManuelOrderCardLocally extends StatefulWidget {
  const ManuelOrderCardLocally({required this.index, required this.orders, Key? key})
      : super(key: key);
  final int index;
  final List<OrderModel> orders;

  @override
  State<ManuelOrderCardLocally> createState() => _ManuelOrderCardLocallyState();
}

var statusItems = [
  'pending'.tr,
  'processing'.tr,
  'processed'.tr,
  'wait.shipping'.tr,
  'shipped'.tr,
  'complete'.tr,
  'denied'.tr,
  'cancelled'.tr,
];

class _ManuelOrderCardLocallyState extends State<ManuelOrderCardLocally> {
  final appSetting = GetStorage(); // instance of getStorage class
  ProductsViewModel productsViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    RxString dropDownString = widget.orders[widget.index].status.obs;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ///Card Details
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.orders[widget.index].isReading)
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      PrimaryText(
                        text:
                            !widget.orders[widget.index].isReading ? 'New' : '',
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                        size: 10.0.sp,
                        maxLine: 2,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.circle,
                        color: Colors.green,
                      ),
                    ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: Get.width * 0.7,
                          child: PrimaryText(
                            text:
                                '${widget.orders[widget.index].userName} - ${widget.orders[widget.index].nickName}',
                            fontWeight: FontWeight.w600,
                            size: 12.0.sp,
                            maxLine: 2,
                          ),

                          ///Title
                        ),
                      ),
                      PopupMenuButton<int>(
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 1,
                            child: PrimaryText(
                              text: 'تعبئة'.tr,
                              size: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: PrimaryText(
                              text: 'تصفير الطلبية'.tr,
                              size: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: PrimaryText(
                              text: 'حذف الطلبية'.tr,
                              size: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: PrimaryText(
                              text: 'رفع للسسيرفر'.tr,
                              size: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PopupMenuItem(
                            value: 5,
                            child: PrimaryText(
                              text: 'ملاحظات'.tr,
                              size: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PopupMenuItem(
                            value: 6,
                            child: PrimaryText(
                              text: 'انهاء وطباعة'.tr,
                              size: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        icon: const Icon(Icons.settings),
                        initialValue: 1,
                        onSelected: (value) async {
                          switch (value) {
                            case 1:
                              Navigator.pushNamed(
                                  context, '/PickManuelOrderPageLocally',
                                  arguments: OrderPageArguments(
                                      widget.orders[widget.index]));

                              break;
                            case 2:
                              String keyValue =
                                  'key-${widget.orders[widget.index].sort}';
                              appSetting.remove(keyValue);
                              productsViewModel.productsLocal.clear();
                              break;
                            case 3:
                              FirebaseServices()
                                  .deleteOrder(widget.orders[widget.index].id);
                              break;

                            case 4:
                              productsViewModel.productsLocal.clear();
                              productsViewModel.keyValue =
                                  'key-${widget.orders[widget.index].sort}';

                              if (appSetting
                                  .hasData(productsViewModel.keyValue)) {
                                final String musicsString =
                                    appSetting.read(productsViewModel.keyValue);
                                productsViewModel.productsLocal
                                    .addAll(ProductModel.decode(musicsString));
                              } else {
                                final String encodedData =
                                    ProductModel.encode([]);
                                appSetting.write(
                                    productsViewModel.keyValue, encodedData);
                              }
                              if (productsViewModel.productsLocal.isNotEmpty) {
                                FirebaseServices().updateOrder(
                                    productsModel:
                                        productsViewModel.productsLocal,
                                    orderID: widget.orders[widget.index].id);
                              } else {
                                Get.snackbar("خطأ الطلب فارغ".tr,
                                    "لم يتم تحديث الطلب".tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.redAccent);
                              }
                              break;

                            case 5:
                              TextEditingController textEditingController =
                                  TextEditingController();
                              textEditingController.text =
                                  widget.orders[widget.index].comment;
                              Get.defaultDialog(
                                title: 'ملاحظات'.tr,
                                // backgroundColor: AppColors.lightGrayColor,
                                // titleStyle: const TextStyle(color: Colors.white),
                                // middleTextStyle: const TextStyle(color: Colors.white),
                                textConfirm: "confirm".tr,
                                textCancel: "cancel".tr,
                                // confirmTextColor: Colors.white,
                                buttonColor: AppColors.activeColor,
                                barrierDismissible: false,
                                radius: 30,
                                onConfirm: () {
                                  FirebaseServices().updateComment(
                                      comment:
                                          widget.orders[widget.index].comment,
                                      orderID: widget.orders[widget.index].id);
                                  Get.back();
                                },
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: textEditingController,
                                        onChanged: (value) {
                                          widget.orders[widget.index].comment =
                                              value;
                                        },
                                        keyboardType: TextInputType.multiline,
                                        minLines:
                                            1, //Normal textInputField will be displayed
                                        maxLines:
                                            5, // when user presses enter it will adapt to it
                                        decoration: InputDecoration(
                                            labelText: 'comments'.tr,
                                            hintMaxLines: 2,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.green,
                                                    width: 4.0))),
                                      ),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                    ]),
                              );
                              break;
                            case 6:
                              productsViewModel.productsLocal.clear();
                              productsViewModel.keyValue =
                                  'key-${widget.orders[widget.index].sort}';

                              if (appSetting
                                  .hasData(productsViewModel.keyValue)) {
                                final String musicsString =
                                    appSetting.read(productsViewModel.keyValue);
                                productsViewModel.productsLocal
                                    .addAll(ProductModel.decode(musicsString));
                              } else {
                                final String encodedData =
                                    ProductModel.encode([]);
                                appSetting.write(
                                    productsViewModel.keyValue, encodedData);
                              }
                              if (productsViewModel.productsLocal.isNotEmpty) {
                                await FirebaseServices().makeFinalOrder(
                                  productsList: productsViewModel.productsLocal,
                                  orderModel: widget.orders[widget.index],
                                );
                              } else {
                                Get.snackbar("خطأ الطلب فارغ".tr,
                                    "لم يتم انشاء الطلب".tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.redAccent);
                              }
                              break;
                          }
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: PrimaryText(
                      text:
                          '{${'order.date'.tr}} : ${DateFormat("dd-MM-yyyy / hh:mm").format(DateTime.parse(widget.orders[widget.index].dateValue.toString()))}',
                      fontWeight: FontWeight.w600,
                      size: 10.0.sp,
                      maxLine: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: PrimaryText(
                      text:
                          '${'رقم الطلبية'.tr}: ${widget.orders[widget.index].sort}',
                      fontWeight: FontWeight.w600,
                      size: 10.0.sp,
                      maxLine: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PrimaryText(
                            text:
                                'حالة الطلبية:${widget.orders[widget.index].status.toString().tr}',
                            fontWeight: FontWeight.w600,
                            size: 10.0.sp,
                            maxLine: 2,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.circle,
                            color: (widget.orders[widget.index].status
                                    .toString()
                                    .contains('complete'))
                                ? Colors.green
                                : (widget.orders[widget.index].status
                                        .toString()
                                        .contains('denied'))
                                    ? Colors.deepOrange
                                    : (widget.orders[widget.index].status
                                            .toString()
                                            .contains('cancelled'))
                                        ? Colors.deepOrange
                                        : AppColors.lightGrayColor,
                          ),
                        ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: PrimaryText(
                          text:
                              '${'comments'.tr}: ${widget.orders[widget.index].comment}',
                          fontWeight: FontWeight.w600,
                          size: 10.0.sp,
                          color: AppColors.activeColor,
                          maxLine: 3,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                        'الكمية المعبئة: ${widget.orders[widget.index].orderQty}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                        'عدد الأقلام: ${widget.orders[widget.index].orderCount}'),
                  ),
                  Row(
                    children: [
                      Obx(() => DropdownButton(
                            value: dropDownString.value.tr,
                            elevation: 16,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: statusItems.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: PrimaryText(
                                  text: items,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              dropDownString.value = newValue!;
                              FirebaseServices().updateOrderState(
                                  widget.orders[widget.index].id,
                                  newValue,
                                  widget.orders[widget.index].userID);
                              // categoyName = newValue;
                            },
                          )),
                    ],
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
