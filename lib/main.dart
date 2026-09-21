import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/view/screens/add_task_screen.dart';
import 'package:todo_app/view/screens/home_screen.dart';
import 'package:todo_app/view/screens/profile_screen.dart';
import 'core/app_routes.dart';

void main() async{
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
    Hive.registerAdapter(UserModelAdapter());
    Hive.openBox<UserModel>('User');

  runApp(const ToDOApp());
}

class ToDOApp extends StatelessWidget {
  const ToDOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.profile,
      routes: {
        AppRoutes.profile: (context) => ProfileScreen(),
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.addTask: (context) => AddTaskScreen(),
      },
    );
  }
}