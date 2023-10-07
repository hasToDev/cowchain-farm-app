import 'package:cowchain_farm/helpers/html_stub_helper.dart' if (dart.library.html) 'dart:html'
    as html;

import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
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
                                'Cowchain CREDIT',
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
                                  if (maxWidth >= 540) {
                                    leftPad = maxWidth - 540;
                                  } else if (maxWidth >= 332 && maxWidth < 540) {
                                    rightPad = maxWidth - 332;
                                  } else if (maxWidth >= 192 && maxWidth < 332) {
                                    rightPad = maxWidth - 192;
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
                    Wrap(
                      children: [
                        Text(
                          'You can find all of the image assets on this web in the following Freepik URLs:',
                          style: context.style.titleMedium?.copyWith(
                            color: const Color.fromRGBO(30, 97, 198, 1),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    creditLink(
                      'Cows different colors Image by macrovector',
                      'https://www.freepik.com/free-vector/cows-different-colors-white-background-spotted-cow-illustration_13031435.htm',
                    ),
                    creditLink(
                      'Hand-drawn cartoon Image by pikisuperstar',
                      'https://www.freepik.com/free-vector/hand-drawn-cartoon-cow-illustration_41099090.htm',
                    ),
                    creditLink(
                      'Animal emotes Image by Freepik',
                      'https://www.freepik.com/free-vector/hand-drawn-animal-emotes-collection_36163775.htm',
                    ),
                    creditLink(
                      'Cow logo Image by Freepik',
                      'https://www.freepik.com/free-vector/hand-drawn-cow-logo-design_29679258.htm',
                    ),
                    creditLink(
                      'Gender logo Image by Freepik',
                      'https://www.freepik.com/free-vector/flat-pride-month-lgbt-symbols-collection_25967237.htm',
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

  // Contains list of Navigation button for credit page.
  List<Widget> barActionButtons(BuildContext context) {
    return [
      Container(
        width: 146,
        padding: const EdgeInsets.only(right: 24),
        child: AppGradientButton(
          title: 'back to FARM',
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
      SizedBox(
        width: 146,
        child: AppGradientButton(
          title: 'back to MARKET',
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
          onTap: () async {
            context.go('/market');
          },
        ),
      ),
    ];
  }

  Widget creditLink(String title, String link) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            html.window.open(link, 'new tab');
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                title,
                style: context.style.bodyMedium?.copyWith(
                  color: Colors.deepOrange.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
