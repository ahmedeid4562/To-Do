import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data/model/task_model.dart';

void main() {
  group("TaskModel Tests", () {
    test("Create task correctly", () {
      final task = TaskModel(
        title: "Flutter Task",
        description: "Learn Hive",
        status: StatusTask.pending,
        colortex: 4283215696,
      );

      expect(task.title, "Flutter Task");
      expect(task.description, "Learn Hive");
      expect(task.status, StatusTask.pending);
    });

    test("Task status can change", () {
      final task = TaskModel(
        title: "Test",
        description: "Test Description",
        status: StatusTask.pending,
        colortex: 4283215696,
      );

      task.status = StatusTask.done;

      expect(task.status, StatusTask.done);
    });
  });
}