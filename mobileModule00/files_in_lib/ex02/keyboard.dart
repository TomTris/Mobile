import 'package:flutter/material.dart';

class KeybardRow1 extends StatefulWidget {
  const KeybardRow1({super.key, required this.screenDisplay});

  final Function (String) screenDisplay;

  @override
  State<KeybardRow1> createState() => _KeybardRow1State();
}

class _KeybardRow1State extends State<KeybardRow1> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: FloatingActionButton(
              onPressed: () => widget.screenDisplay('7'),
              tooltip: '7',
              backgroundColor:  const Color.fromARGB(0, 0, 0, 0),
              elevation: 0,
              child: const Text('7'),
            ),
          ),
        ),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('8'),tooltip: '8',label: const Text('8'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('9'),tooltip: '9',label: const Text('9'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton(onPressed: () => widget.screenDisplay('C'),tooltip: 'C',backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,child: const Text('C',style: TextStyle(color: Colors.red,), ),),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton(onPressed: () => widget.screenDisplay('AC'),tooltip: 'AC',backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,child: const Text('AC',style: TextStyle(color: Colors.red,), ),),),),
    ],
    );
  }
}

class KeybardRow2 extends StatefulWidget {
  const KeybardRow2({super.key, required this.screenDisplay});

  final Function (String) screenDisplay;

  @override
  State<KeybardRow2> createState() => _KeybardRow2State();
}

class _KeybardRow2State extends State<KeybardRow2> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('4'),tooltip: '4',label: const Text('4'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('5'),tooltip: '5',label: const Text('5'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('6'),tooltip: '6',label: const Text('6'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton(onPressed: () => widget.screenDisplay('+'),tooltip: '+',backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,child: const Text('+',style: TextStyle(color: Colors.white,), ),),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton(onPressed: () => widget.screenDisplay('-'),tooltip: '-',backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,child: const Text('-',style: TextStyle(color: Colors.white,), ),),),),
      ],
    );
  }
}
class KeybardRow3 extends StatefulWidget {
  const KeybardRow3({super.key, required this.screenDisplay});

  final Function (String) screenDisplay;

  @override
  State<KeybardRow3> createState() => _KeybardRow3State();
}

class _KeybardRow3State extends State<KeybardRow3> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('1'),tooltip: '1',label: const Text('1'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('2'),tooltip: '2',label: const Text('2'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('3'),tooltip: '3',label: const Text('3'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton(onPressed: () => widget.screenDisplay('x'),tooltip: 'x',backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,child: const Text('x',style: TextStyle(color: Colors.white,), ),),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton(onPressed: () => widget.screenDisplay('/'),tooltip: '/',backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,child: const Text('/',style: TextStyle(color: Colors.white,), ),),),),
      ],
    );
  }
}

class KeybardRow4 extends StatefulWidget {
  const KeybardRow4({super.key, required this.screenDisplay});

  final Function (String) screenDisplay;

  @override
  State<KeybardRow4> createState() => _KeybardRow4State();
}

class _KeybardRow4State extends State<KeybardRow4> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('0'),tooltip: '0',label: const Text('0'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('.'),tooltip: '.',label: const Text('.'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton.extended(onPressed: () => widget.screenDisplay('00'),tooltip: '00',label: const Text('00'),backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(0.0),child: FloatingActionButton(onPressed: () => widget.screenDisplay('='),tooltip: '=',backgroundColor:const Color.fromARGB(0, 0, 0, 0),elevation: 0,child: const Text('=',style: TextStyle(color: Colors.white,), ),),),),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(0.0),
          ),
        ),
      ],
    );
  }
}