import 'package:fl_pkgtesting/screens/home_screen/functions/theme_dropdown.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Base'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ThemeDropdown(),
          ),
        ],
      ),
      body: const Center(
        child: Text('Application Content'),
      ),
    );
  }
}
