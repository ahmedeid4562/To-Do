class TaskModel {
  String title;
  String description;
  StatusTask status;
  int colortex;

  TaskModel({
    required this.title,
    required this.description,
    required this.status,
    required this.colortex,
  });
}

enum StatusTask { pending, done }