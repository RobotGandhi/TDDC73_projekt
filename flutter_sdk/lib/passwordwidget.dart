import 'dart:developer';

import 'package:flutter/material.dart';

ValueNotifier<int> strength = ValueNotifier<int>(0);

class PasswordStrengthWidget extends StatefulWidget {
  const PasswordStrengthWidget({super.key});

  @override
  State<PasswordStrengthWidget> createState() => _PasswordStrengthWidgetState();
}

class _PasswordStrengthWidgetState extends State<PasswordStrengthWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: strength,
        builder: (context, value, child) {
          return (Container(
            color: Colors.red,
            width: 20,
            height: 20,
            child: Text(strength.value.toString()),
          ));
        });
  }
}

// PASSWORD STRENGTH CALCULATIONS
mixin PasswordStrength {
  void checkPasswordStrength(String password) {
    strength.value = 0;

    strength.value += passwordLength(password);
    strength.value += passwordChars(password);
    //strength += funciton3(password);
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

  //more things to check is it a common password, is a char repeating many times?
}
