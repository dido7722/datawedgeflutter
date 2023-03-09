

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/product_model.dart';
import 'products_view_model.dart';


class OrderProductsViewModel extends GetxController {
  RxBool get loading => _loading;
  final RxBool _loading = false.obs;
  RxList<ProductModel> get productsList => _productsList;
  final RxList<ProductModel> _productsList = <ProductModel>[].obs;
  RxInt totalProduct=0.obs;
  RxInt countProduct=0.obs;
  RxInt countProductISReady=0.obs;
  RxInt countProductISNotReady=0.obs;

  RxInt countPalls=0.obs;

  RxInt realTotalProduct=0.obs;
  RxString find = ''.obs;
  final ProductsViewModel _productsViewModel=Get.find();


  getProducts({required String userID,required String orderID}) async {
    totalProduct.value=0;

    _productsList.clear();
    _loading.value = true;
    List list;
    List listQty;
    QuerySnapshot querySnapshot;
    querySnapshot = await FirebaseFirestore.instance
        .collection('orders').get();

    list=  querySnapshot.docChanges.where((element) => element.doc.id==orderID).first.doc.get('items');
    for (var element in list) {
      _productsList.add(ProductModel.fromSnapshotOrder(element));
      _productsList.last.idAmeen=_productsViewModel.productsList.where((p0) => p0.id==element['id']).first.idAmeen;
    }

    if(querySnapshot.docs.where((element) => element.id==orderID).first.data().toString().contains('items_qty')){
      listQty=querySnapshot.docs.where((element) => element.id==orderID).first.get("items_qty");
      for (var element in listQty) {
        ProductModel item=_productsList.where((p0) => p0.id==element['id']).first;
        item.realQty.value=element['realQty'];
            item.finishPicked.value=element['finishPicked'];
            item.commentQty.value=element['commentQty'];
            item.pallNr.value=element['pallNr'];
      }
    }
    countProduct.value=_productsList.length;
    countProductISReady.value=_productsList.where((p0) => p0.finishPicked.isTrue).length;
    countProductISNotReady.value=_productsList.length - _productsList.where((p0) => p0.finishPicked.isTrue).length;
    totalProduct.value=_productsList.fold(0, (previousValue, element) => previousValue +  element.qty.value);
    countPalls.value = _productsList.reduce(
            (current, next) => current.pallNr.value > next.pallNr.value ? current : next).pallNr.value;
    realTotalProduct.value=_productsList.fold(0, (previousValue, element) => previousValue +  element.realQty.value);

    _productsList.bindStream(productsStream(userID: userID,orderID: orderID)); //stream coming from firebase
    _loading.value=false;
    find.value='';
    update();

  }

 Stream<RxList<ProductModel>> productsStream({required String userID,required String orderID}) {
    List list;
    List listQty;
    return  FirebaseFirestore.instance
        .collection('orders')
    .where('id',isEqualTo: orderID)
        .snapshots()
        .map((QuerySnapshot query) {
      RxList<ProductModel> retVal = <ProductModel>[].obs;
      query.docs.forEach((element) async {
        list=element.get('items');
        for (var item in list) {
          retVal.add(ProductModel.fromSnapshotOrder(item));
        }
        if(element.data().toString().contains('items_qty')){
            listQty = element.get("items_qty");
            for (var itemQty in listQty) {
              var editedItem=retVal.where((p0) => p0.id==itemQty['id']).first;
              editedItem.realQty.value=itemQty['realQty'];
              editedItem.finishPicked.value=itemQty['finishPicked'];
              editedItem.commentQty.value=itemQty['commentQty'];
              editedItem.pallNr.value=itemQty['pallNr'];
            }
            }
      });
      totalProduct.value=retVal.fold(0, (previousValue, element) => previousValue +  element.qty.value);
      realTotalProduct.value=retVal.fold(0, (previousValue, element) => previousValue +  element.realQty.value);
      countPalls.value = retVal.reduce(
              (current, next) => current.pallNr.value > next.pallNr.value ? current : next).pallNr.value;

      _loading.value=false;

      return retVal;
    });
  }




}
