import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                        width: 100,
                        child: AppGradientButton(
                          title: 'Login',
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

                            // trying login.
                            var (bool successLogin, String? accountID) = await tryLogin(context);
                            if (!successLogin) {
                              loading = false;
                              return;
                            }

                            // Show waiting dialog.
                            if (context.mounted) DialogHelper.waiting(context);

                            // get latest ledger sequence.
                            int sequence = await CowContract.getLatestLedgerSequence();

                            // Fetch all user Cow Data.
                            var (GetAllCowResult result, String? error) =
                                await CowContract.invokeGetAllCow(
                              accountID: accountID!,
                            );

                            // Call dialog if error exist.
                            String? errorMessage = error;
                            if (result.status != Status.ok) {
                              // Check for specific error status returned from contract.
                              if (result.status == Status.fail) {
                                // do nothing.
                              }
                            }
                            if (errorMessage != null && context.mounted) {
                              Navigator.pop(context);
                              await Future.delayed(const Duration(milliseconds: 100));
                              if (context.mounted) DialogHelper.failures(context, errorMessage);
                              loading = false;
                              return;
                            }

                            // upon successful login, go to Farm Page.
                            if (context.mounted) {
                              context.read<CowProvider>().updateCowDataList(result.data);
                              context.read<CowProvider>().updateSequence(sequence);
                              context.read<CowProvider>().sequencePeriodicUpdate();
                              context.go('/farm');
                            }

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

  /// [tryLogin]
  /// Login to Cowchain Farm using Freighter
  Future<(bool, String?)> tryLogin(BuildContext ctx) async {
    // * check Freighter connection
    var (bool? isConnected, FreighterTimeout isConnectedTimeout) =
        await FreighterHelper.isConnected();
    if (isConnectedTimeout || !isConnected!) {
      if (ctx.mounted) DialogHelper.failures(context, AppMessages.connectFreighter);

      loading = false;
      return (false, null);
    }

    // * check Freighter permission
    var (bool? isAllowed, FreighterTimeout isAllowedTimeout) = await FreighterHelper.isAllowed();
    if (isAllowedTimeout) {
      if (ctx.mounted) DialogHelper.failures(context, AppMessages.timeoutFreighter);
      loading = false;
      return (false, null);
    }

    // * allow access Freighter
    if (!isAllowed!) {
      var (bool? setAllowed, FreighterTimeout setAllowedTimeout) =
          await FreighterHelper.setAllowed();
      if (setAllowedTimeout || !setAllowed!) {
        String errMessage = AppMessages.allowFreighterShareData;
        if (setAllowedTimeout) errMessage = AppMessages.timeoutFreighter;
        if (ctx.mounted) DialogHelper.failures(context, errMessage);
        loading = false;
        return (false, null);
      }
    }

    // * get Freighter current wallet Public Key
    var (String? publicKey, FreighterTimeout publicKeyTimeout) =
        await FreighterHelper.getPublicKey();
    if (publicKeyTimeout || publicKey!.isEmpty) {
      String errMessage = AppMessages.publicKeyNotFound;
      if (publicKeyTimeout) errMessage = AppMessages.timeoutFreighter;
      if (ctx.mounted) DialogHelper.failures(context, errMessage);
      loading = false;
      return (false, null);
    }

    // * confirm user to use current Public Key
    bool? result;
    if (ctx.mounted) result = await DialogHelper.forLogin(context, publicKey);
    if (result == null || !result) {
      loading = false;
      return (false, null);
    }

    if (ctx.mounted) return (ctx.read<CowProvider>().userLoggedIn(publicKey), publicKey);
    return (false, null);
  }
}
