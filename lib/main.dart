import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/providers/providers.dart';
import 'pages/pages.dart';

export 'contracts/contracts.dart';
export 'core/core.dart';
export 'helpers/helpers.dart';
export 'widgets/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DApps());
}

class DApps extends StatelessWidget {
  DApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CowProvider>(
          create: (_) => CowProvider(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Cowchain Farm',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(238, 246, 238, 1),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(96, 172, 71, 1)),
          splashFactory: InkRipple.splashFactory,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: _router,
      ),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(state, const HomePage());
        },
      ),
      GoRoute(
        path: "/login",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(state, const LoginPage());
        },
      ),
      GoRoute(
        path: "/farm",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(state, const FarmPage());
        },
      ),
      GoRoute(
        path: "/market",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(state, const MarketPage());
        },
      ),
      GoRoute(
        path: "/credit",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(state, const CreditPage());
        },
      ),
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) {
      return customTransitionPage(state, const HomePage());
    },
    redirect: (BuildContext context, GoRouterState state) async {
      String navPath = state.fullPath ?? '/';

      // * check for LOGIN status
      bool? loggedIn = context.read<CowProvider>().isLoggedIn;
      if (!loggedIn && navPath != '/' && navPath != '/login') return '/login';

      // * redirect to FARM if user already LOGIN
      if (loggedIn && navPath == '/login') return '/farm';

      return null;
    },
  );
}

CustomTransitionPage<void> customTransitionPage(GoRouterState state, Widget screen) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: screen,
    transitionDuration: const Duration(milliseconds: 50),
    reverseTransitionDuration: const Duration(milliseconds: 50),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}
