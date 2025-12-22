import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyConverterCupertinoPage extends StatefulWidget {
  const CurrencyConverterCupertinoPage({super.key});

  @override
  State<CurrencyConverterCupertinoPage> createState() =>
      _CurrencyConverterCupertinoPageState();
}

class _CurrencyConverterCupertinoPageState
    extends State<CurrencyConverterCupertinoPage> {

  Future<double> fetchQarToInrRate() async {
    final url = Uri.parse(
      'https://v6.exchangerate-api.com/v6/8203a82a22d2a884ba5e94bb/latest/QAR',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['conversion_rates']['INR'];
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }

  String val = '0.00';
  final TextEditingController textEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 63, 0.628),

      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Currency Converter',
          style: TextStyle(
            fontSize: 22,
            color: CupertinoColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 98, 0, 0.9),
      ),

      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                '₹ $val',
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(222, 255, 255, 255),
                ),
              ),

              const SizedBox(height: 54),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CupertinoTextField(
                  controller: textEditingController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  placeholder: 'Please enter amount in QAR',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromRGBO(0, 110, 255, 1),
                      width: 2,
                    ),
                  ),
                  style: const TextStyle(color: CupertinoColors.black),
                ),
              ),

              const SizedBox(height: 24),

              CupertinoButton(
                color: const Color.fromRGBO(255, 98, 0, 0.9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                onPressed: () async {
                  final amount =
                      double.tryParse(textEditingController.text);
                  if (amount == null) return;

                  final rate = await fetchQarToInrRate();

                  setState(() {
                    val = (amount * rate).toStringAsFixed(2);
                  });
                },
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    fontSize: 22,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
