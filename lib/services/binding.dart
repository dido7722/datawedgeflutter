
import 'package:datawedgeflutter/core/view_model/ameen_import_view_model.dart';
import 'package:datawedgeflutter/core/view_model/barcode_product_view_model.dart';
import 'package:datawedgeflutter/core/view_model/categories_view_model.dart';
import 'package:get/get.dart';

import '../core/view_model/auth_view_model.dart';
import '../core/view_model/cart_products_view_model.dart';
import '../core/view_model/order_products_view_model.dart';
import '../core/view_model/manuel_orders_view_model.dart';
import '../core/view_model/orders_view_model.dart';
import '../core/view_model/products_view_model.dart';
import '../core/view_model/users_view_model.dart';

class Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>UsersViewModel());
    Get.lazyPut(()=>AuthViewModel());
    Get.lazyPut(()=>ProductsViewModel());
    Get.lazyPut(()=>OrdersViewModel());
    Get.lazyPut(()=>ManuelOrdersViewModel());
    Get.lazyPut(()=>CartProductsViewModel());
    // Get.lazyPut(()=>AmeenImportViewModel());
    // Get.lazyPut(()=>CategoriesViewModel());
    // Get.lazyPut(()=>BarcodeProductViewModel());
    // Get.lazyPut(()=>AuthViewModel());
    Get.lazyPut(()=>OrderProductsViewModel());
  }

}