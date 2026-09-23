import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/core/app_dialog.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/view/widget/choose_color_widget.dart';
import 'package:todo_app/view/widget/custom_material_button.dart';
import 'package:todo_app/view/widget/custom_text_form_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String status = "Pending";
   var titleText = TextEditingController();
   var desText = TextEditingController();
   int ColorSelected =4283215696;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text(
          "Add Task",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
               CustomTextFormField(
                   label: "Task Title ",
                   hint: "Design Login Screen",
                   controller: titleText,
                  ),
                 CustomTextFormField(
                   label: "Description ",
                   hint: "Task Description",
                   maxLines: 4,
                   controller: desText,
                  ),
              Text(
                "Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: status,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ["Pending", "Done"]
                        .map(  (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => status = value ?? "Pending");
                    },
                  ),
                ),
              ),
               ChooseColorWidget(
             clickColor: (color) {
               log(color.toString());
               ColorSelected = color;
             },
            ),
            
          CustomMaterialButton(
            onPressed: () 
            async{
             AppDialog.showLoading(context);
         await Future.delayed(const Duration(seconds: 3));
            var taskBox = Hive.box<TaskModel>("Tasks"); 
            await taskBox.add(
               TaskModel(
                 title: titleText.text,
                 description: desText.text,
                 status: status == "Pending"  ? .pending : .done,
                 colortex: ColorSelected,
               ),
             ).then((Value){
              Navigator.of(context).pop();
              titleText.clear();
              desText.clear();
              ColorSelected =4283215696;
             }).catchError((error){
               Navigator.of(context).pop();
               AppDialog.showError(context, error);
             });

           },
           text: "Save",
          ), 
            ],
          ),
        ),
      ),
    );
  }
}

