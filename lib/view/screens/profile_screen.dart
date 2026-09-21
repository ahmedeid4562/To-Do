import 'dart:math';

import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:hive_flutter/adapters.dart';

import 'package:todo_app/core/app_routes.dart';

import 'package:todo_app/data/model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var fullName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 125),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xffE8ECF5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.person,
                size: 100,
                color: const Color(0xff3F5185),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Create Your Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text("Add Your name and profile picbure"),
            SizedBox(height: 5),
            CustomTextFormField(
              label: "fullName",
              controller: fullName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your name";
                }
                return null;
              },
            ),
            SizedBox(height: 50),
            MaterialButton(
              onPressed: () async {
                 _showLoading();

                print(fullName.text);

                var userBox = Hive.box<UserModel>('User');

                await userBox
                    .put(
                      "User key",
                      UserModel(fullName: fullName.text),
                    )
                    .then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.home);
                      print("Added User");
                    })
                    .catchError((Error) {
                      Navigator.of(context).pop();
                      _showError(Error);
                    });
              },
              padding: EdgeInsets.all(4),
              color: const Color(0xff3F5185),
              minWidth: 320,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "create",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLoading() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            spacing: 20,
            children: [
              CircularProgressIndicator(),
              Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showError(String error) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            "Error Error Form create User ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
    required this.label,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: "Enter your name",
            hintStyle: TextStyle(color: Colors.grey),
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

