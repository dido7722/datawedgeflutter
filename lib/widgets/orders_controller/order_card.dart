import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../core/model/order_model.dart';
import '../../core/view_model/order_products_view_model.dart';
import '../../services/firebase_services.dart';
import '../../services/pages_arguments.dart';
import '../controller/constants.dart';


class OrderCard extends StatefulWidget {
  const OrderCard({required this.index, required this.orders, Key? key})
      : super(key: key);
  final int index;
  final List<OrderModel> orders;

  @override
  State<OrderCard> createState() => _OrderCardState();
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


class _OrderCardState extends State<OrderCard> {
  final appSetting = GetStorage();
  OrderProductsViewModel orderProductsViewModel =Get.find();
  @override
  Widget build(BuildContext context) {

    RxString dropDownString = widget.orders[widget.index].status.obs;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color:Colors.white,
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
              offset: Offset(2, 0),
            ),
          ],
        ),
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.orders[widget.index].isReading)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PrimaryText(
                            text: !widget.orders[widget.index].isReading
                                ? 'New'
                                : '',
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
                          width: Get.width*0.7,
                          child: PrimaryText(
                            text: '${widget.orders[widget.index].userName} - ${widget.orders[widget.index].nickName}',
                            fontWeight: FontWeight.w600,
                            size: 12.0.sp,
                            maxLine: 2,
                          ),

                        ),
                      ),
                      PopupMenuButton<int>(
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value:1,
                            child: PrimaryText(
                              text: 'تعبئة يدوية'.tr,
                              size: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: PrimaryText(
                              text: 'تعبئة باركود'.tr,
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
                              Navigator.pushNamed(context,'/PickOrderPageManuel',arguments: OrderPageArguments(widget.orders[widget.index]));
                              break;
                              case 2:
                                Future sss() => orderProductsViewModel.getProducts(
                                    userID: widget.orders[widget.index].userID, orderID: widget.orders[widget.index].id);
                              await   sss();
                                Navigator.pushNamed(context,'/PickOrderPageBarcode',arguments: OrderPageArguments(widget.orders[widget.index]));
                              break;
                          }
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: PrimaryText(
                      text: '{${'order.date'.tr}} : ${DateFormat("dd-MM-yyyy / hh:mm").format(
                              DateTime.parse(widget
                                  .orders[widget.index].dateValue
                                  .toString()))}',
                      fontWeight: FontWeight.w600,
                      size: 10.0.sp,
                      maxLine: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: PrimaryText(
                      text: '${'رقم الطلبية'.tr}: ${widget.orders[widget.index].sort}',
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
                            text: 'حالة الطلبية:${widget.orders[widget.index].status
                                    .toString()
                                    .tr}',
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
                          text: '${'comments'.tr}: ${widget.orders[widget.index].comment}',
                          fontWeight: FontWeight.w600,
                          size: 10.0.sp,
                          color: AppColors.activeColor,
                          maxLine: 3,
                        ),
                      ),

                    ],
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
