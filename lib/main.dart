import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  double firstNumber = 0;
  String operand = '';
  bool isNewNumber = true;

  String formatNumber(double number) {
    if (!number.isFinite) return 'Error';
    var s = number.toStringAsFixed(8).replaceFirst(RegExp(r'\.?0+$'), '');
    return (s == '-0' || s.isEmpty) ? '0' : s;
  }

  // Returns null on divide by zero
  double? calculate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return b == 0 ? null : a / b;
    }
    return b;
  }

  void showError() {
    display = 'Cannot divide by zero';
    firstNumber = 0;
    operand = '';
    isNewNumber = true;
  }

  void buttonPresses(String text) {
    setState(() {
      if (text == 'C') {
        display = '0';
        firstNumber = 0;
        operand = '';
        isNewNumber = true;
      } else if (['+', '-', '*', '/'].contains(text)) {
        final current = double.tryParse(display) ?? 0;

        // Chained operation: 5 + 3 + -> compute 8 first
        if (operand.isNotEmpty && !isNewNumber) {
          final result = calculate(firstNumber, current, operand);
          if (result == null) {
            showError();
            return;
          }
          firstNumber = result;
          display = formatNumber(result);
        } else {
          firstNumber = current;
        }

        operand = text;
        isNewNumber = true;
      } else if (text == '=') {
        if (operand.isEmpty) return;

        final second = double.tryParse(display) ?? 0;
        final result = calculate(firstNumber, second, operand);
        if (result == null) {
          showError();
          return;
        }

        display = formatNumber(result);
        firstNumber = result;
        operand = '';
        isNewNumber = true;
      } else if (text == '.') {
        if (isNewNumber) {
          display = '0.';
          isNewNumber = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
      } else {
        // Digit
        if (isNewNumber || display == '0') {
          display = text;
          isNewNumber = false;
        } else {
          display += text;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Calculator App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  display,
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                buildButton('7', Colors.grey),
                buildButton('8', Colors.grey),
                buildButton('9', Colors.grey),
                buildButton('/', Colors.orange),
              ],
            ),
            Row(
              children: [
                buildButton('4', Colors.grey),
                buildButton('5', Colors.grey),
                buildButton('6', Colors.grey),
                buildButton('*', Colors.orange),
              ],
            ),
            Row(
              children: [
                buildButton('1', Colors.grey),
                buildButton('2', Colors.grey),
                buildButton('3', Colors.grey),
                buildButton('-', Colors.orange),
              ],
            ),
            Row(
              children: [
                buildButton('C', Colors.red),
                buildButton('0', Colors.grey),
                buildButton('.', Colors.grey),
                buildButton('+', Colors.orange),
              ],
            ),
            Row(children: [buildButton('=', Colors.green)]),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => buttonPresses(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
