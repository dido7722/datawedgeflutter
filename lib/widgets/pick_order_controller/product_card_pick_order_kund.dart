import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/product_model.dart';
import '../../core/view_model/products_view_model.dart';
import '../../services/firebase_services.dart';
import '../controller/constants.dart';

class ProductCardPickOrderKund extends StatefulWidget {
  const ProductCardPickOrderKund(
      {required this.productModel,
      required this.index,
      required this.userId,
      required this.orderId,
      required this.findCode,
      Key? key})
      : super(key: key);
  final List<ProductModel> productModel;
  final int index;
  final String orderId;
  final String userId;
  final RxString findCode;

  @override
  State<ProductCardPickOrderKund> createState() =>
      _ProductCardPickOrderKundState();
}

class _ProductCardPickOrderKundState extends State<ProductCardPickOrderKund> {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<ProductsViewModel>(
      builder: (controller) => controller.loading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: Get.height * 0.15,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff73747e),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ///Card Details
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
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        imageUrl:
                            '${widget.productModel[widget.index].image}?${widget.productModel[widget.index].dateImage}',
                        maxWidthDiskCache: 50,
                        maxHeightDiskCache: 50,
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image_not_supported,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: PrimaryText(
                          text: widget.productModel[widget.index].names[1],
                          fontWeight: FontWeight.w600,
                          size: 10.0.sp,
                          maxLine: 2,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: PrimaryText(
                          text: widget.productModel[widget.index].brand[1] +
                              '  -  ' +
                              widget.productModel[widget.index].size[1],
                          size: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff73747e),
                          maxLine: 1,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('المعبئة'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xff73747e),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xff73747e),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: Offset(
                                    2, 0),
                              ),
                            ],
                          ),
                          width: 30,
                          alignment: Alignment.center,
                          child: PrimaryText(
                            text: widget.productModel[widget.index].qty.value.toString(),
                            size: 15.sp,
                            fontWeight: FontWeight.w600,
                            maxLine: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
