import 'package:datawedgeflutter/widgets/products_controller/products_listview2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/model/order_model.dart';
import '../core/view_model/products_view_model.dart';
import '../services/pages_arguments.dart';
import '../widgets/controller/circularProgress.dart';
import '../widgets/controller/custom_action_bar.dart';
import '../widgets/products_controller/products_listview.dart';

class SearchPage2 extends StatefulWidget {
  const SearchPage2({Key? key}) : super(key: key);

  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as OrderPageArguments;
    OrderModel orderModel = args.orderModel;

    return GetBuilder<ProductsViewModel>(
      builder: (controller) => controller.loading.value
          ? CircularCustom()
          : Scaffold(
              body: Column(
                children: [
                  CustomActionBar(
                    title: 'search'.tr,
                    hasBackArrowWidget: true,
                    hasTitleWidget: false,
                    focusSearchWidget: true,
                    hasCartQtyWidget: false,
                  ),
                  Expanded(
                    child: ListviewProducts2(
                      controller: controller.filterProductsList.toList(),
                      orderModel: orderModel,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
