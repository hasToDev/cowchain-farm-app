import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FarmPage extends StatefulWidget {
  const FarmPage({super.key});

  @override
  State<FarmPage> createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  String accountID = '';

  @override
  void initState() {
    super.initState();
    accountID = context.read<CowProvider>().accountID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(112, 180, 89, 1),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              Text(
                                'Cowchain FARM',
                                style: context.style.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Builder(
                                builder: (BuildContext context) {
                                  double maxWidth = constraints.maxWidth;
                                  double leftPad = 0;
                                  double rightPad = 0;
                                  if (maxWidth >= 574) {
                                    leftPad = maxWidth - 574;
                                  } else if (maxWidth >= 384 && maxWidth < 574) {
                                    rightPad = maxWidth - 384;
                                  } else if (maxWidth >= 298 && maxWidth < 384) {
                                    rightPad = maxWidth - 298;
                                  } else if (maxWidth >= 192 && maxWidth < 298) {
                                    rightPad = maxWidth - 192;
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: leftPad,
                                      right: rightPad,
                                    ),
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      runAlignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      runSpacing: 16,
                                      children: barActionButtons(context),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    WelcomeUser(account: accountID),
                    Selector<CowProvider, List<CowData>>(
                      selector: (context, cowProvider) => cowProvider.cows,
                      builder: (BuildContext context, List<CowData> cows, Widget? child) {
                        if (cows.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                                border: Border.all(color: const Color.fromRGBO(255, 123, 0, 0.45)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(255, 123, 0, 0.35),
                                    offset: Offset(0, 4),
                                    blurRadius: 25,
                                    spreadRadius: 0.25,
                                  ),
                                ]),
                            child: Text(
                              'Right now you don\'t have any cow.\nYou can buy them at the MARKET.',
                              style: context.style.titleMedium?.copyWith(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 14,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        List<Widget> cowList = cows.map((CowData data) {
                          return CowCard(
                            data: data,
                            onSell: () async => await sellingCow(context, data),
                            onFeed: () async => await feedTheCow(context, data),
                          );
                        }).toList();

                        double padding = 0;
                        if (constraints.maxWidth >= 965) padding = (constraints.maxWidth - 965) / 2;

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            spacing: 32,
                            runSpacing: 32,
                            children: cowList,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Contains list of Navigation button for farm page.
  List<Widget> barActionButtons(BuildContext context) {
    return [
      Container(
        width: 150,
        padding: const EdgeInsets.only(right: 24),
        child: AppGradientButton(
          title: 'go to MARKET',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: [
              Color.fromRGBO(255, 162, 76, 1),
              Color.fromRGBO(255, 123, 0, 1),
              Color.fromRGBO(255, 123, 0, 1),
              Color.fromRGBO(255, 123, 0, 1),
              Color.fromRGBO(255, 162, 76, 1),
            ],
          ),
          onTap: () async {
            context.go('/market');
          },
        ),
      ),
      Container(
        width: 106,
        padding: const EdgeInsets.only(right: 24),
        child: AppGradientButton(
          title: 'CREDIT',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: [
              Color.fromRGBO(77, 158, 227, 1),
              Color.fromRGBO(2, 117, 216, 1),
              Color.fromRGBO(2, 117, 216, 1),
              Color.fromRGBO(2, 117, 216, 1),
              Color.fromRGBO(77, 158, 227, 1),
            ],
          ),
          onTap: () async => context.go('/credit'),
        ),
      ),
      SizedBox(
        width: 88,
        child: AppGradientButton(
          title: 'LOGOUT',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: [
              Color.fromRGBO(247, 123, 114, 1),
              Color.fromRGBO(244, 67, 54, 1),
              Color.fromRGBO(244, 67, 54, 1),
              Color.fromRGBO(244, 67, 54, 1),
              Color.fromRGBO(247, 123, 114, 1),
            ],
          ),
          onTap: () async {
            context.read<CowProvider>().userLoggedOut();
            context.go('/login');
          },
        ),
      ),
    ];
  }

  /// [sellingCow]
  /// A set of function for calling sell_cow method on Cowchain Farm contract.
  Future<void> sellingCow(BuildContext context, CowData data) async {
    // Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    var (CowAppraisalResult appraisal, String? errorAppraisal) =
        await CowContract.invokeCowAppraisal(accountID: accountID, cowID: data.id);

    // Pop current dialog and wait 100ms before continue.
    if (context.mounted) {
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Call dialog if error exist.
    String? errorMessage = errorAppraisal;
    if (errorMessage != null && context.mounted) {
      DialogHelper.failures(context, errorMessage);
      return;
    }

    // Ask for user confirmation regarding cow's appraisal price.
    if (context.mounted) {
      bool? isPriceApproved = await DialogHelper.forAppraisal(context, data.name, appraisal.price);
      if (isPriceApproved != null && !isPriceApproved) return;
    }

    // Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    // Continue selling cow.
    var (SellCowResult result, String? error) =
        await CowContract.invokeSellCow(accountID: accountID, cowID: data.id);

    // Pop current dialog and wait 100ms before continue.
    if (context.mounted) {
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Call dialog if error exist.
    errorMessage = error;
    if (errorMessage != null && context.mounted) {
      DialogHelper.failures(context, errorMessage);
      return;
    }

    // Update cow data.
    if (context.mounted) {
      context.read<CowProvider>().removeCow(data);
      context.read<CowProvider>().updateOwnership(result.ownership);
    }
  }

  /// [feedTheCow]
  /// A set of function for calling feed_the_cow method on Cowchain Farm contract.
  Future<void> feedTheCow(BuildContext context, CowData data) async {
    // Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    var (FeedTheCowResult result, String? error) =
        await CowContract.invokeFeedTheCow(accountID: accountID, cowID: data.id);

    // Pop current dialog and wait 100ms before continue.
    if (context.mounted) {
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Call dialog if error exist.
    String? errorMessage = error;
    if (errorMessage != null && context.mounted) {
      DialogHelper.failures(context, errorMessage);
      return;
    }

    // Update cow data.
    if (context.mounted) {
      context.read<CowProvider>().updateCowLastFed(data, result.lastFedLedger);
    }
  }
}
