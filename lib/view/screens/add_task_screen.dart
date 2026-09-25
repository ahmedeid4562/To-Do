import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/core/app_dialog.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/view/widget/choose_color_widget.dart';
import 'package:todo_app/view/widget/custom_material_button.dart';
import 'package:todo_app/view/widget/custom_text_form_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
    this.task,
    this.index,
  });

  final TaskModel? task;
  final int? index;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String status = "Pending";

  var titleText = TextEditingController();
  var desText = TextEditingController();

  int ColorSelected = 4283215696;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleText.text = widget.task!.title;
      desText.text = widget.task!.description;

      status = widget.task!.status == StatusTask.pending
          ? "Pending"
          : "Done";

      ColorSelected = widget.task!.colortex;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.task != null;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Task" : "Add Task",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
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

              const Text(
                "Status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: status,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    items: ["Pending", "Done"]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        status = value ?? "Pending";
                      });
                    },
                  ),
                ),
              ),

              ChooseColorWidget(
                clickColor: (color) {
                  log(color.toString());

                  setState(() {
                    ColorSelected = color;
                  });
                },
              ),

              CustomMaterialButton(
                onPressed: () async {
                  AppDialog.showLoading(context);

                  await Future.delayed(
                    const Duration(seconds: 1),
                  );

                  var taskBox = Hive.box<TaskModel>("Tasks");

                  if (isEdit) {
                    widget.task!.title = titleText.text;
                    widget.task!.description = desText.text;
                    widget.task!.status = status == "Pending"
                        ? StatusTask.pending
                        : StatusTask.done;
                    widget.task!.colortex = ColorSelected;

                    await taskBox.putAt(
                      widget.index!,
                      widget.task!,
                    );
                  } else {
                    await taskBox.add(
                      TaskModel(
                        title: titleText.text,
                        description: desText.text,
                        status: status == "Pending"
                            ? StatusTask.pending
                            : StatusTask.done,
                        colortex: ColorSelected,
                      ),
                    );
                  }

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                text: isEdit ? "Update" : "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}