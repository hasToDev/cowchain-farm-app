import 'dart:html' as html;

import 'package:cowchain_farm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  late TextEditingController controller;
  String accountID = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    accountID = context.read<CowProvider>().accountID;
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
                                  if (maxWidth >= 534) {
                                    leftPad = maxWidth - 534;
                                  } else if (maxWidth >= 326 && maxWidth < 534) {
                                    rightPad = maxWidth - 326;
                                  } else if (maxWidth >= 186 && maxWidth < 326) {
                                    rightPad = maxWidth - 186;
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
      Padding(
        padding: const EdgeInsets.only(right: 24),
        child: AppButton(
          title: 'back to FARM',
          backgroundColor: const Color.fromRGBO(255, 123, 0, 1),
          onTap: () async {
            context.go('/farm');
          },
        ),
      ),
      AppButton(
        title: 'back to MARKET',
        backgroundColor: const Color.fromRGBO(2, 117, 216, 1),
        onTap: () async {
          context.go('/market');
        },
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
