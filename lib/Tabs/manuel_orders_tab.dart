import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

import '../core/model/order_model.dart';
import '../core/view_model/manuel_orders_view_model.dart';
import '../core/view_model/products_view_model.dart';
import '../widgets/controller/constants.dart';
import '../widgets/controller/custom_action_bar_orders.dart';
import '../widgets/orders_controller/manuel_order_card.dart';

class ManuelOrdersTab extends GetWidget<ManuelOrdersViewModel> {
  const ManuelOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('طلبات يدوية'),
        actions: [

          PopupMenuButton(
            // add icon, by default "3 dot" icon
            icon: Icon(Icons.add),
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("إضافة طلبية جديدة"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  Navigator.pushNamed(context,'/SelectUserOrder',);
                }
              }
          ),

        ],


      ),
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
                child: GetX<ManuelOrdersViewModel>(
                  init: Get.put<ManuelOrdersViewModel>(ManuelOrdersViewModel()),
                  builder: (ManuelOrdersViewModel manuelOrdersViewModel) {
                    final ProductsViewModel _productsViewModel = Get.find();

                    manuelOrdersViewModel.ordersList
                        .sort((a, b) => b.dateValue.compareTo(a.dateValue));

                    List<OrderModel> processOrderList = manuelOrdersViewModel.ordersList
                        .where((p0) =>
                            p0.status.contains('processing') |
                            p0.status.contains('pending') |
                                p0.status.contains('processed') |
                                p0.status.contains('shipped') |
                                p0.status.contains('wait.shipping') &&
                            p0
                                .toString()
                                .toLowerCase()
                                .contains(manuelOrdersViewModel.find.value))
                        .toList();
                    return _productsViewModel.loading.value
                        ? const Center(child: CircularProgressIndicator())
                        : Stack(children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                 
                                  Flexible(

                                      child: Column(
                                        children: <Widget>[

                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                              processOrderList.length,
                                              itemBuilder: (_, index) {
                                                return ManuelOrderCard(
                                                  index: index,
                                                  orders: processOrderList
                                                      .toList(),
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
                            Obx(() => manuelOrdersViewModel.loading.value
                                ? Container(
                                    color: Colors.black.withOpacity(0.5),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Container())
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
