import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_practice/layout/default_layout.dart';

class ThreeScreen extends StatelessWidget {
  static String get routeName => 'three';

  const ThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('POP')),
          Text('ThreeScreen')
        ],
      ),
    );
  }
}
