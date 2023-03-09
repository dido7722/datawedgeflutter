import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthViewModel extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    signInWithEmailAndPassword();
    super.onInit();
  }
  void signInWithEmailAndPassword() async {
    try {

        await _auth.signInWithEmailAndPassword(email: 'dido772@gmail.com', password: 'Jfa5593481418');
    } on FirebaseAuthException catch (e) {
      print(e.message);

      Get.snackbar("Error login account", e.message.toString(),
          snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.white);
    }
  }

}
