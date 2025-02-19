import 'package:flutter/material.dart';
import 'package:smart_contract/features/ui/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt biểu tượng debug
      title: 'Wallet App',
      home: DashBoardPage(),
    );
  }
}
