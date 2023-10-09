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
  void dispose() {
    controller.dispose();
    super.dispose();
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
                                  if (maxWidth >= 684) {
                                    leftPad = maxWidth - 684;
                                  } else if (maxWidth >= 460 && maxWidth < 684) {
                                    rightPad = maxWidth - 460;
                                  } else if (maxWidth >= 372 && maxWidth < 460) {
                                    rightPad = maxWidth - 372;
                                  } else if (maxWidth >= 266 && maxWidth < 372) {
                                    rightPad = maxWidth - 266;
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: leftPad,
                                      right: rightPad,
                                    ),
                                    child: Wrap(
                                      alignment: maxWidth < 372
                                          ? WrapAlignment.start
                                          : WrapAlignment.spaceBetween,
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
      Container(
        width: 106,
        padding: const EdgeInsets.only(right: 24),
        child: AppGradientButton(
          title: 'FARM',
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
            context.go('/farm');
          },
        ),
      ),
      Container(
        width: 120,
        padding: const EdgeInsets.only(right: 24),
        child: AppGradientButton(
          title: 'AUCTION',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: [
              Color.fromRGBO(185, 102, 185, 1),
              Color.fromRGBO(139, 0, 139, 1),
              Color.fromRGBO(139, 0, 139, 1),
              Color.fromRGBO(139, 0, 139, 1),
              Color.fromRGBO(185, 102, 185, 1),
            ],
          ),
          onTap: () async => context.go('/auction'),
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
    if (errorMessage != null && context.mounted) {
      DialogHelper.failures(context, errorMessage);
      return;
    }

    // Update cow data and go to Farm.
    if (context.mounted) {
      context.read<CowProvider>().addCow(result.data.first);
      context.read<CowProvider>().updateOwnership(result.ownership);
      context.go('/farm');
    }
  }
}
