import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

import '../core/api_pdf/pdf_api.dart';
import '../core/model/product_model.dart';
import '../core/view_model/ameen_import_view_model.dart';
import '../core/view_model/products_view_model.dart';
import '../services/firebase_services.dart';
import '../widgets/controller/constants.dart';
import '../widgets/controller/custom_action_bar_products.dart';
import '../widgets/products_controller/product_card.dart';

class ProductsTab extends GetWidget<ProductsViewModel> {

  @override
  Widget build(BuildContext context) {
    var flag=false.obs;
    return Obx(()=>
      Scaffold(
        body: Stack(
          children: [
            GetX<ProductsViewModel>(
                init: Get.put<ProductsViewModel>(ProductsViewModel()),
                builder: (ProductsViewModel productsViewModel) {
                  // AmeenImportViewModel importProducts = Get.find();

                  return productsViewModel.loading.value
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                        children: <Widget>[
                          CustomActionBarProducts(
                            // title: 'الاصناف'.tr,
                            find: productsViewModel.find.value,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 5.0),
                                //   child: ElevatedButton.icon(
                                //       onPressed: () async {
                                //         // if (importProducts.isStarted.value ==
                                //         //     false) {
                                //         //   Future sss() =>
                                //         //       importProducts.refreshProduct();
                                //         //   await sss();
                                //         // }
                                //         // await Navigator.pushNamed(
                                //         //     context, '/ImportProductsAmeen');
                                //         // if (importProducts.ameenProductModel
                                //         //         .where((p0) =>
                                //         //             p0.selected.value == true)
                                //         //         .length >
                                //         //     0) {
                                //         //   int lll=importProducts.ameenProductModel
                                //         //       .where((p0) =>
                                //         //   p0.selected.value == true)
                                //         //       .length;
                                //         //   await Get.defaultDialog(
                                //         //     title:
                                //         //         "هل انت متاكد من اضافة المنتجات المختارة",
                                //         //     backgroundColor:
                                //         //         AppColors.lightGrayColor,
                                //         //     middleText: 'ستتم إضافة $lll  منتجات جديدة',
                                //         //     titleStyle:
                                //         //         TextStyle(color: Colors.black),
                                //         //     middleTextStyle:
                                //         //         TextStyle(color: Colors.black),
                                //         //     textConfirm: "confirm".tr,
                                //         //     textCancel: "cancel".tr,
                                //         //     confirmTextColor: Colors.black,
                                //         //     cancelTextColor: Colors.black,
                                //         //     buttonColor: AppColors.whiteColor,
                                //         //     barrierDismissible: false,
                                //         //     radius: 30,
                                //         //     onConfirm: () async {
                                //         //
                                //         //       QuerySnapshot querySnapshot;
                                //         //       querySnapshot =
                                //         //           await FirebaseServices()
                                //         //               .productRef
                                //         //               .orderBy('id')
                                //         //               .get();
                                //         //       List<int> list = [];
                                //         //       int id;
                                //         //
                                //         //       if (querySnapshot.docs.isNotEmpty) {
                                //         //         querySnapshot.docs
                                //         //             .forEach((element) {
                                //         //           list.add(int.parse(element.id
                                //         //               .toString()
                                //         //               .substring(3)));
                                //         //         });
                                //         //         id = list.reduce(max);
                                //         //         var db =
                                //         //             FirebaseFirestore.instance;
                                //         //         var batch = db.batch();
                                //         //
                                //         //         importProducts.ameenProductModel
                                //         //             .where((p0) =>
                                //         //                 p0.selected.value == true)
                                //         //             .forEach((element) {
                                //         //               element.selected.value=false;
                                //         //           id += 1;
                                //         //           List listNames = [
                                //         //             (element.latinName.length ==
                                //         //                     0)
                                //         //                 ? element.name
                                //         //                 : element.latinName,
                                //         //             element.name
                                //         //           ];
                                //         //           List listDescs = ['', ''];
                                //         //           List listSize = [
                                //         //             'Weight',
                                //         //             'Weight'
                                //         //           ];
                                //         //           List listBrand = [
                                //         //             'Marke',
                                //         //             'Marke'
                                //         //           ];
                                //         //           List listPrices = [0, 0, 0];
                                //         //           ProductModel newProductModel =
                                //         //               new ProductModel(
                                //         //             id: 'Pro$id',
                                //         //             names: listNames,
                                //         //             descs: listDescs,
                                //         //             size: listSize,
                                //         //             brand: listBrand,
                                //         //             source:
                                //         //                 'https://firebasestorage.googleapis.com/v0/b/x-mat-7455b.appspot.com/o/flags%2Fsvenskt.png?alt=media&token=5ee14344-1171-4443-8245-584d6420ac61',
                                //         //             categoryID:
                                //         //                 element.categoryID,
                                //         //             image:
                                //         //                 '',
                                //         //             specialPrice: 0.0.obs,
                                //         //             sort: 0.obs,
                                //         //             enabled: false,
                                //         //             isSpecial: false,
                                //         //             isGood: false,
                                //         //             isNew: true,
                                //         //             prices: listPrices.obs,
                                //         //             idAmeen: element.code,
                                //         //             dateImage:
                                //         //                 DateTime.now().toString(),
                                //         //             qty: 0.obs,
                                //         //             vat: element.vat,
                                //         //           );
                                //         //           batch.set(
                                //         //               db
                                //         //                   .collection('proct')
                                //         //                   .doc('Pro$id'),
                                //         //               newProductModel.toJson());
                                //         //         });
                                //         //         batch.commit().whenComplete(() {
                                //         //           Get.snackbar(
                                //         //               "تم", 'تمت الاضافة بنجاح',
                                //         //               snackPosition: SnackPosition
                                //         //                   .BOTTOM);
                                //         //           Get.back(closeOverlays: true);                                              }
                                //         //         ).onError((error, stackTrace) =>
                                //         //             Get.snackbar('Error',error.toString() ,
                                //         //                 snackPosition: SnackPosition.BOTTOM)
                                //         //
                                //         //         );
                                //         //       }
                                //         //     },
                                //         //   );
                                //         // }
                                //       },
                                //       icon: Icon(
                                //         Icons.import_export,
                                //         color: AppColors.activeColor,
                                //       ),
                                //       label: Text('Ameen')),
                                //
                                // ),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                      context,
                                      '/BarcodeProducts');
                                  try{
                                    flag.value=true;
                                    await     makePdf().makePdfWithInvoice(productsViewModel.productsList.where((p0) => p0.isPrint.value ).toList());

                                  }catch (err){
                                    print(err);
                                    flag.value=false;
                                  }finally{
                                    flag.value=false;
                                  }


                                  },
                                  icon: Icon(
                                    Icons.print,
                                    color: AppColors.activeColor,
                                  ),
                                  label: Text('Barcode' +'-'+ productsViewModel.productsList.where((p0) => p0.isPrint.value ).length.toString())),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    productsViewModel.productsList.where((p0) => !p0.isPrint.value && p0
                                        .toString()
                                        .toLowerCase()
                                        .contains(
                                        productsViewModel
                                            .find
                                            .value)).forEach((element) {
                                      element.isPrint.value=true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.done_all,
                                    color: AppColors.activeColor,
                                  ),
                                  label: Container()),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    productsViewModel.productsList.where((p0) => p0.isPrint.value  && p0
                                        .toString()
                                        .toLowerCase()
                                        .contains(
                                        productsViewModel
                                            .find
                                            .value)).forEach((element) {
                                      element.isPrint.value=false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.deselect,
                                    color: AppColors.activeColor,
                                  ),
                                  label: Container()),
                            ],
                          ),
                          Flexible(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: RefreshIndicator(
                                      child: ListView.builder(
                                        itemCount: productsViewModel
                                                    .find.value.length >
                                                0
                                            ? productsViewModel.productsList
                                                .where((p0) =>
                                                    p0
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(
                                                            productsViewModel
                                                                .find
                                                                .value) &&
                                                    p0.enabled)
                                                .length
                                            : productsViewModel.productsList
                                                .where((p0) => p0.enabled)
                                                .length,
                                        itemBuilder: (_, index) {
                                          return Container(
                                            // width: 600,
                                            // height: 700,
                                            child: ProductCard(
                                              index: index,
                                              productModel: productsViewModel
                                                          .find.value.length >
                                                      0
                                                  ? productsViewModel
                                                      .productsList
                                                      .where((p0) =>
                                                          p0
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(
                                                                  productsViewModel
                                                                      .find
                                                                      .value) &&
                                                          p0.enabled)
                                                      .toList()
                                                  : productsViewModel
                                                      .productsList
                                                      .where(
                                                          (p0) => p0.enabled)
                                                      .toList(),
                                            ),
                                          );
                                        },
                                      ),
                                        onRefresh: () {
                                          return Future.delayed(Duration(seconds: 1), () {
                                            // PaintingBinding.instance.imageCache.clear();
                                            productsViewModel.find.value = '';
                                            productsViewModel.getProducts();
                                            productsViewModel.update();
                                          });
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Expanded(child: OrdersListview()),
                        ],
                      );
                }),
           if (flag.value)
            Container(
                color: Colors.grey.shade50,
                child:Center(child: CircularProgressIndicator())),
          ],
        ),

      ),
    );
  }
}
