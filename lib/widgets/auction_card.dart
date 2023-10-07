import 'package:cowchain_farm/core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

import 'app_button.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({
    super.key,
    required this.accountID,
    required this.data,
    required this.latestLedger,
    required this.onBid,
    required this.onClaim,
  });

  final String accountID;
  final AuctionData data;
  final int latestLedger;
  final VoidCallback onBid;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    String status = 'OPEN';

    int numLedgerToAuctionLimit = data.auctionLimitLedger - latestLedger;
    if (numLedgerToAuctionLimit < 0) {
      status = 'CLOSED';
      if (accountID == data.highestBidder.user.accountId && accountID != data.owner.accountId) {
        status = 'WON';
      }
      if (accountID != data.highestBidder.user.accountId && accountID == data.owner.accountId) {
        status = 'AUCTIONED';
      }
    }

    Color? textColor;
    if (status == 'CLOSED') textColor = const Color.fromRGBO(244, 67, 54, 1);
    if (status == 'WON' || status == 'AUCTIONED') {
      textColor = const Color.fromRGBO(112, 180, 89, 1);
    }

    Color cowBackgroundColor = const Color.fromRGBO(223, 238, 218, 0.7);
    if (accountID == data.owner.accountId) {
      cowBackgroundColor = const Color.fromRGBO(2, 117, 216, 0.125);
    }

    int bidNumber = 0;
    if (data.bidHistory.isNotEmpty) bidNumber = data.bidHistory.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(251, 253, 251, 1),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(112, 180, 89, 0.6),
            offset: Offset(0, 10),
            blurRadius: 30,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.9),
            offset: Offset(-6, -6),
            blurRadius: 14,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 600,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(251, 253, 251, 1),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Wrap(
              children: [
                Text(
                  data.name,
                  style: context.style.titleMedium?.copyWith(
                    color: Colors.green,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runAlignment: WrapAlignment.center,
              runSpacing: 20,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 60,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(251, 253, 251, 1),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          double padding = constraints.maxWidth * 0.05;
                          return Container(
                            height: constraints.maxWidth - padding,
                            width: constraints.maxWidth - padding,
                            decoration: BoxDecoration(
                              color: cowBackgroundColor,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                          );
                        },
                      ),
                      LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          double padding = constraints.maxWidth * 0.1;
                          return Padding(
                            padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
                            child: Image.asset(
                              data.breed.imageURL(),
                              height: constraints.maxWidth - padding,
                              width: constraints.maxWidth - padding,
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                              alignment: Alignment.topCenter,
                              filterQuality: FilterQuality.high,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(251, 253, 251, 1),
                  ),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      double padding = constraints.maxWidth * 0.15;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
                        child: Image.asset(
                          data.gender.imageURL(),
                          height: constraints.maxWidth - padding,
                          width: constraints.maxWidth - padding,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                          alignment: Alignment.topCenter,
                          filterQuality: FilterQuality.high,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Builder(builder: (context) {
                    int cowAge = latestLedger - data.bornLedger;
                    if (cowAge < 0) cowAge = 0;

                    DateTime age = DateTime.now().subtract(Duration(seconds: cowAge * 5));
                    String ageStr = GetTimeAgo.parse(age);
                    if (!ageStr.contains('ago')) {
                      Duration now = DateTime.now().difference(age);
                      ageStr = '${now.inDays} days';
                    }
                    ageStr = ageStr.replaceAll('ago', '').trim();

                    return Wrap(
                      children: [
                        SubInfoAuctionCard(
                          title: 'AGE',
                          value: ageStr,
                          maxWidth: 150,
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(
                  width: 100,
                  child: Wrap(
                    children: [
                      SubInfoAuctionCard(
                        title: 'CURRENT BID',
                        value: data.highestBidder.price,
                        maxWidth: 150,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Wrap(
                    children: [
                      SubInfoAuctionCard(
                        title: 'BID NUMBER',
                        value: bidNumber.toString(),
                        maxWidth: 150,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Builder(builder: (context) {
                    return Wrap(
                      children: [
                        SubInfoAuctionCard(
                          title: 'STATUS',
                          value: status,
                          maxWidth: 150,
                          textColor: textColor,
                        ),
                      ],
                    );
                  }),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Builder(builder: (context) {
                    String buttonTitle = 'Bid';
                    Color backgroundColor = const Color.fromRGBO(229, 57, 53, 1);

                    if (status == 'WON' || status == 'AUCTIONED') {
                      buttonTitle = 'Claim';
                      backgroundColor = const Color.fromRGBO(2, 117, 216, 1);
                    } else if (status == 'CLOSED') {
                      backgroundColor = const Color.fromRGBO(173, 167, 172, 0.7);
                    }

                    return AppButton(
                      title: buttonTitle,
                      smaller: true,
                      backgroundColor: backgroundColor,
                      onTap: () async {
                        if (status == 'CLOSED') return;
                        if (status == 'OPEN') {
                          onBid.call();
                        } else {
                          onClaim.call();
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubInfoAuctionCard extends StatelessWidget {
  const SubInfoAuctionCard({
    super.key,
    required this.title,
    required this.value,
    this.rightAlignment = false,
    required this.maxWidth,
    this.textColor,
  });

  final String title;
  final String value;
  final bool rightAlignment;
  final double maxWidth;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    bool shouldWrap = maxWidth < 210;
    return SizedBox(
      width: shouldWrap ? maxWidth : 100,
      child: Column(
        crossAxisAlignment: shouldWrap
            ? CrossAxisAlignment.center
            : rightAlignment
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.style.bodySmall?.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.style.labelMedium?.copyWith(
              color: textColor ?? const Color.fromRGBO(2, 117, 216, 0.7),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
