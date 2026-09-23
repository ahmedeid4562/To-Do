import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/core/app_dialog.dart';
import 'package:todo_app/core/app_routes.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/view/widget/custom_material_button.dart';
import 'package:todo_app/view/widget/custom_text_form_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final fullName = TextEditingController();

  @override
  void dispose() {
    fullName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 125),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xffE8ECF5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.person,
                size: 100,
                color: Color(0xff3F5185),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Create Your Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Add Your name and profile picture"),
            const SizedBox(height: 5),
            CustomTextFormField(
              hint: "Enter Your name",
              label: "Full Name",
              controller: fullName,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter your name" : null,
            ),
            const SizedBox(height: 50),
            CustomMaterialButton(
              text: "Create",
              onPressed: () {
                AppDialog.showLoading(context);
                
                var userBox = Hive.box<UserModel>('User');
                
                userBox.put("UserKey", UserModel(fullName: fullName.text)).then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(AppRoutes.home);
                }).catchError((error) {
                  Navigator.of(context).pop();
                  AppDialog.showError(context, error.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}