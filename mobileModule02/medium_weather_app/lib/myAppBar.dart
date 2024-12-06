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
    required this.updateLastClick,
    required this.updateLastShowBar,
    required this.waitingTime,
    required this.isAnsweredLocation,
  });

  final TextEditingController searchController;
  final Future<int> Function(int) searchTheInput;
  final Future<int> Function(String) updateSuggestions;
  final Future<int> Function(int) getCurrentLocation;
  final List<String> citySuggestions;
  final Function() myState;
  Timer? debounce;
  final DateTime? lastClick;
  final DateTime? lastShowBar;
  final Function(DateTime) updateLastClick;
  final Function(DateTime) updateLastShowBar;
  final Duration waitingTime;
  final int     isAnsweredLocation;


  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      AppBar(
        title:  TextField(
          controller: widget.searchController,
          enabled: widget.isAnsweredLocation == 0 ? false : true ,
          decoration: InputDecoration(
            hintText: "Search Information",
          ),
          onSubmitted: (value) async {
            await widget.searchTheInput(0);
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
        actions: [
          IconButton(onPressed: widget.isAnsweredLocation == 0 ? null : () async {
            DateTime now = DateTime.now();
            if (widget.lastClick != null && now.difference(widget.lastClick!) < widget.waitingTime)
            {
              if (widget.lastShowBar == null || now.difference(widget.lastShowBar!) > Duration(milliseconds: 4000))
              {
                widget.updateLastShowBar(now);
                widget.myState();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Operation in progress, please wait.")),
                );
              }
              return ;
            }
            widget.updateLastClick(now);
            await widget.getCurrentLocation(1);
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