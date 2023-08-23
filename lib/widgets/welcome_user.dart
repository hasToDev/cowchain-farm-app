import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';

class WelcomeUser extends StatelessWidget {
  const WelcomeUser({
    super.key,
    required this.account,
  });

  final String account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: const Color.fromRGBO(112, 180, 89, 0.45)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(112, 180, 89, 0.5),
                      offset: Offset(0, 10),
                      blurRadius: 35,
                      spreadRadius: 0.5,
                    ),
                  ]),
              child: Text(
                'hi, $account',
                style: context.style.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
