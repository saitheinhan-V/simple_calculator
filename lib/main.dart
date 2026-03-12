import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '';
  double? _firstOperand;
  String? _operator;
  bool _shouldClear = false;

  void _onPressed(String value) {
    setState(() {
      if ('0123456789.'.contains(value)) {
        if (_shouldClear) {
          _display = '';
          _shouldClear = false;
        }
        // Prevent multiple decimals
        if (value == '.' && _display.contains('.')) return;
        _display += value;
      } else if ('+-×÷'.contains(value)) {
        if (_display.isNotEmpty) {
          _firstOperand = double.tryParse(_display);
          _operator = value;
          _shouldClear = true;
        }
      } else if (value == '=') {
        if (_display.isNotEmpty && _firstOperand != null && _operator != null) {
          double secondOperand = double.tryParse(_display) ?? 0;
          double result = 0;
          switch (_operator) {
            case '+':
              result = _firstOperand! + secondOperand;
              break;
            case '-':
              result = _firstOperand! - secondOperand;
              break;
            case '×':
              result = _firstOperand! * secondOperand;
              break;
            case '÷':
              result = secondOperand != 0
                  ? _firstOperand! / secondOperand
                  : double.nan;
              break;
          }
          _display = result.toString();
          _firstOperand = null;
          _operator = null;
          _shouldClear = true;
        }
      } else if (value == 'C') {
        _display = '';
        _firstOperand = null;
        _operator = null;
        _shouldClear = false;
      }
    });
  }

  Widget _buildButton(String label, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.blue,
          ),
          child: Text(label, style: TextStyle(fontSize: 26)),
          onPressed: () => _onPressed(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Text(
                _display,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('÷', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('×', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('0'),
                  _buildButton('.'),
                  _buildButton('C', color: Colors.red),
                  _buildButton('+', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('=', style: TextStyle(fontSize: 26)),
                        onPressed: () => _onPressed('='),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
