import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/core/app_routes.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/view/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> Tasks = [];

  int numOfTasks = 0;
  int numOfPending = 0;
  int numOfDon = 0;

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          spacing: 24,
          children: [
            const SizedBox(height: 70),

            HeaderWidget(
              fullName: getName(),
            ),

            TaskInfoDetails(
              numOfTasks: numOfTasks,
              numOfPending: numOfPending,
              numOfDon: numOfDon,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Tasks",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return TaskItem(
                    task: Tasks[index],
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddTaskScreen(
                            task: Tasks[index],
                            index: index,
                          ),
                        ),
                      );

                      getAllTasks();
                    },
                    delete: () {
                      deleteItem(index);
                    },
                  );
                },
                itemCount: Tasks.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          await Navigator.of(context).pushNamed(
            AppRoutes.addTask,
          );

          getAllTasks();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xff4F6FD8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                offset: const Offset(20, 10),
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            spacing: 15,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add,
                size: 30,
              ),
              Text("Task"),
            ],
          ),
        ),
      ),
    );
  }

  void getAllTasks() {
    var taskBox = Hive.box<TaskModel>("Tasks");

    setState(() {
      Tasks = taskBox.values.toList();
      numbers();
    });
  }

  String getName() {
    var taskBox = Hive.box<UserModel>("User");

    var User = taskBox.get("UserKey");

    return User?.fullName ?? "Error Front Name";
  }

  void numbers() {
    numOfTasks = Tasks.length;

    numOfDon = Tasks
        .where(
          (e) => e.status == StatusTask.done,
        )
        .toList()
        .length;

    numOfPending = Tasks
        .where(
          (e) => e.status == StatusTask.pending,
        )
        .toList()
        .length;
  }

  void deleteItem(int index) {
    var taskBox = Hive.box<TaskModel>("Tasks");

    taskBox.deleteAt(index);

    setState(() {
      Tasks = taskBox.values.toList();
      numbers();
    });
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.fullName,
  });

  final String fullName;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffE8ECF5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.person,
            size: 25,
            color: Color(0xff3F5185),
          ),
        ),
        Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          spacing: 10,
          children: [
            Text(
              "Good Morning👋",
              style: TextStyle(
                fontSize: 16,
                fontWeight: .w400,
                color: Colors.grey,
              ),
            ),
            Text(
              fullName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: .bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TaskInfoDetails extends StatelessWidget {
  const TaskInfoDetails({
    super.key,
    required this.numOfDon,
    required this.numOfPending,
    required this.numOfTasks,
  });

  final int numOfTasks;
  final int numOfPending;
  final int numOfDon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Color(0xff3F51B5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: .spaceAround,
        children: [
          item(numOfTasks, "Tasks"),
          item(numOfPending, "pending"),
          item(numOfDon, "Done"),
        ],
      ),
    );
  }

  Widget item(int num, String des) {
    return Column(
      spacing: 10,
      mainAxisSize: .min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 30,
            fontWeight: .bold,
            color: Colors.white,
          ),
        ),
        Text(
          des,
          style: TextStyle(
            fontSize: 16,
            fontWeight: .bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    this.onTap,
    required this.delete,
  });

  final TaskModel task;
  final VoidCallback? onTap;
  final void Function()? delete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffFFFFFF),
        ),
        child: Row(
          children: [
            Container(
              height: 75,
              width: 17,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(task.colortex),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 5),

                  SizedBox(
                    child: Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Color(task.colortex).withAlpha(100),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      task.status == StatusTask.pending
                          ? "Pending"
                          : "Done",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(task.colortex),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            IconButton(
              onPressed: delete,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}