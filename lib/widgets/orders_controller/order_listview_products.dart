import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../core/model/product_model.dart';
import '../../core/view_model/order_products_view_model.dart';
import '../../services/pages_arguments.dart';
import '../controller/constants.dart';
import '../controller/custom_action_bar.dart';
import '../controller/process_timeline.dart';
import 'product_card_order.dart';

class OrderViewProducts extends GetWidget<OrderProductsViewModel> {
  const OrderViewProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as OrderPageArguments;

    int getStatus() {
      switch (args.orderModel.status) {
        case 'pending':
          return 0;
        case 'processing':
          return 1;
        case 'processed':
          return 2;
        case 'wait.shipping':
          return 3;
        case 'shipped':
          return 4;
        case 'complete':
          return 5;
        case 'denied':
          return 6;
        case 'cancelled':
          return 6;

        default:
          return 0;
      }
    }
    Future sss() =>
        controller.getProducts(userID: args.orderModel.userID, orderID: args.orderModel.id);
    sss();
    return Obx(() =>(controller.loading.value)
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Column(
              children: [
                CustomActionBar(
                  title: '${args.orderModel.userName} - Order: ${args.orderModel.sort.toString()}',
                  hasBackArrowWidget: true,
                  hasTitleWidget: true,
                  hasSearchWidget: false,
                ),
                ProcessTimelinePage(
                  processIndex: getStatus(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: !controller.productsList.length.isEqual(0)
                        ? ListView.separated(
                            padding: const EdgeInsets.only(top: 10),
                            itemCount: controller.productsList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return ProductCardOrder(
                                productModel: controller.productsList,
                                index: index,
                              );
                            },
                            separatorBuilder: (context, index) => Container(
                              height: 1,
                            ),
                          )
                        : Column(
                            children: [
                              Image.asset(
                                'assets/images/background/sad-bag.png',
                                width: 80.w,
                                height: 50.h,
                              ),
                              Center(
                                child: PrimaryText(
                                  text: 'no.item.found'.tr,
                                  size: 23.sp,
                                ),
                              ),
                              Center(
                                child: PrimaryText(
                                  text: 'updating.the.menu'.tr,
                                  size: 14.sp,
                                  textAlign: TextAlign.center,
                                  maxLine: 2,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ));
  }
}

class OrderListviewProducts extends StatefulWidget {
  const OrderListviewProducts({Key? key, required this.controller}) : super(key: key);

  final List<ProductModel> controller;
  @override
  State<OrderListviewProducts> createState() => _OrderListviewProductsState();
}

class _OrderListviewProductsState extends State<OrderListviewProducts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: !widget.controller.length.isEqual(0)
          ? ListView.separated(
              padding: const EdgeInsets.only(top: 10),
              itemCount: widget.controller.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ProductCardOrder(
                  productModel: widget.controller,
                  index: index,
                );
              },
              separatorBuilder: (context, index) => Container(
                height: 1,
              ),
            )
          : Column(
              children: [
                Image.asset(
                  'assets/images/background/sad-bag.png',
                  width: 80.w,
                  height: 50.h,
                ),
                Center(
                  child: PrimaryText(
                    text: 'no.item.found'.tr,
                    size: 23.sp,
                  ),
                ),
                Center(
                    child: PrimaryText(
                  text: 'updating.the.menu'.tr,
                  size: 14.sp,
                  textAlign: TextAlign.center,
                  maxLine: 2,
                )),
              ],
            ),
    );
  }
}
