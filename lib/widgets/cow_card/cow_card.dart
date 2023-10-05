import 'package:cowchain_farm/core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';

import 'cow_action_buttons.dart';
import 'hunger_meter.dart';
import 'sub_info_cow_card.dart';

const int cowLifeTimeWithoutFeed = 17280;

class CowCard extends StatelessWidget {
  const CowCard({
    super.key,
    required this.data,
    required this.onSell,
    required this.onFeed,
  });

  final CowData data;
  final VoidCallback onSell;
  final VoidCallback onFeed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Container(
            width: 300,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(251, 253, 251, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double padding = constraints.maxWidth * 0.15;
                    return Container(
                      height: constraints.maxWidth - padding,
                      width: constraints.maxWidth - padding,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(223, 238, 218, 0.7),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double padding = constraints.maxWidth * 0.45;
                    return Container(
                      height: constraints.maxWidth - padding,
                      width: constraints.maxWidth - padding,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(191, 222, 181, 0.9),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double padding = constraints.maxWidth * 0.15;
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
            width: 300,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(251, 253, 251, 1),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text(
                      data.name,
                      style: context.style.titleMedium?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Wrap(
                  children: [
                    Text(
                      data.id,
                      style: context.style.labelSmall?.copyWith(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.spaceBetween,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SubInfoCowCard(
                              title: 'Breed',
                              value: data.breed.name(),
                              maxWidth: constraints.maxWidth,
                            ),
                            Selector<CowProvider, int>(
                                selector: (context, cowProvider) => cowProvider.sequence,
                                builder: (BuildContext context, int sequence, Widget? child) {
                                  int ledgerElapsed = sequence - data.lastFedLedger;
                                  bool die = (ledgerElapsed / cowLifeTimeWithoutFeed) > 1.0;
                                  int cowAge = sequence - data.bornLedger;
                                  if (cowAge < 0) cowAge = 0;

                                  DateTime age =
                                      DateTime.now().subtract(Duration(seconds: cowAge * 5));
                                  String ageStr = GetTimeAgo.parse(age);
                                  if (!ageStr.contains('ago')) {
                                    Duration now = DateTime.now().difference(age);
                                    ageStr = '${now.inDays} days';
                                  }
                                  ageStr = ageStr.replaceAll('ago', '').trim();
                                  return SubInfoCowCard(
                                    title: 'Age',
                                    value: die ? '-' : ageStr,
                                    rightAlignment: true,
                                    maxWidth: constraints.maxWidth,
                                  );
                                }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Selector<CowProvider, int>(
                  selector: (context, cowProvider) => cowProvider.sequence,
                  builder: (BuildContext context, int sequence, Widget? child) {
                    return HungerMeter(
                      currentLedger: sequence,
                      lastFedLedger: data.lastFedLedger,
                      cowsLedgerLimitSinceLastFed: cowLifeTimeWithoutFeed,
                    );
                  },
                ),
                CowActionButtons(
                  onSell: onSell,
                  onFeed: onFeed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
