import 'dart:convert';

import 'package:cowchain_farm/main.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' show Util;

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  late TextEditingController controller;
  String accountID = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
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
                                'Cowchain MARKET',
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
                                  if (maxWidth >= 600) {
                                    leftPad = maxWidth - 600;
                                  } else if (maxWidth >= 378 && maxWidth < 600) {
                                    rightPad = maxWidth - 378;
                                  } else if (maxWidth >= 232 && maxWidth < 378) {
                                    rightPad = maxWidth - 232;
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
                    Builder(builder: (BuildContext context) {
                      double padding = 0;
                      if (constraints.maxWidth >= 965) padding = (constraints.maxWidth - 965) / 2;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.spaceBetween,
                          spacing: 32,
                          runSpacing: 32,
                          children: cowMarketList(context),
                        ),
                      );
                    }),
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

  // Contains list of Navigation button for market page.
  List<Widget> barActionButtons(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 24),
        child: AppButton(
          title: 'back to FARM',
          backgroundColor: const Color.fromRGBO(255, 123, 0, 1),
          onTap: () async {
            context.go('/farm');
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 24),
        child: AppButton(
          title: 'CREDIT',
          backgroundColor: const Color.fromRGBO(2, 117, 216, 1),
          onTap: () async => context.go('/credit'),
        ),
      ),
      AppButton(
        title: 'LOGOUT',
        backgroundColor: Colors.red,
        onTap: () async {
          context.read<CowProvider>().userLoggedOut();
          context.go('/login');
        },
      ),
    ];
  }

  // Contains a full list of Cow's Breed that you can buy on the market.
  List<Widget> cowMarketList(BuildContext context) {
    return [
      MarketCard(
          breed: CowBreed.jersey, onBuy: () async => await buyingCow(context, CowBreed.jersey)),
      MarketCard(
          breed: CowBreed.limousin, onBuy: () async => await buyingCow(context, CowBreed.limousin)),
      MarketCard(
          breed: CowBreed.hallikar, onBuy: () async => await buyingCow(context, CowBreed.hallikar)),
      MarketCard(
          breed: CowBreed.hereford, onBuy: () async => await buyingCow(context, CowBreed.hereford)),
      MarketCard(
          breed: CowBreed.holstein, onBuy: () async => await buyingCow(context, CowBreed.holstein)),
      MarketCard(
          breed: CowBreed.simmental,
          onBuy: () async => await buyingCow(context, CowBreed.simmental)),
    ];
  }

  // A set of function for calling buy_cow method on Cowchain Farm contract.
  Future<void> buyingCow(BuildContext context, CowBreed cowBreed) async {
    // Ask for Cow's Name.
    bool? isCowNameConfirmed = await DialogHelper.forCowName(context, controller);
    // Check to ensure Cow's name not empty.
    if (isCowNameConfirmed == null || !isCowNameConfirmed) {
      controller.clear();
      return;
    }

    // Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    // Cow buying process.
    String cowName = controller.text;
    String randomStr = Util.createCryptoRandomString(25);
    List<int> bytes = utf8.encode(accountID + cowName + randomStr);
    Digest digest = sha1.convert(bytes);
    String cowID = digest.toString();

    var (BuyCowResult result, String? error) = await CowContract.invokeBuyCow(
      accountID: accountID,
      cowName: cowName,
      cowID: cowID,
      cowBreed: cowBreed,
    );

    // Pop current dialog and wait 100ms before continue.
    if (context.mounted) {
      controller.clear();
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    // Call dialog if error exist.
    String? errorMessage = error;
    if (result.status != Status.ok) {
      // Check for specific error status returned from contract.
      if (result.status == Status.notInitialized) errorMessage = AppMessages.contractNotInitialized;
      if (result.status == Status.insufficientFund) errorMessage = AppMessages.insufficientFund;
    }
    if (errorMessage != null && context.mounted) {
      DialogHelper.failures(context, errorMessage);
      return;
    }

    // Update cow data and go to Farm.
    if (context.mounted) {
      context.read<CowProvider>().addCow(result.data);
      context.read<CowProvider>().updateOwnership(result.ownership);
      context.go('/farm');
    }
  }
}
