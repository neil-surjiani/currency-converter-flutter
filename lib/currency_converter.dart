import 'dart:convert'; // Used to decode JSON responses coming from the API
import 'package:flutter/material.dart'; // Core Flutter UI framework
import 'package:http/http.dart' as http; // HTTP package to make API calls
import 'package:flutter_dotenv/flutter_dotenv.dart';

// =======================
// MAIN PAGE WIDGET
// =======================
class CurrencyConverterPage extends StatefulWidget {
  // StatefulWidget is used because values like currency, amount, and result
  // will change during runtime based on user interaction

  const CurrencyConverterPage({super.key}); // Constructor with optional key

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
  // Links this widget to its mutable state class
}

// =======================
// STATE CLASS
// =======================
class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  // This class holds all mutable data (state) and UI logic

// =======================
// A class which converts values on pressed
// =======================

  Future<void> convert() async {
    // Convert input text to double
    final amount = double.tryParse(controller.text);

    // If input is invalid, do nothing
    if (amount == null) return;

    // Fetch exchange rate
    final rate = await fetchExchangeRate(fromCurrency, toCurrency);

    // Update UI with converted value
    setState(() {
      result = (amount * rate).toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCurrencies(from: fromCurrency, to: toCurrency);
  }

  // =======================
  // CURRENCY DATA
  // =======================

  // List of supported currency codes used in dropdowns
  List<String> currencies = [];

  // Default source currency
  String fromCurrency = 'USD';

  // Default target currency
  String toCurrency = 'INR';

  // Stores the converted amount displayed on screen
  String result = '0.00';

  // Controller to read user input from the TextField
  final TextEditingController controller = TextEditingController();

  // =======================
  // CURRENCY LIST CALL LOGIC
  // =======================

  Future<void> fetchCurrencies({
    required String from,
    required String to,
  }) async {
    String myKey = dotenv.env['API_KEY'] ?? '';
    final url = Uri.parse(
      'https://v6.exchangerate-api.com/v6/$myKey/latest/$from',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ✅ Extract currencies from API
      final rates = data['conversion_rates'] as Map<String, dynamic>;

      setState(() {
        currencies = rates.keys.toList()..sort();
      });
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  // =======================
  // API CALL LOGIC
  // =======================

  // Fetches exchange rate from `from` currency to `to` currency
  Future<double> fetchExchangeRate(String from, String to) async {
    // API endpoint URL with base currency as `from`
    String myKey = dotenv.env['API_KEY'] ?? 'Key not found';
    final url = Uri.parse(
      'https://v6.exchangerate-api.com/v6/$myKey/latest/$from',
    );

    // Make GET request to the API
    final response = await http.get(url);

    // If both currencies are same, conversion rate is 1
    if (from == to) {
      return 1;
    }

    // Check if API call was successful
    if (response.statusCode == 200 && from != to) {
      // Decode JSON response into Dart map
      final data = jsonDecode(response.body);

      // Extract conversion rate for target currency
      return data['conversion_rates'][to];
    } else {
      // Throw exception if API fails
      throw Exception('Failed to load exchange rate');
    }
  }

  // =======================
  // DROPDOWN WIDGET
  // =======================

  // Reusable dropdown widget for currency selection
  Widget currencyDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value, // Currently selected currency
      // Style of selected value
      style: const TextStyle(color: Colors.white),

      // Custom widget for selected item display
      selectedItemBuilder: (BuildContext context) {
        return currencies.map<Widget>((String item) {
          return Text(item, style: const TextStyle(color: Colors.white));
        }).toList();
      },

      // Dropdown list items
      items: currencies.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(
            currency,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),

      // Triggered when user selects a new currency
      onChanged: onChanged,

      // Dropdown field decoration
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(243, 176, 28, 1)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // =======================
  // UI BUILD METHOD
  // =======================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color of the entire screen
      backgroundColor: const Color.fromRGBO(10, 25, 47, 1),

      // Top AppBar
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 25, 47, 1.0),
        title: const Text(
          'Currency Converter',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
      ),

      // Main body content
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =======================
            // RESULT DISPLAY
            // =======================
            Text(
              result, // Converted value
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // =======================
            // INPUT FIELD
            // =======================
            TextField(
              controller: controller, // Controls text input
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Please enter amount in $fromCurrency',
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(131, 131, 131, 1),
                  fontSize: 17,
                ),
                prefixIcon: const Icon(Icons.monetization_on_outlined),
                prefixIconColor: const Color.fromRGBO(131, 131, 131, 1),
                suffixIcon: const Icon(Icons.monetization_on_outlined),
                suffixIconColor: const Color.fromRGBO(131, 131, 131, 1),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(243, 176, 28, 1),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(height: 24),

            // =======================
            // FROM & TO
            // =======================

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18, right: 20),
                    child: Text(
                      "From",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                ),
 
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18, left: 20),
                    child: Text(
                      "To",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            // =======================
            // CURRENCY SELECTION ROW
            // =======================
            Row(
              children: [
                Expanded(
                  child: currencyDropdown(
                    value: fromCurrency,
                    onChanged: (value) {
                      setState(() {
                        fromCurrency = value!;
                      });
                    },
                  ),
                ),

            // =======================
            // REVERSE BUTTON
            // =======================

                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(10, 25, 47, 1),
                  ),
                  onPressed: () async {
                    setState(() {
                      String temp = "";
                      temp = fromCurrency;
                      fromCurrency = toCurrency;
                      toCurrency = temp;
                      convert();
                    });
                  },
                  child: Icon(Icons.swap_horiz, color: Colors.white),
                ),

                Expanded(
                  child: currencyDropdown(
                    value: toCurrency,
                    onChanged: (value) {
                      setState(() {
                        toCurrency = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // =======================
            // CONVERT BUTTON
            // =======================
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 98, 0, 1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              onPressed: () async {
                convert();
              },
              child: const Text(
                'Convert',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
