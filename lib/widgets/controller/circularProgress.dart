import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularCustom extends StatelessWidget {
  const CircularCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrangeAccent.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 20,),
          Center(child: Text('loading'.tr),)
        ],
      ),
    );
  }
}
