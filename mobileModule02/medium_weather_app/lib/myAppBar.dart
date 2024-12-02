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
  });

  final TextEditingController searchController;
  final Function(int) searchTheInput;
  final Function(String) updateSuggestions;
  final Future<void> Function() getCurrentLocation;
  final List<String> citySuggestions;
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
          onSubmitted: (value) => {widget.searchTheInput(-1)},
          onChanged: (value) {
            if (widget.debounce != null && widget.debounce?.isActive == true)
              {widget.debounce?.cancel();}
            widget.debounce = Timer(Duration(milliseconds: 500), () {
              widget.updateSuggestions(value);
            });
          },
        ),
        actions: [IconButton(onPressed: widget.getCurrentLocation, icon: Icon(Icons.location_on)),],
        backgroundColor: Colors.blueGrey,
      ),
      if (widget.citySuggestions.isNotEmpty)
      Expanded(
          child: ListView.builder(
            itemCount: widget.citySuggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.citySuggestions[index]),
                onTap: () {
                  widget.searchController.text = widget.citySuggestions[index];
                  widget.searchTheInput(index);
                },
              );
            },
          ),
        )
    ],);
  }
}