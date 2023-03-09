import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../core/view_model/users_view_model.dart';
import '../widgets/controller/custom_action_bar_users.dart';
import '../widgets/users_controller/select_users_card.dart';
import '../widgets/users_controller/users_card.dart';

class SelectUserOrder extends GetWidget {
  final appSetting = GetStorage();
  SelectUserOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UsersViewModel());
    return new Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return new Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                height: 24.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                  child: Center(
                    child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                  ),
                ),
              ),
              Center(
                child: GetX(builder: (UsersViewModel controller) {
                  return (!controller.loading.value)
                      ? Column(
                          children: <Widget>[
                            const CustomActionBarUsers(
                              title: 'Kunder',
                            ),
                            Flexible(
                              child: DefaultTabController(
                                length: 3,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: controller
                                                .find.value.isNotEmpty
                                            ? controller.usersList
                                                .where((p0) => p0
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        controller.find.value))
                                                .length
                                            : controller.usersList.length,
                                        itemBuilder: (_, index) {
                                          return SelectUserCard(
                                            index: index,
                                            users: controller
                                                    .find.value.isNotEmpty
                                                ? controller.usersList
                                                    .where((p0) => p0
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(controller
                                                            .find.value))
                                                    .toList()
                                                : controller.usersList.toList(),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Expanded(child: OrdersListview()),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator());
                }),
              ),
            ],
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'There are no bottons to push :)',
            ),
            new Text(
              'Just turn off your internet.',
            ),
          ],
        ),
      ),
    );
  }
}
