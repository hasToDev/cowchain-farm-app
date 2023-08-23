import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';

class InfoMarketCard extends StatelessWidget {
  const InfoMarketCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            spacing: 10,
            runSpacing: 4,
            children: [
              Text(
                title,
                style: context.style.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                value,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.style.labelLarge?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
