
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/view_model/orders_view_model.dart';
import 'constants.dart';

// ignore: must_be_immutable
class CustomActionBarOrders extends StatefulWidget {
  const CustomActionBarOrders({
    Key? key,
    this.title,
    required this.find,
  }) : super(key: key);

  final String? title;
  final String find;

  @override
  State<CustomActionBarOrders> createState() => _CustomActionBarOrdersState();
}

class _CustomActionBarOrdersState extends State<CustomActionBarOrders> {

  final OrdersViewModel _ordersViewModel = Get.find();

  final myController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final newValue = widget.find;
    myController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: newValue.length),
      ),
    );

    return Container(
      decoration: const BoxDecoration(),
      // : null),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 5,
        left: 24.0,
        right: 24.0,
        bottom: 15.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Center(
                child: PrimaryText(
                  text: widget.title ?? "Action Bar",
                  size: 12.sp,
                  maxLine: 2,
                  fontWeight: FontWeight.w800,
                ),
              ),              IconButton(icon: const Icon(Icons.list),onPressed: (){

              },),

            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade200,
            ),
            child: TextField(
              controller: myController,
              onChanged: (value) {
                _ordersViewModel.find.value = value;
              },
              onTap: () {},
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffixIcon: CloseButton(
                    onPressed: () {
                      myController.clear();
                      _ordersViewModel.find.value = '';
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  hintText: "search".tr,
                  fillColor: Colors.grey,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 15.0,
                  )),
              style: TextStyle(
                  fontSize: 11.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
