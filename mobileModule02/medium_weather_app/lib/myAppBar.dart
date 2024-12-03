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
  });

  final TextEditingController searchController;
  final Future<int> Function(int) searchTheInput;
  final Future<int> Function(String) updateSuggestions;
  final Future<int> Function() getCurrentLocation;
  final List<String> citySuggestions;
  final Function() myState;
  Timer? debounce;


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