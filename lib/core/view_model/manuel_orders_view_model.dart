import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/order_model.dart';
import '../model/product_model.dart';

class ManuelOrdersViewModel extends GetxController {
  final appSetting = GetStorage(); // instance of getStorage class
  RxBool loading = false.obs;
  final RxList<OrderModel> ordersList = <OrderModel>[].obs;

  final RxList<ProductModel> orderProductList = <ProductModel>[].obs;

  String orderID = '';
  RxString find = ''.obs;

  @override
  void onInit() {
    ordersList.bindStream(ordersStream()); //stream coming from firebase
    super.onInit();
  }
  Stream<RxList<OrderModel>> ordersStream() {
    loading.value=true;
    return FirebaseFirestore.instance
        .collection('manuelOrders')
        .orderBy('sort')
        .snapshots()
        .map((QuerySnapshot query) {
      RxList<OrderModel> retVal = <OrderModel>[].obs;
      for (var element in query.docs) {
        retVal.add(OrderModel.fromSnapshot(element));
      }
      update();
      loading.value=false;
      return retVal;
    });
  }
}
