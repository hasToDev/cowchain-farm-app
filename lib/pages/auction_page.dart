import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  late TextEditingController controller;
  String accountID = '';

  @override
  void initState() {
    super.initState();
    accountID = context.read<CowProvider>().accountID;
    controller = TextEditingController();
    fetchAuctionData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void fetchAuctionData() async {
    if (context.read<AuctionProvider>().auctionList.isEmpty ||
        context.read<AuctionProvider>().initialFetch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Show waiting dialog.
        if (context.mounted) DialogHelper.waiting(context);
      });

      await Future.delayed(const Duration(milliseconds: 250));
      if (context.mounted) await retrieveAuctionData(context);

      // Close waiting dialog.
      if (context.mounted) Navigator.pop(context);
    }
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
                                'Cowchain AUCTION',
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
                                  if (maxWidth >= 568) {
                                    leftPad = maxWidth - 568;
                                  } else if (maxWidth >= 340 && maxWidth < 568) {
                                    rightPad = maxWidth - 340;
                                  } else if (maxWidth >= 252 && maxWidth < 340) {
                                    rightPad = maxWidth - 252;
                                  } else if (maxWidth >= 146 && maxWidth < 252) {
                                    rightPad = maxWidth - 146;
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
                    Consumer<AuctionProvider>(
                      builder: (BuildContext context, auctions, Widget? child) {
                        if (auctions.auctionList.isEmpty) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                                    border: Border.all(
                                        color: const Color.fromRGBO(185, 102, 185, 0.45)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(185, 102, 185, 0.35),
                                        offset: Offset(0, 4),
                                        blurRadius: 25,
                                        spreadRadius: 0.25,
                                      ),
                                    ]),
                                child: Text(
                                  'There are no auctions taking place at this time.',
                                  style: context.style.titleMedium?.copyWith(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 14,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              _AuctionRefreshButton(
                                margin: const EdgeInsets.only(top: 24),
                                onTap: () async => await retrieveAuctionData(context),
                              ),
                            ],
                          );
                        }

                        int latestLedger = context.read<CowProvider>().sequence;

                        List<Widget> auctionList = auctions.auctionList.map((AuctionData data) {
                          return AuctionCard(
                            accountID: accountID,
                            data: data,
                            latestLedger: latestLedger,
                            onBid: () async => bidCow(context, data),
                            onClaim: () async => claimCow(context, data),
                          );
                        }).toList();

                        double padding = 0;
                        if (constraints.maxWidth >= 965) padding = (constraints.maxWidth - 965) / 2;

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Column(
                            children: [
                              _AuctionRefreshButton(
                                margin: const EdgeInsets.only(bottom: 24),
                                onTap: () async => await retrieveAuctionData(context),
                              ),
                              ...auctionList,
                            ],
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

  /// [bidCow]
  /// A set of function for calling bidding method on Cowchain Farm contract.
  Future<void> bidCow(BuildContext context, AuctionData data) async {
    // Ask for Bid price.
    bool? isPriceConfirmed = await DialogHelper.forAuctionRegisterOrBidding(
      context,
      controller,
      'What is your bidding price?',
    );

    // Check to ensure price not empty.
    if (isPriceConfirmed == null || !isPriceConfirmed) {
      controller.clear();
      return;
    }
    if (context.mounted && controller.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DialogHelper.failures(context, AppMessages.biddingPrice);
      });
      return;
    }

    // Check for zero bid price.
    int bidPrice = int.tryParse(controller.text) ?? 0;
    if (context.mounted && bidPrice <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.clear();
        DialogHelper.failures(context, AppMessages.zeroPrice);
      });
      return;
    }

    // Show waiting dialog.
    if (context.mounted) {
      controller.clear();
      DialogHelper.waiting(context);
    }

    var (AuctionResult bidding, String? errorBidding) = await CowContract.invokeBidding(
        accountID: accountID, auctionID: data.auctionId, bidPrice: bidPrice);

    // Pop current dialog and wait 100ms before continue.
    if (context.mounted) {
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Call dialog if error exist.
    String? errorMessage = errorBidding;
    if (errorMessage != null && context.mounted) {
      DialogHelper.failures(context, errorMessage);
      return;
    }

    // Update auction data.
    if (context.mounted) {
      context
          .read<AuctionProvider>()
          .updateAuctionDataList(bidding.auctionData.first, data.auctionId);

      DialogHelper.successes(context, 'Success placing your bids.');
    }
  }

  /// [claimCow]
  /// A set of function for calling finalize_auction method on Cowchain Farm contract.
  Future<void> claimCow(BuildContext context, AuctionData data) async {
    // Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    var (AuctionResult claim, String? errorClaim) =
        await CowContract.invokeFinalizeAuction(accountID: accountID, auctionID: data.auctionId);

    // Pop current dialog and wait 100ms before continue.
    if (context.mounted) {
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Call dialog if error exist.
    String? errorMessage = errorClaim;
    if (errorMessage != null && context.mounted) {
      DialogHelper.failures(context, errorMessage);
      return;
    }

    // Update auction data.
    if (context.mounted) {
      context.read<AuctionProvider>().removeAuctionData(claim.auctionData.first.auctionId);

      DialogHelper.successes(context, 'Success claiming your funds or cow.');
    }
  }

  /// [retrieveAuctionData]
  /// A set of function for calling get_all_auction method on Cowchain Farm contract.
  Future<void> retrieveAuctionData(BuildContext context) async {
    // Show waiting dialog.
    if (context.mounted) DialogHelper.waiting(context);

    var (AuctionResult retrieve, String? errorRetrieve) =
        await CowContract.invokeGetAllAuction(accountID: accountID);

    // Pop current dialog and wait 100ms before continue.
    if (context.mounted) {
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Call dialog if error exist.
    String? errorMessage = errorRetrieve;
    if (errorMessage != null && context.mounted) {
      DialogHelper.failures(context, errorMessage);
      return;
    }

    // Update auction data.
    if (context.mounted) {
      context.read<AuctionProvider>().setInitialFetchStatus();
      context.read<AuctionProvider>().setNewAuctionData(retrieve.auctionData);
    }
  }
}

class _AuctionRefreshButton extends StatelessWidget {
  const _AuctionRefreshButton({
    required this.onTap,
    this.margin,
  });

  final VoidCallback onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      margin: margin,
      child: AppGradientButton(
        title: 'refresh',
        smaller: true,
        elevation: 2,
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
        onTap: onTap,
      ),
    );
  }
}
