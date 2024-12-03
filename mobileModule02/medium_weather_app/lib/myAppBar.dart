import 'dart:async';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyAppBar extends StatefulWidget {
  MyAppBar({
    super.key,
    required this.searchController,
    required this.searchTheInput,
    required this.updateSuggestions,
    required this.getCurrentLocation,
    required this.citySuggestions,
    required this.debounce,
    required this.myState,
    required this.lastClick,
    required this.lastShowBar,
    required this.waitingTime,
  });

  final TextEditingController searchController;
  final Future<int> Function(int) searchTheInput;
  final Future<int> Function(String) updateSuggestions;
  final Future<int> Function() getCurrentLocation;
  final List<String> citySuggestions;
  final Function() myState;
  Timer? debounce;
  DateTime? lastClick;
  DateTime? lastShowBar;
  final Duration waitingTime;


  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {

  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      AppBar(
        title:  TextField(
          controller: widget.searchController,
          decoration: InputDecoration(
            hintText: "Search Information",
          ),
          onSubmitted: (value) async {
            await widget.searchTheInput(-1);
            widget.myState();
          },
          onChanged: (value) async {
            if (widget.debounce != null && widget.debounce?.isActive == true)
              {widget.debounce?.cancel();}
            widget.debounce = Timer(Duration(milliseconds: 350), () async {
              await widget.updateSuggestions(value);
              widget.myState();
            });
          },
        ),
        actions: [IconButton(onPressed: () async {
          if (widget.lastClick != null && now.difference(widget.lastClick!) < widget.waitingTime)
          {
            if (widget.lastShowBar == null || now.difference(widget.lastShowBar!) > Duration(seconds: 5))
            {
              widget.lastShowBar = now;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Operation in progress, please wait.")),
              );
            }
            return ;
          }
          widget.lastClick = now;
          await widget.getCurrentLocation();
          widget.myState();
        },
          icon: Icon(Icons.location_on)),],
        backgroundColor: Colors.blueGrey,
      ),
      if (widget.citySuggestions.isNotEmpty)
      Expanded(
          child: ListView.builder(
            itemCount: widget.citySuggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.citySuggestions[index]),
                onTap: () async {
                  widget.searchController.text = widget.citySuggestions[index];
                  await widget.searchTheInput(index);
                  widget.myState();
                },
              );
            },
          ),
        )
    ],);
  }
}