import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/product_model.dart';
import '../controller/constants.dart';

class ProductCardOrder extends StatefulWidget {
  const ProductCardOrder(
      {required this.productModel, required this.index, Key? key})
      : super(key: key);
  final List<ProductModel> productModel;
  final int index;

  @override
  State<ProductCardOrder> createState() => _ProductCardOrderState();
}

class _ProductCardOrderState extends State<ProductCardOrder> {
  final appSetting = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // PopupProductModal(_productsViewModel.productsList
        //     .where(
        //         (element) => element.id == widget.productModel[widget.index].id)
        //     .first);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xff73747e),
            width: 1.5,
          ),
          boxShadow: const [
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(bottom: 8, top: 0, left: 0, right: 0),
                      child: CachedNetworkImage(
                        width: 150,
                        height: 150,
                        // fit: BoxFit.cover,
                        imageUrl: widget.productModel[widget.index].image,

                        errorWidget: (context, url, error) => const Icon(
                          Icons.print,
                          size: 100,
                          color: Colors.red,
                        ),
                      ),
                    ), //Image
                  ],
                ),
              ),
            ),

            ///Card Details
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Title
                  PrimaryText(
                    text: widget.productModel[widget.index]
                        .names[1],
                    fontWeight: FontWeight.w600,
                    size: 12.0.sp,
                    maxLine: 2,
                  ),

                  ///brand
                  PrimaryText(
                    text: '${widget.productModel[widget.index]
                    .idAmeen} - ${widget.productModel[widget.index]
                    .brand[1]}' ,
                    size: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff73747e),
                    maxLine: 1,
                  ),

                  ///size & Source Image
                  Row(
                    children: [
                      PrimaryText(
                        text: widget.productModel[widget.index]
                        .size[1],
                        size: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff73747e),
                        maxLine: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PrimaryText(
              text: widget.productModel[widget.index].qty.toString(),
              size: 15.sp,
              fontWeight: FontWeight.w600,
              // color: Color(0xff73747e),
              maxLine: 1,
            ),
          ],
        ),
      ),
    );
  }
}
