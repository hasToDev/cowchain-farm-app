import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.bigger = false,
    this.smaller = false,
    this.backgroundColor,
  }) : super(key: key);

  final String title;
  final bool bigger;
  final bool smaller;
  final VoidCallback onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          backgroundColor ?? Theme.of(context).colorScheme.primary,
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(70, 10),
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(
          title,
          style: bigger
              ? context.style.bodyLarge?.copyWith(color: Colors.white)
              : smaller
                  ? context.style.bodySmall?.copyWith(color: Colors.white)
                  : context.style.bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
