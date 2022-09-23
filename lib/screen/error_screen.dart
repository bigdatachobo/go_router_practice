import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_practice/layout/default_layout.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Column(
        children: [
          Text(error),
          ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('홈으로'))
        ],
      ),
    );
  }
}
