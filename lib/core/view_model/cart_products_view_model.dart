

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/product_model.dart';
import 'products_view_model.dart';


class CartProductsViewModel extends GetxController {
  RxBool get loading => _loading;
  final RxBool _loading = false.obs;
  RxList<ProductModel> get productsList => _productsList;
  final RxList<ProductModel> _productsList = <ProductModel>[].obs;
  RxInt totalProduct=0.obs;
  RxInt countProduct=0.obs;

  RxInt countPalls=0.obs;

  RxInt realTotalProduct=0.obs;
  RxString find = ''.obs;


  getProducts({required String orderID}) async {

    _productsList.clear();
    _loading.value = true;
    List list;
    QuerySnapshot querySnapshot;
    querySnapshot = await FirebaseFirestore.instance
        .collection('manuelOrders').get();

    list=  querySnapshot.docChanges.where((element) => element.doc.id==orderID).first.doc.get('items');
    for (var element in list) {
      _productsList.add(ProductModel.fromSnapshotOrder2(element));
    }
    countProduct.value=_productsList.length;
    _productsList.bindStream(productsStream(orderID: orderID));
    _loading.value=false;
    find.value='';
    update();

  }

  Stream<RxList<ProductModel>> productsStream({required String orderID}) {
    List list;
    return  FirebaseFirestore.instance
        .collection('manuelOrders')
        .where('id',isEqualTo: orderID)
        .snapshots()
        .map((QuerySnapshot query) {
      RxList<ProductModel> retVal = <ProductModel>[].obs;
      for (var element in query.docs)  {
        list=element.get('items');
        for (var item in list) {
          retVal.add(ProductModel.fromSnapshotOrder2(item));
        }
      }
      realTotalProduct.value=_productsList.fold(0, (previousValue, element) => previousValue +  element.qty.value);
      countProduct.value=_productsList.length;
      update();
      _loading.value=false;
      return retVal;
    });
  }




}
