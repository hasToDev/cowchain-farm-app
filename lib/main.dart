import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers/providers.dart';
import 'pages/pages.dart';

export 'contracts/contracts.dart';
export 'core/core.dart';
export 'helpers/helpers.dart';
export 'widgets/widgets.dart';

const String storedStellarAccountID = 'StellarAccountID';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      // Flutter Native Splash Setup
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      // OneSignal setup
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.initialize("4a5afd7e-a6da-4945-ab58-277404c8874b");
    }
  }
  runApp(DApps());
}

class DApps extends StatelessWidget {
  DApps({super.key});

  @override
  Widget build(BuildContext context) {
    List<SingleChildWidget> providerList = [];
    if (kIsWeb || Platform.isWindows) {
      providerList.add(ChangeNotifierProvider<CowProvider>(
        create: (_) => CowProvider(),
      ));
      providerList.add(ChangeNotifierProvider<AuctionProvider>(
        create: (_) => AuctionProvider(),
      ));
    } else if (Platform.isAndroid || Platform.isIOS) {
      providerList.add(ChangeNotifierProvider<NotificationProvider>(
        create: (_) => NotificationProvider(),
      ));
    }

    return MultiProvider(
      providers: providerList,
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
      GoRoute(
        path: "/register-notification",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(state, const RegisterNotificationPage());
        },
      ),
      GoRoute(
        path: "/notification",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(state, const NotificationPage());
        },
      ),
      GoRoute(
        path: "/auction",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(state, const AuctionPage());
        },
      ),
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) {
      return customTransitionPage(state, const HomePage());
    },
    redirect: (BuildContext context, GoRouterState state) async {
      String navPath = state.fullPath ?? '/';

      // * check for LOGIN status based on Platform
      if (kIsWeb || Platform.isWindows) {
        bool? loggedIn = context.read<CowProvider>().isLoggedIn;
        if (!loggedIn && navPath != '/' && navPath != '/login') return '/login';

        // * redirect to FARM if user already LOGIN
        if (loggedIn && navPath == '/login') return '/farm';
      } else if (Platform.isAndroid || Platform.isIOS) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? publicKey = prefs.getString(storedStellarAccountID);

        bool? loggedIn = publicKey != null && publicKey != '';
        if (!loggedIn && navPath != '/' && navPath != '/register-notification') {
          return '/register-notification';
        }

        // * redirect to NOTIFICATION if user already LOGIN
        if (loggedIn && navPath == '/register-notification') return '/notification';
      }

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
