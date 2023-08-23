import 'package:cowchain_farm/core/core.dart';
import 'package:flutter/material.dart';

class SubInfoCowCard extends StatelessWidget {
  const SubInfoCowCard({
    super.key,
    required this.title,
    required this.value,
    this.rightAlignment = false,
    required this.maxWidth,
  });

  final String title;
  final String value;
  final bool rightAlignment;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    bool shouldWrap = maxWidth < 210;
    return Container(
      width: shouldWrap ? maxWidth : 100,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey.shade300),
      ),
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
            ),
          ),
          const SizedBox(height: 1.5),
          Text(
            value,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.style.labelMedium?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
