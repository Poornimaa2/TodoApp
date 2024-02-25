import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_list.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF347306),
        // TRY THIS: Change to "Brightness.light"
        //           and see that all colors change
        //           to better contrast a light background.
        brightness: Brightness.dark,
        )),
      home: const TodoListPage(),
    );
  }
}


