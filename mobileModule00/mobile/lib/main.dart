import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';
import 'package:mobilemodule00/file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 8, 0, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  String stringScreen = "";
  double result = 0;

  double _appbarHeight() {
    return (kToolbarHeight + MediaQuery.of(context).padding.top);
  }
  
  double evaluateMathExpression(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      return (exp.evaluate(EvaluationType.REAL, cm));
    } catch (e) {
      // print("Error evaluating expression: $e");
      return double.nan;
    }
  }

  void screenDisplay(String str) {
      setState(() {
        if (str == 'C') {
          if (stringScreen != "") {
            stringScreen = stringScreen.substring(0, stringScreen.length - 1); }}
        else if (str == 'AC') {
          stringScreen = ""; }
        else if (str == '=')
        {
          stringScreen = stringScreen.replaceAll('x', '*');
          result = evaluateMathExpression(stringScreen);
          stringScreen = "";
        }
        else {
          stringScreen = stringScreen + str; }
      });
      print("Button pressed $str");
  }

  @override
  Widget build(BuildContext context) {
    double appbarHeight = _appbarHeight();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 195, 212, 37),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            WidgetScreen(appbarHeight: appbarHeight, stringScreen: stringScreen, result: result),
            WidgetKeyboard(appbarHeight: appbarHeight, screenDisplay: screenDisplay),
          ],
        ),
      ),
    );
  }
}
