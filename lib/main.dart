import 'package:currency_converter/currency_converter_cupertino_page.dart';
import 'package:currency_converter/currency_converter_material_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:currency_converter/currency_converter_dropdown.dart';

void main() {
  runApp(const MyDropdown()); // General syntax for launching an app.
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

class MyMaterialPageApp
    extends
        StatelessWidget // Creation of main class
        {
  const MyMaterialPageApp({super.key}); // Basic constructor syntax
  @override
  Widget build(BuildContext context) // Overidng an abstract class
  {
    return const MaterialApp(
      home: CurrencyConverterMaterialPage(),
    ); // Global formatting options developed by google
  }
}

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(home: CurrencyConverterCupertinoPage(),
    );
  }
}

class MyDropdown extends StatelessWidget {
  const MyDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CurrencyConverterPage(),
    );
  }
}