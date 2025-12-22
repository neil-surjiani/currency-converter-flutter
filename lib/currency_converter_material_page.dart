import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyConverterMaterialPage extends StatefulWidget {  // An immutable widget which allows you to create state and form widget 
  const CurrencyConverterMaterialPage({super.key});    // 

  @override
  State<CurrencyConverterMaterialPage> createState() { // creation of state
    return _CurrencyConverterMaterialPageState();
  }
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> { // a class where values can be changed
  
  Future<double> fetchQarToInrRate() async {  // A class created, "Future" to make dart know taht there will be a response in future 
  final url = Uri.parse(                      // Async to make the dart wait as internet processing is slow
    'https://v6.exchangerate-api.com/v6/8203a82a22d2a884ba5e94bb/latest/QAR',   // Fetch real time rates using api
  );

  final response = await http.get(url);    // await is to make the dart compiler wait 

  if (response.statusCode == 200) {           // 200 is standard value meaning that json is extracted successfully
    final data = jsonDecode(response.body);  
    return data['conversion_rates']['INR'];   // a json contains data of conversion from QAR to all rates from this we need to extract data for inr to usd
  } else {
    throw Exception('Failed to load exchange rate'); // error handeling 
  }
}


  String val = '0.00';  // Innitial value of result
  final TextEditingController textEditingController = TextEditingController(); // Creatin of text editing controller class
  @override
  Widget build(BuildContext context) { 
    return Scaffold(  
      appBar: AppBar(  // Creation of header and formatting of it
        backgroundColor: Color.fromRGBO(255, 98, 0, 0), // Color of header
        title: Text(
          'Convex - Currency Converter',  // App title on header
          style: TextStyle(
            color: Colors.white, 
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(0, 0, 63, 0.628), // Changing the Bg color
      body: Center(
        //Centre align text horizontally
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center align Vertically
          children: // A list to change more than one properties
          [
            Text(
              '₹ $val',
              style:
                  TextStyle // Text Formatting
                  (
                    fontSize: 38, // Fontsize
                    fontWeight: FontWeight.w600, //Thickness
                    color: Color.fromARGB(222, 255, 255, 255), //Color
                  ),
            ),
            Padding // Elimination of a few pixels from the side of text field /// Container can also be used
            (
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 54.0,
              ), // Spacing from the ends of container /// Margin refers to spaces outside the container
              child:
                  TextField
                  /// Creation of input dialogue
                  (
                    controller: textEditingController,
                    style:
                        TextStyle // Input dialogue and formatting
                        (color: Color.fromRGBO(0, 0, 0, 1)),
                    decoration: InputDecoration(
                      hintText:'Please enter amount in QAR', //Preview of the label
                      hintStyle:
                          TextStyle // Formatting of field label
                          (
                            color: Color.fromRGBO(131, 131, 131, 1),
                            fontSize: 17,
                          ),
                      prefixIcon: Icon(  Icons.monetization_on_outlined), // Addition of icons
                      prefixIconColor: Color.fromRGBO(131, 131, 131, 1),  // Color of icon
                      suffixIcon: Icon(Icons.monetization_on_outlined),
                      suffixIconColor: Color.fromRGBO(131, 131, 131, 1),
                      filled: true,
                      fillColor: Colors.white, // Color of dialogue box
                      focusedBorder:
                          OutlineInputBorder // Border of dialogue box
                          (
                            borderSide: BorderSide(
                              color: Color.fromRGBO(0,110,255,1), // Color of border
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // Radius of corners of border
                          ),
                      enabledBorder:
                          OutlineInputBorder //Enabling border preview b4 clicking
                          (
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // Radius.....
                          ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal:true, // User keyboard shows only numbers with decimals
                    ),
                  ),
            ),
            ElevatedButton(
              onPressed: () async {  // Tells the compiler to waith longer 
                final amount = double.tryParse(textEditingController.text); // conversion from string to double try is used because if data is not string app crashes 
                if (amount == null) return;    // if vaule of amt is null exits fn so that app does not crash
                final rate = await fetchQarToInrRate(); //fetches rate from above fn 
                setState(() {
                  val = (amount * rate).toStringAsFixed(2); // calculations and max 2 decimal places
                  });
                },
              style: TextButton.styleFrom(
                // Fromatting of button
                elevation: (0),
                backgroundColor: (Color.fromRGBO(255, 98, 0, 0.838)), // Color
                padding: (EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                )), // Padding
                minimumSize: (Size(142, 59)), // Size
              ),
              child: const Text(
                // Text
                'Convert',
                style: TextStyle(
                  // Text Formatting
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 22,
                ),
              ),
            ),
          ], // Children
        ),
      ),
    );
  } // Override Widget
} // Class currency_converter
