import 'package:cowchain_farm/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color blueAccentShade800 = const Color.fromRGBO(68, 138, 255, 0.8);
Color blueAccentShade40 = const Color.fromRGBO(68, 138, 255, 0.04);
Color redAccentShade800 = const Color.fromRGBO(255, 82, 82, 0.8);

class DialogHelper {
  DialogHelper._();

  static Future<void> waiting(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 4,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        surfaceTintColor: Colors.white,
        content: Container(
          width: 300,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Image.asset(
                      'assets/emocow-hi.png',
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  AppMessages.pleaseWait,
                  style: context.style.bodyLarge?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: LinearProgressIndicator(
                  color: Color.fromRGBO(255, 123, 0, 1),
                  minHeight: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> failures(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 4,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        surfaceTintColor: Colors.white,
        content: Container(
          width: 300,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Image.asset(
                      'assets/emocow-sad.png',
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  message,
                  style: context.style.bodyLarge?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) return Colors.white;
                        return Colors.white70;
                      },
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) return Colors.blueAccent;
                        return blueAccentShade800;
                      },
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> forLogin(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 4,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Container(
          width: 550,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Image.asset(
                      'assets/emocow-happy.png',
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: RichText(
                  text: TextSpan(
                    text: 'The following account will be used for Cowchain Farm :\n\n',
                    children: <InlineSpan>[
                      TextSpan(
                        text: message,
                        style: context.style.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white;
                            return Colors.white70;
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.redAccent;
                            return redAccentShade800;
                          },
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No, I want to change my account'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white;
                            return Colors.white70;
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.blueAccent;
                            }
                            return blueAccentShade800;
                          },
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> forCowName(BuildContext context, TextEditingController controller) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 4,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Container(
          width: 350,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Image.asset(
                      'assets/emocow-happy.png',
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'What is the cow\'s name?',
                  style: context.style.bodyLarge?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  controller: controller,
                  cursorHeight: 20.0,
                  cursorColor: const Color.fromRGBO(112, 180, 89, 1),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color.fromRGBO(112, 180, 89, 1),
                        letterSpacing: 0.6,
                      ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    isDense: false,
                    contentPadding: const EdgeInsets.only(
                      top: 18.0,
                      bottom: 18.0,
                      left: 14.0,
                      right: 14.0,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Name',
                    labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: const Color.fromRGBO(112, 180, 89, 1),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                    errorStyle: const TextStyle(
                      height: 0.0,
                      fontSize: 0.0,
                      letterSpacing: 0.0,
                    ),
                    border: OutlineInputBorder(
                      gapPadding: 6.0,
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(112, 180, 89, 1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 6.0,
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(112, 180, 89, 1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 6.0,
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(112, 180, 89, 1),
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                    LengthLimitingTextInputFormatter(32),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white;
                            return Colors.white70;
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.redAccent;
                            return redAccentShade800;
                          },
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white;
                            return Colors.white70;
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.blueAccent;
                            }
                            return blueAccentShade800;
                          },
                        ),
                      ),
                      onPressed: () {
                        if (controller.text.isEmpty) {
                          Navigator.pop(context, false);
                          return;
                        }
                        Navigator.pop(context, true);
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> forAppraisal(
    BuildContext context,
    String cowName,
    String price,
  ) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 4,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Container(
          width: 350,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Image.asset(
                      'assets/emocow-happy.png',
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: RichText(
                  text: TextSpan(
                    text: 'The market wil buy ',
                    style: context.style.bodyLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.4,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: cowName,
                        style: context.style.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                      TextSpan(
                        text: ' for ',
                        style: context.style.bodyLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.4,
                        ),
                      ),
                      TextSpan(
                        text: '$price XLM.',
                        style: context.style.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                      TextSpan(
                        text: ' Do you want to continue?',
                        style: context.style.bodyLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white;
                            return Colors.white70;
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.redAccent;
                            return redAccentShade800;
                          },
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white;
                            return Colors.white70;
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.blueAccent;
                            }
                            return blueAccentShade800;
                          },
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> forRegisterNotification(
      BuildContext context, TextEditingController controller) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 4,
          buttonPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Container(
            width: 350,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Image.asset(
                        'assets/emocow-happy.png',
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.high,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'What is your Public Key for Cowchain Farm?',
                    style: context.style.bodyLarge?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: controller,
                    cursorHeight: 20.0,
                    cursorColor: const Color.fromRGBO(112, 180, 89, 1),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color.fromRGBO(112, 180, 89, 1),
                          letterSpacing: 0.6,
                        ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: const EdgeInsets.only(
                        top: 18.0,
                        bottom: 18.0,
                        left: 14.0,
                        right: 14.0,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Stellar Public Key / Account ID',
                      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: const Color.fromRGBO(112, 180, 89, 1),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                      errorStyle: const TextStyle(
                        height: 0.0,
                        fontSize: 0.0,
                        letterSpacing: 0.0,
                      ),
                      border: OutlineInputBorder(
                        gapPadding: 6.0,
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(112, 180, 89, 1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 6.0,
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(112, 180, 89, 1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        gapPadding: 6.0,
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(112, 180, 89, 1),
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[A-Z0-9]")),
                      LengthLimitingTextInputFormatter(56),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) return Colors.white;
                              return Colors.white70;
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) return Colors.redAccent;
                              return redAccentShade800;
                            },
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) return Colors.white;
                              return Colors.white70;
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.blueAccent;
                              }
                              return blueAccentShade800;
                            },
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<bool?> logoutConfirmation(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 4,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Container(
          width: 550,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Image.asset(
                      'assets/emocow-sad.png',
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: RichText(
                  text: TextSpan(
                    text:
                        'After logout, you will not receive notifications for the following accounts :\n\n',
                    style: context.style.titleSmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.4,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: message,
                        style: context.style.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white;
                            return Colors.white70;
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.redAccent;
                            return redAccentShade800;
                          },
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white;
                            return Colors.white70;
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.blueAccent;
                            }
                            return blueAccentShade800;
                          },
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> forAuctionRegisterOrBidding(
    BuildContext context,
    TextEditingController controller,
    String title,
  ) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 4,
          buttonPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Container(
            width: 350,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Image.asset(
                        'assets/emocow-happy.png',
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.high,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    title,
                    style: context.style.bodyLarge?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: controller,
                    cursorHeight: 20.0,
                    cursorColor: const Color.fromRGBO(112, 180, 89, 1),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color.fromRGBO(112, 180, 89, 1),
                          letterSpacing: 0.6,
                        ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: const EdgeInsets.only(
                        top: 18.0,
                        bottom: 18.0,
                        left: 14.0,
                        right: 14.0,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Price in XLM',
                      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: const Color.fromRGBO(112, 180, 89, 1),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                      errorStyle: const TextStyle(
                        height: 0.0,
                        fontSize: 0.0,
                        letterSpacing: 0.0,
                      ),
                      border: OutlineInputBorder(
                        gapPadding: 6.0,
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(112, 180, 89, 1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 6.0,
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(112, 180, 89, 1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        gapPadding: 6.0,
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(112, 180, 89, 1),
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(9),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) return Colors.white;
                              return Colors.white70;
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) return Colors.redAccent;
                              return redAccentShade800;
                            },
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) return Colors.white;
                              return Colors.white70;
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.blueAccent;
                              }
                              return blueAccentShade800;
                            },
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> successes(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 4,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        surfaceTintColor: Colors.white,
        content: Container(
          width: 300,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Image.asset(
                      'assets/emocow-happy.png',
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  message,
                  style: context.style.bodyLarge?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) return Colors.white;
                        return Colors.white70;
                      },
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) return Colors.blueAccent;
                        return blueAccentShade800;
                      },
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
