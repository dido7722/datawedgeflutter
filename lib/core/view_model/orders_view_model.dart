import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/order_model.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';
import 'users_view_model.dart';

class OrdersViewModel extends GetxController {
  RxBool loadingProducts = false.obs;

  RxList<UserModel> get usersList => <UserModel>[].obs;
  RxList<OrderModel> ordersList = <OrderModel>[].obs;
  RxList<ProductModel> orderProductList = <ProductModel>[].obs;
  String orderID = '';
  RxString find = ''.obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllOrders();
  }

  Future<RxList<OrderModel>> getAllOrders() async {
    loading.value=true;

    ordersList.clear();
      FirebaseFirestore.instance
          .collection('orders')
          .orderBy('sort')
          .snapshots()
          .listen((orders) async {
        orders.docs.forEach((order) async {
          if (ordersList.where((p0) => p0.id == order['id']).isEmpty) {
            ordersList.add(OrderModel.fromSnapshot(order));
            // ordersList.last.userName = user.name.toString();
            // ordersList.last.nickName = user.nickName.toString();
          // } else {
          //   ordersList.removeWhere((p0) => p0.id == order['id']);
          //   ordersList.add(OrderModel.fromSnapshot(order));
            // ordersList.last.userName = user.name.toString();
            // ordersList.last.nickName = user.nickName.toString();
          }
        });
        update();
      });

    update();
    loading.value=false;

    return ordersList;
  }

  Future<OrderModel> getOrderItems(String orderID, String userID) async {
    // _loadingProducts.value=true;
    OrderModel orderModel = ordersList.where((p0) => p0.id == orderID).first;

    var list;

    await FirebaseFirestore.instance
        .collection('users/$userID/Orders/')
        .doc(orderID)
        .snapshots()
        .listen((order) async {
      order.data()!.forEach((key, value) async {
        if (key == 'items') {
          list = List.from(value);
          await list.forEach((element) {
            orderModel.productModel
                .add(ProductModel.fromSnapshotOrder(element));
          });
        }
      });
    });
    return orderModel;
  }

  getOrderProducts() async {
    // ignore: body_might_complete_normally_nullable
    Future<List<ProductModel>?> getProducts() async {
      orderProductList.clear();
      ordersList
          .where((p0) => p0.id == orderID)
          .first
          .productModel
          .forEach((elementCart) {
        orderProductList.add(elementCart);
      });
    }

    await getProducts();
    update();
    return orderProductList;
  }

  final UsersViewModel _usersViewModel = Get.find();
}
