import 'package:cached_network_image/cached_network_image.dart';
import 'package:datawedgeflutter/pages/pickup_cart_page_locally.dart';
import 'package:datawedgeflutter/widgets/products_controller/new_inc_dec_but.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/product_model.dart';
import '../../core/view_model/products_view_model.dart';
import '../controller/constants.dart';

class ListviewProducts extends StatefulWidget {
  ListviewProducts({Key? key, required this.controller}) : super(key: key);

  final List<ProductModel> controller;
  @override
  State<ListviewProducts> createState() => _ListviewProductsState();
}

class _ListviewProductsState extends State<ListviewProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: !widget.controller.length.isEqual(0)
            ? ListView.separated(
                itemCount: widget.controller.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return ItemCard(
                    productModel: widget.controller,
                    index: index,
                  );
                },
                separatorBuilder: (context, index) => Container(
                  height: 1,
                ),
              )
            : SingleChildScrollView(
                child: Column(
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
              ),
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  ItemCard({required this.productModel, required this.index, Key? key})
      : super(key: key);
  final List<ProductModel> productModel;
  final int index;
  final appSetting = GetStorage(); // instance of getStorage class

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  ProductsViewModel productsViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    var dateImg = DateTime.parse(widget.productModel[widget.index].dateImage);
    RxBool flag = true.obs;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xff73747e),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff73747e),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(2, 0), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          ///Image
          GestureDetector(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Container(
                        child: PhotoView(
                            imageProvider: CachedNetworkImageProvider(
                                widget.productModel[widget.index].image
                            )
                        )
                    ),
                  )
              );

            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.30,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
                    child: Container(
                      width: 75,
                      height: 75,
                      child: CachedNetworkImage(
                        width: 75,
                        height: 75,
                        // fit: BoxFit.cover,
                        imageUrl: widget.productModel[widget.index].image +
                            '?' +
                            dateImg.toString(),

                        errorWidget: (context, url, error) => Icon(
                          Icons.image_not_supported,
                          // size: 100,
                          // color: Colors.red,
                        ),
                      ),
                    ),
                  ), //Image
                ],
              ),
            ),
          ),

          ///Card Details
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Title
                Container(
                  child: PrimaryText(
                    text: widget.productModel[widget.index].names[1],
                    fontWeight: FontWeight.w600,
                    size: 10.sp,
                    maxLine: 2,
                  ),

                  ///Title
                ),

                ///brand
                Container(
                    child: PrimaryText(
                  text: widget.productModel[widget.index].brand[1],
                  size: 8.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff73747e),
                  maxLine: 1,
                )

                    ///brand
                    ),

                ///size & Source Image
                Row(
                  children: [
                    Container(
                        child: PrimaryText(
                      text: widget.productModel[widget.index].size[1],
                      size: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff73747e),
                      maxLine: 1,
                    ) //size
                        ), //size
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Image.network(
                        widget.productModel[widget.index].source,
                        width: 18,
                        height: 18,
                        fit: BoxFit.fill,
                      ), //Source
                    ), //Source
                  ],
                ),
              ],
            ),
          ),

          ///PLUS MINUS QTY
          Expanded(
            child: Center(
              child: ElevatedButton(
                        onPressed: () {
                          addRemoveItem(
                              widget.productModel[widget.index].idAmeen);
                          _showToast(context);
                        }, child:Center(child:  Icon( Icons.add,),)
                        // icon: Icon( Icons.add,size: 15,),
                        //  label: Container(),
                      )





            ),
          )
        ],
      ),
    );
  }
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('${widget.productModel[widget.index].names[1]}  ${widget.productModel[widget.index].size[0]}'),
        duration:const Duration(milliseconds: 750),
        action: SnackBarAction(label: '${productsViewModel.productsLocal
            .where((p0) => p0.idAmeen == widget.productModel[widget.index].idAmeen)
            .first.qty.value}', onPressed: scaffold.hideCurrentSnackBar,textColor: Colors.white,),
      ),
    );
  }

  void addRemoveItem(String idAmeen) {
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
      widget.appSetting.write(productsViewModel.keyValue,
          ProductModel.encode(productsViewModel.productsLocal));
    } else {
      productsViewModel.productsLocal.add(productsViewModel.productsList
          .where((p0) => p0.idAmeen == idAmeen)
          .first);
      widget.appSetting.write(productsViewModel.keyValue,
          ProductModel.encode(productsViewModel.productsLocal));
    }
    productsViewModel.update();
  }
}
