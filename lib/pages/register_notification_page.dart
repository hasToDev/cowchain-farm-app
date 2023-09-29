import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterNotificationPage extends StatefulWidget {
  const RegisterNotificationPage({super.key});

  @override
  State<RegisterNotificationPage> createState() => _RegisterNotificationPageState();
}

class _RegisterNotificationPageState extends State<RegisterNotificationPage> {
  bool loading = false;
  final double imageSizeLimit = 572;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                double widthLimit =
                    constraints.maxWidth >= imageSizeLimit ? imageSizeLimit : constraints.maxWidth;
                double heightLimit = constraints.maxHeight >= imageSizeLimit
                    ? imageSizeLimit
                    : constraints.maxHeight;
                double containerSize = widthLimit <= heightLimit ? widthLimit : heightLimit;
                containerSize = containerSize - 72;
                if (containerSize < 0) containerSize = 0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        width: 218,
                        child: AppGradientButton(
                          title: 'Register for Notification',
                          bigger: true,
                          elevation: 12,
                          shadowColor: const Color.fromRGBO(100, 162, 80, 1),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.4, 0.5, 0.6, 0.9],
                            colors: [
                              Color.fromRGBO(157, 204, 142, 1),
                              Color.fromRGBO(100, 162, 80, 1),
                              Color.fromRGBO(100, 162, 80, 1),
                              Color.fromRGBO(100, 162, 80, 1),
                              Color.fromRGBO(157, 204, 142, 1),
                            ],
                          ),
                          onTap: () async {
                            if (loading) return;
                            loading = true;

                            debugPrint('please register');

                            // Show waiting dialog.
                            // if (context.mounted) DialogHelper.waiting(context);

                            loading = false;
                          },
                        ),
                      );
                    }),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
