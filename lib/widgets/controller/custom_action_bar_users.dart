import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/view_model/users_view_model.dart';


class CustomActionBarUsers extends StatefulWidget {
  const CustomActionBarUsers({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  State<CustomActionBarUsers> createState() => _CustomActionBarUsersState();
}

class _CustomActionBarUsersState extends State<CustomActionBarUsers> {
  final UsersViewModel _usersViewModel = Get.find();

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 5,
        left: 24.0,
        right: 24.0,
        bottom: 15.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade200,
            ),
            child: TextField(
              controller: myController,
              onChanged: (value) {
                _usersViewModel.find.value = value;
              },
              onTap: () {},
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffixIcon: CloseButton(
                    onPressed: () {
                      myController.clear();
                      _usersViewModel.find.value = '';
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  hintText: "search".tr,
                  fillColor: Colors.grey,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 15.0,
                  )),
              style: TextStyle(
                  fontSize: 11.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
