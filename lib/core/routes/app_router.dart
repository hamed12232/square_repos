import 'package:go_router/go_router.dart';
import '../../features/presentaion/pages/home_repo_screen.dart';

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
        builder: (context, state) => const HomeRepoScreen(),
      ),
    ],
  );
}
