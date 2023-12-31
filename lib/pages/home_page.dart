import 'dart:io' show Platform;

import 'package:cowchain_farm/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double imageSizeLimit = 536;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        FlutterNativeSplash.remove();
        OneSignal.Notifications.requestPermission(true);
      }
    }
    check();
  }

  // * check for LOGIN status
  void check() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (context.mounted) {
      if (kIsWeb || Platform.isWindows) {
        bool? loggedIn = context.read<CowProvider>().isLoggedIn;
        if (!loggedIn) return context.go('/login');
        if (loggedIn) return context.go('/farm');
      } else if (Platform.isAndroid || Platform.isIOS) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? publicKey = prefs.getString(storedStellarAccountID);

        bool? loggedIn = publicKey != null && publicKey != '';
        if (context.mounted) {
          if (!loggedIn) return context.go('/register-notification');
          if (loggedIn) return context.go('/notification');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: const Color.fromRGBO(255, 255, 255, 0.001),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double widthLimit = constraints.maxWidth >= imageSizeLimit
                        ? imageSizeLimit
                        : constraints.maxWidth;
                    double heightLimit = constraints.maxHeight >= imageSizeLimit
                        ? imageSizeLimit
                        : constraints.maxHeight;
                    double containerSize = widthLimit <= heightLimit ? widthLimit : heightLimit;
                    containerSize = containerSize - 36;
                    if (containerSize < 0) containerSize = 0;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: containerSize,
                          height: containerSize,
                          child: Center(
                            child: Image.asset(
                              'assets/cow-loading.png',
                              height: containerSize,
                              width: containerSize,
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                              alignment: Alignment.topCenter,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        Builder(builder: (context) {
                          if (containerSize == 0) return const SizedBox();
                          return SizedBox(
                            height: 36,
                            child: Wrap(
                              children: [
                                Text(
                                  'COWCHAIN FARM',
                                  style: context.style.headlineLarge?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.6,
                                    fontSize: 42,
                                  ),
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
