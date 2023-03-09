import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:datawedgeflutter/Tabs/orders_tab_new.dart';
import 'package:datawedgeflutter/Tabs/select_user.dart';
import 'package:datawedgeflutter/pages/pickup_cart_page_locally.dart';
import 'package:datawedgeflutter/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Tabs/manuel_orders_tab.dart';
import 'Tabs/products_tab.dart';
import 'Tabs/users_tab.dart';
import 'core/view_model/auth_view_model.dart';
import 'pages/ameen_products_import.dart';
import 'pages/pick_order_page_manuel.dart';
import 'pages/pickup_cart_page.dart';
import 'pages/pickup_order_page_barcode.dart';
import 'pages/search_page_2.dart';
import 'widgets/controller/constants.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {

  @override
  Widget build(BuildContext context) {
      AuthViewModel authViewModel=Get.find();
    return BottomNavLayout(
      pages: [
        (navKey) => UsersNavigator(navKey: navKey),
            (navKey) => ProductsNavigator(navKey: navKey),

        (navKey) => ManuelOrdersNavigator(navKey: navKey),
        (navKey) => OrdersNavigator(navKey: navKey),
      ],
      bottomNavigationBar: (currentIndex, onTap) => BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => onTap(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: currentIndex == 0
              ? AppColors.activeColor
              : AppColors.secondaryColor,
            ),
            label: 'Kunder',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.image,
              color: currentIndex == 1
              ? AppColors.activeColor
              : AppColors.secondaryColor,
            ),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_business,
              color: currentIndex == 2
                  ? AppColors.activeColor
                  : AppColors.blackColor,
            ),
            label: 'Manuel Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard_outlined,
              color: currentIndex == 3
                  ? AppColors.activeColor
                  : AppColors.blackColor,
            ),
            label: 'Orders',
          ),
        ],
      ),
      savePageState: true,
      lazyLoadPages: true,
      pageTransitionData: PageTransitionData(
        builder: PrebuiltAnimationBuilderBuilders.zoomInAndFadeOut,
        duration: 150,
        direction: AnimationDirection.inAndOut,
      ),
    );
  }
}

class UsersNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const UsersNavigator({Key? key, required this.navKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/UsersTab':
                  return UsersTab();
                default:
                  return  UsersTab();
              }
            });
      },
    );
  }
}

class ProductsNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const ProductsNavigator({Key? key, required this.navKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/ProductsTab':
                  return ProductsTab();
                case '/ItemsVerticalListViewItems':
                default:
                  return  ProductsTab();
              }
            });
      },
    );
  }
}

class ManuelOrdersNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const ManuelOrdersNavigator({Key? key, required this.navKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/ManuelOrdersTab':
                  return const ManuelOrdersTab();
                case '/SelectUserOrder':
                  return  SelectUserOrder();
                case '/PickOrderPageLocally':
                  return PickOrderPageLocally();
                case '/SearchPage':
                  return SearchPage();

                default:
                  return const ManuelOrdersTab();
              }
            });
      },
    );
  }
}

class OrdersNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const OrdersNavigator({Key? key, required this.navKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/OrdersTab':
                  return  OrdersTabNew();
                case '/PickOrderPageManuel':
                return const PickOrderPageManuel();
                case '/PickOrderPageBarcode':
                return  PickOrderPageBarcode();
                case '/SearchPage2':
                  return SearchPage2();

                default:
                  return  OrdersTabNew();
              }
            });
      },
    );
  }
}

