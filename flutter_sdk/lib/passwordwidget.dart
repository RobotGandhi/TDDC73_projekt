import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

ValueNotifier<int> strength = ValueNotifier<int>(0);

class PasswordStrengthWidget extends StatefulWidget {
  const PasswordStrengthWidget({super.key});

  @override
  State<PasswordStrengthWidget> createState() => _PasswordStrengthWidgetState();
}

class _PasswordStrengthWidgetState extends State<PasswordStrengthWidget> {
  final int weakLimit = 4;
  final int strongLimit = 8;

  Color getActiveColor() {
    if (strength.value < weakLimit) {
      return Colors.red;
    } else if (strength.value >= strongLimit) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: strength,
        builder: (context, value, child) {
          return (Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: 20, width: 50, color: getActiveColor()),
                  const SizedBox(width: 10),
                  Container(
                      height: 20,
                      width: 50,
                      color: strength.value >= weakLimit
                          ? getActiveColor()
                          : Colors.grey),
                  const SizedBox(width: 10),
                  Container(
                      height: 20,
                      width: 50,
                      color: strength.value >= strongLimit
                          ? getActiveColor()
                          : Colors.grey)
                ],
              )));
        });
  }
}

// PASSWORD STRENGTH CALCULATIONS
mixin PasswordStrength {
  void checkPasswordStrength(String password) async {
    strength.value = 0;

    strength.value += passwordLength(password);
    strength.value += passwordChars(password);
    strength.value += await commonPassword(password);
    log(strength.value.toString());
  }

  int passwordLength(String password) {
    if (password.length < 6) {
      return 0;
    } else if (password.length < 11) {
      return 3;
    }
    return 5;
  }

  int passwordChars(String password) {
    //add checks for reginal chars like åäö
    int count = -1;
    final small = RegExp(r'[a-z]');
    final capital = RegExp(r'[A-Z]');
    final numbers = RegExp(r'[0-9]');
    final special = RegExp(r'[.,*!"#¤%&/()=?`_\-¨^+<>|§½\\@£$[\]\p{L}]');

    if (small.hasMatch(password)) count++;
    if (capital.hasMatch(password)) count++;
    if (numbers.hasMatch(password)) count++;
    if (special.hasMatch(password)) count++;
    return count;
  }

  Future<int> commonPassword(String password) async {
    String data = await rootBundle.loadString("lib/assets/commonPasswords");
    Iterable<String> list = LineSplitter.split(data);
    int samePassword = 0;
    list.forEach((element) {
      if (element == password) {
        samePassword = 1;
      }
    });
    return -100 * samePassword;
  }

  //more things to check is it a common password, is a char repeating many times?
}
