import 'package:flutter/material.dart';
import 'package:currency_converter/currency_converter.dart';

void main() {
  runApp(const MyApp()); // General syntax for launching an app.
}

// Types of widgets
// 1. Stateless Widget (immutable state)
// 2. Stateful Widget (mutable state)
// 3. Inherited Widget

// Widget Designs
// 1. Material Design (Google)
// 2. Cupertino Designs (Apple)

//Default Layout of color
// Color(0xAARRGGBB)
// 0xFF000000 = Black

//Button
// 1. Raised
// 2. Appears like a text

//Text Button
//Elevated Button

// int --> string integervalue.toString();
// String --> int.parse(Stringvalue);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CurrencyConverterPage(),
    );
  }
}