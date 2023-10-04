import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/measurement_util.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool loading = false;
  final double imageSizeLimit = 572;
  String accountID = '';

  @override
  void initState() {
    super.initState();
    loadPublicKey();
  }

  void loadPublicKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? publicKey = prefs.getString(storedStellarAccountID);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (publicKey != null) accountID = publicKey;
      });
    });
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

                        Widget listeningDescription = Wrap(
                          runAlignment: WrapAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'Currently listening for notifications for the following account :',
                                style: context.style.titleMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 26,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                        Size textSize = MeasurementUtil.measureWidget(
                            SizedBox(width: constraints.maxWidth, child: listeningDescription));

                        return SizedBox(
                          height: textSize.height + 8,
                          child: listeningDescription,
                        );
                      }),
                      Builder(builder: (context) {
                        if (containerSize == 0) return const SizedBox();

                        Widget listeningForAccountID = Wrap(
                          runAlignment: WrapAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                accountID,
                                style: context.style.titleLarge?.copyWith(
                                  color: const Color.fromRGBO(100, 162, 80, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                maxLines: 26,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                        Size textSize = MeasurementUtil.measureWidget(
                            SizedBox(width: constraints.maxWidth, child: listeningForAccountID));

                        return SizedBox(
                          height: textSize.height + 8,
                          child: listeningForAccountID,
                        );
                      }),
                      Builder(builder: (context) {
                        if (containerSize == 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            height: 36,
                            width: 100,
                            child: AppGradientButton(
                              title: 'Logout',
                              bigger: true,
                              elevation: 6,
                              shadowColor: const Color.fromRGBO(244, 67, 54, 1),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.1, 0.4, 0.5, 0.6, 0.9],
                                colors: [
                                  Color.fromRGBO(249, 161, 154, 1),
                                  Color.fromRGBO(244, 67, 54, 1),
                                  Color.fromRGBO(244, 67, 54, 1),
                                  Color.fromRGBO(244, 67, 54, 1),
                                  Color.fromRGBO(249, 161, 154, 1),
                                ],
                              ),
                              onTap: () async {
                                if (loading) return;
                                loading = true;

                                // confirm user to logout
                                bool? result =
                                    await DialogHelper.logoutConfirmation(context, accountID);
                                if (result == null || !result) {
                                  loading = false;
                                  return;
                                }

                                // Show waiting dialog.
                                if (context.mounted) DialogHelper.waiting(context);

                                // logout from onesignal.
                                await OneSignal.logout();

                                // Remove login data from storage.
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove(storedStellarAccountID);

                                // go to register notification page
                                if (context.mounted) {
                                  context.go('/register-notification');
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
