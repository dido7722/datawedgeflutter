import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/view_model/products_view_model.dart';
import '../../core/view_model/users_view_model.dart';
import '../../services/firebase_services.dart';
import 'constants.dart';

// ignore: must_be_immutable
class CustomActionBar extends GetWidget {
  CustomActionBar(
      {Key? key, this.title,
      this.hasBackArrowWidget,
      this.hasTitleWidget,
      this.hasBackground,
      this.hasSearchWidget,
      this.hasCartQtyWidget,
      this.focusSearchWidget,
      this.backgroundColorWidget}) : super(key: key);

  final String? title;
  final bool? hasBackArrowWidget;
  final bool? hasTitleWidget;
  final bool? hasBackground;
  final bool? hasSearchWidget;
  final bool? hasCartQtyWidget;
  final bool? focusSearchWidget;
  final Color? backgroundColorWidget;

  FirebaseServices firebaseServices = FirebaseServices();

  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  final myController = TextEditingController();
  ProductsViewModel _productsViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    bool hasBackArrow = hasBackArrowWidget ?? false;
    bool hasTitle = hasTitleWidget ?? false;
    bool hasSearch = hasSearchWidget ?? true;
    bool hasCartQty = hasCartQtyWidget ?? true;
    bool focusSearch = focusSearchWidget ?? false;
    Color? backgroundColor=backgroundColorWidget;
    return Container(
      decoration: BoxDecoration(

        color: backgroundColor,
                ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 5.sp,
        left: 24.0,
        right: 24.0,
        bottom: 15.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (hasBackArrow)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    width: 30.0,
                    height: 030.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.arrow_back_ios,
                    size: 15,
                    color: Colors.white,)
                  ),
                ),
              if (hasTitle)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: PrimaryText(
                      text: title ?? "Action Bar",
                      size: 12.sp,
                      maxLine: 2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

            ],
          ),
          if (hasSearch)
            Container(
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
              ),
              height: 5.h,
              child: TextField(
                onChanged: (value) {
                  _productsViewModel.strSearch = value.toLowerCase();
                  _productsViewModel.filterProducts();
                },
                // autofocus: _focusSearch,
                onTap: () {
                  if (!focusSearch) {
                    Navigator.pushNamed(context, '/SearchPage');
                    FocusScope.of(context).nextFocus();

                  }
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    suffixIcon: CloseButton(
                      onPressed: () {
                        if (focusSearch) {
                          Navigator.pop(context);
                          FocusScope.of(context).unfocus();

                        }
                      },
                    ),
                    hintText: "search".tr,
                    fillColor: Colors.grey,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.0.h,
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
