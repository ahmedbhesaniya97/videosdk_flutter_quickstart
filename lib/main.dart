import 'package:flutter/material.dart';
import 'package:videosdk_flutter_quickstart/join_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF5568fe),
        primarySwatch: const MaterialColor(0xFF5568fe, {
          50: Color.fromRGBO(85, 104, 254, .1),
          100: Color.fromRGBO(85, 104, 254, .2),
          200: Color.fromRGBO(85, 104, 254, .3),
          300: Color.fromRGBO(85, 104, 254, .4),
          400: Color.fromRGBO(85, 104, 254, .5),
          500: Color.fromRGBO(85, 104, 254, .6),
          600: Color.fromRGBO(85, 104, 254, .7),
          700: Color.fromRGBO(85, 104, 254, .8),
          800: Color.fromRGBO(85, 104, 254, .9),
          900: Color.fromRGBO(85, 104, 254, 1),
        }),
      ),
      home: JoinScreen(),
    );
  }
}
