import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/view_model/products_view_model.dart';
import '../widgets/controller/circularProgress.dart';
import '../widgets/controller/custom_action_bar.dart';
import '../widgets/products_controller/products_listview.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
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
                    child: ListviewProducts(
                      controller: controller.filterProductsList.toList(),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
