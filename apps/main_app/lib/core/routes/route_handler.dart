import 'package:go_router/go_router.dart';
import 'package:main_app/features/home/presentation/home_page.dart';

class RouteHandler {
  static final routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(path: '/sign-in', builder: (context, state) => HomePage()),
    ],
  );
}
