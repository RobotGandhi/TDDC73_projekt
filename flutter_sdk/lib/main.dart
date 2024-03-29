import 'package:flutter/material.dart';
import "passwordwidget.dart";
import 'carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with PasswordStrength {
  ValueNotifier<String> passwordUpdate = ValueNotifier("");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  checkPasswordStrength(value);
                  passwordUpdate.value = value;
                });
              },
            ),
            ValueListenableBuilder(
              valueListenable: passwordUpdate,
              builder: (context, value, child) {
                return (Column(
                  children: <Widget>[
                    PasswordStrengthWidget(),
                    CarouselWidget()
                  ],
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
