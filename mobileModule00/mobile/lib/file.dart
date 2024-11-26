import 'package:flutter/material.dart';
import 'package:mobilemodule00/keyboard.dart';

class WidgetScreen extends StatelessWidget {
  const WidgetScreen({super.key, required this.appbarHeight, required this.stringScreen, required this.result});
  final double appbarHeight;
  final String stringScreen;
  final double result;

  @override
  Widget build(BuildContext context) {    
    double _appbarHeight() {
      return kToolbarHeight + MediaQuery.of(context).padding.top;
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.height - appbarHeight) / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            Text (stringScreen),
            Text ('$result'),
        ],)
    );
  }
}



class WidgetKeyboard extends StatefulWidget {
  const WidgetKeyboard({super.key, required this.appbarHeight, required this.screenDisplay});
  final double appbarHeight;
  final Function(String) screenDisplay;
  
  @override
  State<WidgetKeyboard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WidgetKeyboard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.height - widget.appbarHeight) / 2,
      child: Container(
        color: const Color.fromARGB(255, 195, 212, 37),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(child: KeybardRow1(screenDisplay: widget.screenDisplay)),
            SizedBox(child: KeybardRow2(screenDisplay: widget.screenDisplay)),
            SizedBox(child: KeybardRow3(screenDisplay: widget.screenDisplay)),
            SizedBox(child: KeybardRow4(screenDisplay: widget.screenDisplay)),
          ]
        )
      ),
    );
  }
}
