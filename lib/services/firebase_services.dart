import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../core/model/order_model.dart';
import '../core/model/product_model.dart';
import '../core/view_model/auth_view_model.dart';
import '../core/view_model/products_view_model.dart';

class FirebaseServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserID() {
    return _firebaseAuth.currentUser!.uid;
  }

  String? getUserName() {
    return _firebaseAuth.currentUser!.displayName.toString();
  }

  String? getEmail() {
    return _firebaseAuth.currentUser!.email.toString();
  }

  String? getOrgNr() {
    return _firebaseAuth.currentUser!.displayName.toString();
  }

  late CollectionReference productRef;
  late FirebaseAuth firebaseAuth;
  // final AuthViewModel _authViewModel = Get.find();
  late CollectionReference manuelOrderRef;
  late CollectionReference orderRef;
  late CollectionReference userRef;
  late CollectionReference categoryRef;

  FirebaseServices() {
    userRef = FirebaseFirestore.instance.collection("users");
    manuelOrderRef = FirebaseFirestore.instance.collection('manuelOrders');
    orderRef = FirebaseFirestore.instance.collection('orders');
    productRef = FirebaseFirestore.instance.collection('proct');
    categoryRef = FirebaseFirestore.instance.collection('categories');
  }

  Future<void> updateProduct(ProductModel productModel) async {
    return await productRef.doc(productModel.id).update({
      'idAmeen': productModel.idAmeen,
      'name': productModel.names,
      'desc': productModel.descs,
      'brand': productModel.brand,
      'size': productModel.size,
      'source': productModel.source,
      'categoryID': productModel.categoryID.value,
      'image': productModel.image,
      'specialPrice': productModel.specialPrice.value,
      "enabled": productModel.enabled,
      "isSpecial": productModel.isSpecial,
      "isGood": productModel.isGood,
      "isNew": productModel.isNew,
      "sort": productModel.sort.value,
      'prices': productModel.prices,
    }).then((_) {
      Get.snackbar("تم التعديل".tr, "تم التعديل بنجاح",
          snackPosition: SnackPosition.BOTTOM);
    }).catchError((error) {
      Get.snackbar("error".tr, error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  Future<void> updateOrderState(
      String orderID, String orderState, String userId) async {
    String orderSt = orderState;
    switch (orderSt) {
      case 'في انتظار المراجعة':
        orderSt = 'pending';
        break;
      case 'جاري المعالجة':
        orderSt = 'processing';
        break;
      case 'تمت معالجتها':
        orderSt = 'processed';
        break;
      case 'في انتظار الشحن':
        orderSt = 'wait.shipping';
        break;
      case 'تم الشحن':
        orderSt = 'shipped';
        break;
      case 'مكتملة':
        orderSt = 'complete';
        break;
      case 'مرفوضة':
        orderSt = 'denied';
        break;
      case 'ملغاة':
        orderSt = 'cancelled';
        break;
      default:
        orderSt = 'pending';
        break;
    }

    return await FirebaseFirestore.instance
        .collection('manuelOrders')
        .doc(orderID)
        .update({'status': orderSt}).whenComplete(() => Get.snackbar(
            "order.is.updated".tr, "order.update.is.done".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white));
  }
  // Future<void> updateOrder(OrderModel orderModel) async {
  //   return FirebaseFirestore.instance
  //       .collection('users/${orderModel.userID}/Orders')
  //       .doc(orderModel.id)
  //       .update({
  //         'isReading': orderModel.isReading,
  //       })
  //       .then((_) {})
  //       .catchError((error) {
  //         Get.snackbar("error".tr, error.toString(),
  //             snackPosition: SnackPosition.BOTTOM);
  //       });
  // }

  Future<void> updatePickedOrder(
      {required String orderId,
      required String userID,
      required String commentQty,
      required int realQty,
      required String productId,
      required bool finishPicked,
      required int pallNr}) async {
    var ref = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId);
    ref.get().then((value) {
      var addQTy = [];
      var removeItem = [];
      if (value.data()!.containsKey('items_qty')) {
        List oldList = value.data()!['items_qty'];
        if (oldList.where((element) => element['id'] == productId).isNotEmpty) {
          removeItem.add(
              oldList.where((element) => element['id'] == productId).first);
          ref.set({'items_qty': FieldValue.arrayRemove(removeItem)},
              SetOptions(merge: true));
        }
      }
      addQTy.add({
        'id': productId,
        'realQty': realQty,
        'commentQty': commentQty,
        'finishPicked': finishPicked,
        'pallNr': pallNr
      });
      ref.set({'items_qty': FieldValue.arrayUnion(addQTy)},
          SetOptions(merge: true));
    });
  }

  Future<List> addOrder(List<ProductModel> productModel, String comment,
      String userName, String uid,String nickName) async {
    List list = [];
    try {
      String id = const Uuid().v1();
      int sort = 1;
      DateTime now = DateTime.now();
      await FirebaseFirestore.instance
          .collection('settings')
          .doc('maxOrdersNumberManuel')
          .get()
          .then((value) => sort = value.data()!['maxOrdersNumberManuel'] + 1);
      OrderModel ss = OrderModel(
          id: id,
          userID: uid,
          dateValue: now.toString(),
          userName: userName,
          sort: sort,
          status: 'pending',
          productModel: productModel,
          comment: comment,
          isReading: true,
          orderCount: 0.obs,
          orderQty: 0.obs,
      nickName: nickName
      // orderUpdateDate: Timestamp.now()
      );
      await manuelOrderRef.doc(id).set(ss.toJson()).whenComplete(() async {
        list = [true, id];
      }).catchError((onError) {
        list = [false];
        if (kDebugMode) {
          print(onError);
        }
      });
      await FirebaseFirestore.instance
          .collection('settings')
          .doc('maxOrdersNumberManuel')
          .set({'maxOrdersNumberManuel': sort}, SetOptions(merge: true));
    } catch (error) {
      list = [false];
    } finally {
      return list;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await manuelOrderRef.doc(orderId).delete().then((value) => Get.snackbar(
          "تم".tr, "تم حذف الطلبية بنجاح",
          snackPosition: SnackPosition.BOTTOM));
    } catch (error) {
    } finally {}
  }

  Future<void> addOrderProduct(
      String orderId, ProductModel productModel) async {
    var ref = await FirebaseFirestore.instance
        .collection('manuelOrders')
        .doc(orderId);
    ref.get().then((value) async {
      List items = value.data()!['items'];
      if (items.isNotEmpty) {
        bool flag = false;
        for (Map item in items) {
          var removeItem = [];
          removeItem.add(productModel.toJson());

          if (item['idAmeen'] == productModel.idAmeen) {
            flag = true;
            await ref.set({'items': FieldValue.arrayRemove(removeItem)},
                SetOptions(merge: true));
            removeItem.first['qty'] += 1;
            await ref.set({'items': FieldValue.arrayUnion(removeItem)},
                SetOptions(merge: true));
          }
        }
        if (!flag) {
          List product = [];
          product.add(productModel.toJson());
          ref.set({'items': FieldValue.arrayUnion(product)},
              SetOptions(merge: true));
        }
      } else {
        List product = [];
        product.add(productModel.toJson());
        ref.set(
            {'items': FieldValue.arrayUnion(product)}, SetOptions(merge: true));
      }
    });
  }

  Future<void> updateOrder(
      {required String orderID,
      required RxList<ProductModel> productsModel}) async {
    List cartItemsToJson() =>
        productsModel.map((item) => item.toJson()).toList();
    int orderQty = productsModel
        .fold(0,
            (int previousValue, element) => previousValue + element.qty.value)
        ;
    int orderCount = productsModel.length;

    return await FirebaseFirestore.instance
        .collection('manuelOrders')
        .doc(orderID)
        .update({'items': cartItemsToJson(),'orderQty':orderQty,'orderCount':orderCount}).whenComplete(() => Get.snackbar(
            "order.is.updated".tr, "order.update.is.done".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white));
  }

  Future<void> updateComment(
      {required String orderID,
      required String comment}) async {

    return await FirebaseFirestore.instance
        .collection('manuelOrders')
        .doc(orderID)
        .update({'comment': comment}).whenComplete(() => Get.snackbar(
            "order.is.updated".tr, "order.update.is.done".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white));
  }

  Future<void> makeFinalOrder({required List<ProductModel> productsList,required OrderModel orderModel}) async {
    // ProductsViewModel productsViewModel= Get.find();
    int orderQty = productsList
        .fold(0,
            (int previousValue, element) => previousValue + element.qty.value)
    ;
    int orderCount = productsList.length;

    String id = const Uuid().v1();
    int sort = 1;
    DateTime now = DateTime.now();

    await FirebaseFirestore.instance.
    collection('settings').doc('maxOrdersNumber').get().then((value) =>
    sort=value.data()!['maxOrdersNumber']+1);

    OrderModel ss = OrderModel(
        id: id,
        userID: orderModel.userID,
        dateValue: now.toString(),
        userName: orderModel.userName,
        sort: sort,
        status: 'complete',
        productModel: productsList,
        comment: orderModel.comment,
        isReading:false, orderCount: orderCount.obs, orderQty: orderQty.obs,
        nickName:orderModel.nickName
    );

    return await orderRef.doc(id).set(ss.toJson()).whenComplete(() async {
      await deleteOrder(orderModel.id);

      Get.snackbar("order.is.received".tr, "order.is.received".tr,
          snackPosition: SnackPosition.BOTTOM);
      await FirebaseFirestore.instance.
      collection('settings').doc('maxOrdersNumber').set({'maxOrdersNumber':sort},SetOptions(merge: true));

    }).catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });
  }

  Future<void> updateBarcode({required ProductModel productModel})async{
    return await productRef
        .doc(productModel.id)
        .update({'barcode1':productModel.barcode1.value,'barcode2':productModel.barcode2.value,'barcode3':productModel.barcode3.value}).whenComplete(() => Get.snackbar(
        "done".tr, "product.update.is.done".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white));


  }


  Future<void> addProductToOrder(
      {required String orderId,
        required String userID,
        required String commentQty,
        required int realQty,
        required String productId,
        required bool finishPicked,
        required int pallNr}) async {
    ProductsViewModel productsViewModel=Get.find();
    var ref = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId);
    ref.get().then((value) {
      var addQTy = [];
      var removeItem = [];
      if (value.data()!.containsKey('items')) {
        List oldList = value.data()!['items'];
        if (oldList.where((element) => element['id'] == productId).isNotEmpty) {
          removeItem.add(
              oldList.where((element) => element['id'] == productId).first);
          ref.set({'items': FieldValue.arrayRemove(removeItem)},
              SetOptions(merge: true));
          removeItem.first['qty']+=realQty;
          ref.set({'items': FieldValue.arrayUnion(removeItem)},
              SetOptions(merge: true));

        }
        else{
          List cartItemsToJson() =>
              productsViewModel.productsList.where((p0) => p0.id==productId).map((item) => item.toJson()).toList();
          ProductModel productModel=productsViewModel.productsList.where((p0) => p0.id==productId).first;
          productModel.qty.value=realQty;
          ref.set({'items': FieldValue.arrayUnion(cartItemsToJson())},
              SetOptions(merge: true));
        }
      }

    });
  }

}
