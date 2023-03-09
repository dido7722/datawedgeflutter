import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/product_model.dart';
import '../../core/view_model/products_view_model.dart';
import '../controller/constants.dart';

class IncDecButton extends StatefulWidget {
   IncDecButton({required this.productModel, Key? key}) : super(key: key);
  final ProductModel productModel;

  @override
  // ignore: library_private_types_in_public_api
  _IncDecButtonState createState() => _IncDecButtonState();
}

class _IncDecButtonState extends State<IncDecButton> {
  ProductsViewModel productsViewModel = Get.find();
  final appSetting = GetStorage(); // instance of getStorage class
  @override
  Widget build(BuildContext context) {
    return
        Obx(()=>
           AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: AppColors.lighterGrayColor,
              border: Border.all(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(
                5.0,
              ),
            ),
            alignment: Alignment.center,

            height:10.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: FloatingActionButton(
                      onPressed: () {
                        addRemoveItem(widget.productModel.idAmeen, true);
                      },
                      backgroundColor: Colors.redAccent,
                      child:
                      const Center(child: Icon(Icons.add_outlined,size: 12,)),
                    ),
                  ),
                ),
                Visibility(
                  visible:widget.productModel.qty.value >= 1,
                  // visible:true,
                  child: Flexible(
                    child: Center(
                      child: PrimaryText(
                        // text: widget.productModel.cart.first.qty.value
                        //     .toString(),
                        text: widget.productModel.qty.value.toString(),
                        size: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.productModel.qty.value >= 1,
                  // visible: true,
                  child: Flexible(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: FloatingActionButton(
                        onPressed: () {
                          // widget.productModel.cart.first.qty.value -=1;
                          // updateCartItem(cartModel:widget.productModel.cart.first);
                          addRemoveItem(widget.productModel.idAmeen, true);

                        },
                        backgroundColor: Colors.redAccent,
                        child: const Icon(Icons.remove_outlined,size: 12,),
                      ),
                    ),
                  ),
                ),
              ],
            )


          ),
        );
  }

  void addRemoveItem(String idAmeen,bool _isAdd) {
    if (_isAdd) {
      if (productsViewModel.productsLocal
          .where((p0) => p0.idAmeen == idAmeen)
          .isNotEmpty) {
        var product = productsViewModel.productsLocal
            .where((p0) => p0.idAmeen == idAmeen)
            .first;
        if (product.qty.value == 0) {
          product.qty.value = 1;
          productsViewModel.productsLocal.add(product);
        } else {
          var product = productsViewModel.productsLocal
              .where((p0) => p0.idAmeen == idAmeen)
              .first;
          product.qty.value += 1;
          productsViewModel.productsLocal
              .removeWhere((p0) => p0.idAmeen == idAmeen);
          productsViewModel.productsLocal.add(product);
        }
        appSetting.write(productsViewModel.keyValue,
            ProductModel.encode(productsViewModel.productsLocal));
      } else {
        productsViewModel.productsLocal.add(productsViewModel.productsList
            .where((p0) => p0.idAmeen == idAmeen)
            .first);
        appSetting.write(productsViewModel.keyValue,
            ProductModel.encode(productsViewModel.productsLocal));
      }
    } else {
      if (productsViewModel.productsLocal
          .where((p0) => p0.idAmeen == idAmeen)
          .isNotEmpty) {
        var product = productsViewModel.productsLocal
            .where((p0) => p0.idAmeen == idAmeen)
            .first;
        if (product.qty.value == 1) {
          productsViewModel.productsLocal.remove(product);
        } else {
          productsViewModel.productsLocal
              .where((p0) => p0.idAmeen == idAmeen)
              .first
              .qty
              .value -= 1;
        }

        appSetting.write(productsViewModel.keyValue,
            ProductModel.encode(productsViewModel.productsLocal));
      } else {
        Get.snackbar("خطأ".tr, "الصنف غير معبا مسبقاً",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

}
