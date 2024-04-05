import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CurrencyConverterCupertinoPage extends StatefulWidget {
  const CurrencyConverterCupertinoPage({super.key});

  @override
  State<CurrencyConverterCupertinoPage> createState() =>
      _CurrencyConverterCupertinoPageState();
}

class _CurrencyConverterCupertinoPageState
    extends State<CurrencyConverterCupertinoPage> {
  TextEditingController textEditingController = TextEditingController();
  double result = 0;

  void convert() {
    if (textEditingController.text.isNotEmpty) {
      setState(() {
        result = double.parse(textEditingController.text) * 81;
      });
    } else {
      // CupertinoPageScaffold.of(context).showSnackBar(
      //   const SnackBar(
      //     duration: Duration(seconds: 1),
      //     content: Text("Please enter a value to convert to INR."),
      //   ),
      // );
    }
    if (kDebugMode) {
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey3,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "Currency Converter",
          style: TextStyle(color: CupertinoColors.white, fontSize: 30),
        ),
        backgroundColor: CupertinoColors.systemGrey3,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "INR: ${result == 0 ? result.toStringAsFixed(0) : result.toStringAsFixed(2)}", // allows us to display only two digits after decimal point
                style: const TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              CupertinoTextField(
                style: const TextStyle(color: CupertinoColors.black),
                controller: textEditingController,
                placeholder: "Please enter the amount in USD",
                prefix: Icon(CupertinoIcons.money_dollar),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                  color: CupertinoColors.white,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                onPressed: () => convert,
                color: CupertinoColors.black,
                child: const Text("Convert"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
