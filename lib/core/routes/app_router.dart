import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();
  static const String root = '/';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.root,
    routes: [
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Square Repos App'),
          ),
        ),
      ),
    ],
  );
}
