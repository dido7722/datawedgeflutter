import 'dart:async';
import 'package:datawedgeflutter/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'services/binding.dart';
import 'services/translation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await GetStorage.init(); //get storage initialization

  runApp( MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        navigatorKey: Get.key,
        navigatorObservers: [GetObserver((_) {}, Get.routing)],
        debugShowCheckedModeBanner: false,
        locale: const Locale("ar",""),
        translations: TranslationValues(),

        initialBinding: Binding(),

        theme: ThemeData(
          // ignore: deprecated_member_use
            fontFamily: 'BuenosAires', accentColor: const Color(0xFFFF1E00)),
        // home: appSetting.read(firstStartUp) ? Get.toNamed("/NextScreen",):Get.toNamed("/NextScreen"),
        home:   const DashBoard(),
      );
    });
  }
}