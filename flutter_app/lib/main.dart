import 'package:flutter/material.dart';
import 'package:planus/pages/map.dart';

void main() {
  runApp(const MyApp());
}

//coucou
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MapboxScreen(),
    );
  }
}
