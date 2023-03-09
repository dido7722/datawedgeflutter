

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'product_model.dart';

class OrderModel {
  String id = '';
  String userID = '';
  String dateValue = '';
  String userName = '';
  String nickName = '';
  bool isReading=false;
  int sort = 0;
  String status='pending';
  String comment='';
  List<ProductModel> productModel = <ProductModel>[].obs;
  String orderNumberFortnox='';
  String customerNumberFortnox='';
  RxInt countPall=0.obs;
  RxInt orderQty=0.obs;
  RxInt orderCount=0.obs;
  // Timestamp orderUpdateDate=Timestamp.now();


  OrderModel(
      {required this.id,
      required this.userID,
      required this.dateValue,
      required this.userName,
      required this.sort,
      required this.productModel,
      required this.status,
      required this.comment,
      required this.isReading,
      required this.orderCount,
      required this.orderQty,
        required this.nickName
        // required this.orderUpdateDate,
      });

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {

    id = snapshot.get('id') ?? '';
    userID = snapshot.get('userID') ?? '';
    dateValue = snapshot.get('dueDate');
    userName = snapshot.get('userName');
    try{
      nickName = snapshot.get('nickName');
    }on Error{
      nickName='';
    }
    sort = snapshot.get('sort') ?? 0;
    status = snapshot.get('status') ?? 'pending';
    comment = snapshot.get('comment') ?? '';
    try{
      orderCount.value = snapshot.get('orderCount') ;
    }on Error{
      orderCount.value=0;
    }
    try{
      orderQty.value = snapshot.get('orderQty') ;
    }on Error{
      orderQty.value=0;
    }
    try{
      isReading = snapshot.get('isReading') ?? false;
    }on Error{
      isReading=false;
    }
    try{

    }on Error{
      isReading=false;
    }
if(snapshot.data().toString().contains('countPall')){
  countPall.value=snapshot.get('countPall') ?? 0;
}
 }



  @override
  String toString() {
    return '$id,$userID,$userName,$sort,$comment';
  }

  List cartItemsToJson() => productModel.map((item) => item.toJson()).toList();

  toJson() {
    return {
      'id': id,
      'userID': userID,
      'dueDate': dateValue,
      'userName': userName,
      'sort': sort,
      'status': status,
      'comment': comment,
      'isReading':isReading,
      'items': cartItemsToJson(),
      'orderCount':orderCount.value,
      'orderQty':orderQty.value,
      'nickName':nickName,
      // 'orderUpdateDate':orderUpdateDate,
    };
  }
}
