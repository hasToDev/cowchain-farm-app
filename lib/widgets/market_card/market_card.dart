import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';

import 'info_market_card.dart';

class MarketCard extends StatelessWidget {
  const MarketCard({
    super.key,
    required this.breed,
    required this.onBuy,
  });

  final CowBreed breed;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(251, 253, 251, 1),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(187, 187, 187, 0.7),
            offset: Offset(0, 10),
            blurRadius: 30,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.9),
            offset: Offset(-6, -6),
            blurRadius: 14,
            spreadRadius: 2,
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
                        breed.imageURL(),
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoMarketCard(
                  title: 'Breed',
                  value: breed.name(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InfoMarketCard(
                    title: 'Price',
                    value: breed.price(),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: AppButton(
                    title: 'Buy',
                    smaller: true,
                    backgroundColor: const Color.fromRGBO(112, 180, 89, 1),
                    onTap: onBuy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
