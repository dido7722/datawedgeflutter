import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/model/product_model.dart';
import '../../core/model/user_model.dart';
import '../../core/view_model/manuel_orders_view_model.dart';
import '../../services/firebase_services.dart';
import '../../services/pages_arguments.dart';
import '../controller/constants.dart';

class UserCard extends StatefulWidget {
  const UserCard({required this.index, required this.users, Key? key})
      : super(key: key);
  final int index;
  final List<UserModel> users;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  // CartViewModel ordersManuelViewModel=Get.find();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child:  GestureDetector(
        onDoubleTap: () async {
          RxList<ProductModel> productModel=<ProductModel>[].obs;
        // var sss=await  FirebaseServices().addOrder(productModel, 'Manuel', userName, uid);
        // if(sss[0]){
        //
        //   Get.snackbar("تم".tr, "تم فتح طلب جديد ".tr,
        //       snackPosition: SnackPosition.BOTTOM);
        // }else{
        //   Get.snackbar("خطا في الاتصال".tr, "لم يتم فتج الطلب".tr,
        //       snackPosition: SnackPosition.BOTTOM);
        // }

        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color(0xff73747e),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(2, 0), // changes position of shadow
                ),
              ],
            ),
            margin: const EdgeInsets.all(1.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          PrimaryText(
                            textDirection: TextDirection.ltr,
                            text: '${'K.nr'.tr} ${widget.users[widget.index].id}, ',
                            fontWeight: FontWeight.w900,
                            size: 12.0.sp,
                            maxLine: 2,
                          ),
                          PrimaryText(
                            text:'${widget.users[widget.index].nickName.capitalize} ',
                            size: 12.0.sp,
                            fontWeight: FontWeight.w900,
                            maxLine: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          PrimaryText(
                            textDirection: TextDirection.ltr,
                            text: 'FöretagNamn:  '.tr +
                                widget.users[widget.index].name.capitalize
                                    .toString(),
                            size: 12.0.sp,
                            fontWeight: FontWeight.w900,
                            maxLine: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          PrimaryText(
                            textDirection: TextDirection.ltr,
                            text: 'City:  '.tr +
                                widget.users[widget.index].city.capitalize
                                    .toString(),
                            size: 12.0.sp,
                            fontWeight: FontWeight.w600,
                            maxLine: 2,
                          ),
                          PrimaryText(
                            textDirection: TextDirection.ltr,
                            text:' ,  '+
                                widget.users[widget.index].orgNr.capitalize
                                    .toString(),
                            size: 12.0.sp,
                            fontWeight: FontWeight.w600,
                            maxLine: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

        ),
      ),
    );
  }
}
