import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

import '../core/model/order_model.dart';
import '../core/view_model/order_products_view_model.dart';
import '../services/pages_arguments.dart';
import '../widgets/controller/custom_action_bar.dart';
import '../widgets/pick_order_controller/product_card_pick_order_manuel.dart';

class PickOrderPageManuel extends GetWidget<OrderProductsViewModel> {
  const PickOrderPageManuel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as OrderPageArguments;
    OrderModel orderModel = args.orderModel;
    Future sss() => controller.getProducts(
        userID: args.orderModel.userID, orderID: args.orderModel.id);
    sss();

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
                    child:Obx(() => (controller.loading.value)
                        ? const Center(child: CircularProgressIndicator())
                        :  SafeArea(
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
                                          child: Text('الكمية المطلوبة: ${controller.totalProduct.value}'),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text('الكمية المعبئة: ${controller.realTotalProduct.value}'),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            'الفرق: ${controller.totalProduct.value -
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
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text('الأقلام المطلوبة : ${controller.countProduct.value}'),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text('الأقلام المعبئة: ${controller.countProductISReady.value}'),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            'الأقلام الغير معبئة: ${controller.countProductISNotReady.value}',
                                            style: const TextStyle(color: Colors.redAccent),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: controller.productsList.length,
                                              itemBuilder: (_, index) {
                                                return ProductCardPickOrderManuel(
                                                  index: index,
                                                  productModel: controller
                                                      .productsList
                                                      .toList(),
                                                  orderId: orderModel.id,
                                                  userId: orderModel.userID,
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
                            ],
                          ),
                        ),
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
}
