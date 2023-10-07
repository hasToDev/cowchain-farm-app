import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' hide Row;

import '../helpers/measurement_util.dart';

class RegisterNotificationPage extends StatefulWidget {
  const RegisterNotificationPage({super.key});

  @override
  State<RegisterNotificationPage> createState() => _RegisterNotificationPageState();
}

class _RegisterNotificationPageState extends State<RegisterNotificationPage> {
  bool loading = false;
  final double imageSizeLimit = 572;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  double widthLimit = constraints.maxWidth >= imageSizeLimit
                      ? imageSizeLimit
                      : constraints.maxWidth;
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

                        Widget appTitle = Wrap(
                          runAlignment: WrapAlignment.center,
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
                        );
                        Size textSize = MeasurementUtil.measureWidget(
                            SizedBox(width: constraints.maxWidth, child: appTitle));

                        return SizedBox(
                          height: textSize.height + 12,
                          child: appTitle,
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
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            height: 36,
                            width: 218,
                            child: AppGradientButton(
                              title: 'Register for Notification',
                              bigger: true,
                              elevation: 6,
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

                                // Ask for Public Key / Account ID.
                                bool? isPublicKeyConfirmed =
                                    await DialogHelper.forRegisterNotification(context, controller);

                                // Check to ensure Public Key / Account ID not empty.
                                if (isPublicKeyConfirmed == null || !isPublicKeyConfirmed) {
                                  controller.clear();
                                  loading = false;
                                  return;
                                }
                                if (context.mounted && controller.text.isEmpty) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    DialogHelper.failures(context, AppMessages.publicKeyEmpty);
                                  });
                                  loading = false;
                                  return;
                                }

                                // Check to ensure Public Key / Account ID is valid.
                                late KeyPair userKeyPair;
                                try {
                                  userKeyPair = KeyPair.fromAccountId(controller.text);
                                } catch (_) {
                                  if (context.mounted) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      DialogHelper.failures(context, AppMessages.publicKeyInvalid);
                                    });
                                    loading = false;
                                    return;
                                  }
                                }

                                // Check to ensure OneSignal Subscription ID is available.
                                if (OneSignal.User.pushSubscription.id == null) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    DialogHelper.failures(
                                        context, AppMessages.oneSignalIdNotAvailable);
                                  });
                                  loading = false;
                                  return;
                                }

                                // Show waiting dialog.
                                if (context.mounted) {
                                  controller.clear();
                                  DialogHelper.waiting(context);
                                }

                                // Login to OneSignal, register this device to receive notification.
                                await OneSignal.login(userKeyPair.accountId);

                                // Save login data to storage.
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    storedStellarAccountID, userKeyPair.accountId);

                                // upon successful login, go to Notification Page.
                                if (context.mounted) {
                                  context.go('/notification');
                                }

                                loading = false;
                              },
                            ),
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
      ),
    );
  }
}
