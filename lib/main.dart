import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalculatorApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String displayText = '';

  void updateDisplay(String value) {
  if (value == '.' && displayText.contains('.')) {
    return;
  }
  setState(() {
    displayText += value;
  });
}

  void calculateResult() {
    try {
      final result = evaluateExpression(displayText);
      setState(() {
        displayText = result.toString();
      });
    } catch (e) {
      setState(() {
        displayText = e.toString() == 'Exception: Cannot Divide by Zero' ? 'Cannot Divide by Zero' : 'Error';
      });
    }
  }

  void clearDisplay() {
    setState(() {
      displayText = '';
    });
  }

  void backspace() {
    if (displayText.isNotEmpty) {
      setState(() {
        displayText = displayText.substring(0, displayText.length - 1);
      });
    }
  }

  double evaluateExpression(String expression) {
    RegExp regExp = RegExp(r'(\d+(\.\d*)?|\+|\-|\*|\/)');
    
    Iterable<Match> matches = regExp.allMatches(expression);

    List<String> parts = matches.map((match) => match.group(0)!).toList();

    double operand1 = double.parse(parts[0].trim());
    String operator = parts[1].trim();
    double operand2 = double.parse(parts[2].trim());

    switch (operator) {
      case '+':
        return operand1 + operand2;
      case '-':
        return operand1 - operand2;
      case '*':
        return operand1 * operand2;
      case '/':
        if (operand2 == 0) throw Exception('Cannot Divide by Zero');
        return operand1 / operand2;
      default:
        throw Exception('Invalid Operator');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  displayText,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('/'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('0'), _buildButton('.'), _buildButton('C'), _buildButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('='), _buildBackspaceButton(),
            ],
          ),
          SizedBox(height: 40,),
        ],
      ),
    );
  }

  Widget _buildButton(String label) {
    return InkWell(
      onTap: () {
        if (label == 'C') {
          clearDisplay();
        } else if (label == '=') {
          calculateResult();
        } else {
          updateDisplay(label);
        }
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Helper function for backspace button
  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: backspace,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.red[200],
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: Icon(
            Icons.backspace,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
