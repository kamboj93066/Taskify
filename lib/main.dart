import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/screens/home_page.dart';
import 'package:todo/utils/priority_adaptor.dart';

void main() async {
  // initialize the hive
  await Hive.initFlutter();

  // register the enum priority
  Hive.registerAdapter(PriorityAdapter());

  // open a box
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.brown,
        primarySwatch: Colors.lime,
      ),
      home: HomePage(),
    );
  }
}
