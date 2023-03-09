import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import '../core/model/order_model.dart';
import '../core/view_model/orders_view_model.dart';
import '../widgets/controller/constants.dart';
import '../widgets/controller/custom_action_bar_orders.dart';
import '../widgets/orders_controller/order_card.dart';

class OrdersTabNew extends GetWidget<OrdersViewModel> {
  OrdersTabNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                // Container(),
                GetX(builder: (OrdersViewModel controller) {
                    controller.ordersList
                        .sort((a, b) => b.dateValue.compareTo(a.dateValue));
                    List<OrderModel> awaitingOrderList = controller
                        .ordersList
                        .where((p0) =>
                            p0.status.contains('pending') &&
                            p0
                                .toString()
                                .toLowerCase()
                                .contains(controller.find.value))
                        .toList();
                    List<OrderModel> processOrderList = controller
                        .ordersList
                        .where((p0) =>
                            p0.status.contains('processing') |
                                p0.status.contains('processed') |
                                p0.status.contains('shipped') |
                                p0.status.contains('wait.shipping') &&
                            p0
                                .toString()
                                .toLowerCase()
                                .contains(controller.find.value))
                        .toList();

                    return Column(children: <Widget>[
                            CustomActionBarOrders(
                              title: 'الطلبيات',
                              find: controller.find.value,
                            ),
                            Flexible(
                              child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: <Widget>[
                                    ButtonsTabBar(
                                      backgroundColor:
                                          AppColors.activeColor,
                                      unselectedBackgroundColor:
                                          Colors.grey[300],
                                      unselectedLabelStyle:
                                          const TextStyle(
                                              color: Colors.black),
                                      labelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      tabs: [
                                        Tab(
                                          icon: const Icon(Icons.pause),
                                          text:
                                              'في الانتظار(${awaitingOrderList.length})',
                                        ),
                                        Tab(
                                          icon: const Icon(Icons.sync),
                                          text:
                                              '${"قيد المعالجة".tr}(${processOrderList.length})',
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: <Widget>[
                                          ListView.builder(
                                            itemCount:
                                                awaitingOrderList.length,
                                            itemBuilder: (_, index) {
                                              return OrderCard(
                                                index: index,
                                                orders: awaitingOrderList
                                                    .toList(),
                                              );
                                            },
                                          ),
                                          ListView.builder(
                                            itemCount:
                                                processOrderList.length,
                                            itemBuilder: (_, index) {
                                              return OrderCard(
                                                index: index,
                                                orders: processOrderList
                                                    .toList(),
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
                          ]);
                  },
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