import 'package:flutter/material.dart';

void showEntryBox(BuildContext context, superWidget) {
  String _dialogTitle = "Dialog Title";
  String _dialogContent = "This is the dialog content.";
  IconData _dialogIcon = Icons.info;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  _contentController.text = _dialogContent;
  _titleController.text = _dialogTitle;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Container(
              width: 700,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 227, 231, 233), // Light background color
                borderRadius: BorderRadius.circular(8), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1), // Shadow position
                  ),
                ],
              ),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Colors.grey, // Light gray label color
                  ),
                  border: InputBorder.none, // No border around the text field
                ),
                style: TextStyle(
                  fontSize: 20, // Larger font size for the title
                  color: Colors.black, // Text color
                ),
                onChanged: (value) {
                  setState(() {
                    _dialogTitle = value;
                  });
                },
              ),
            ),
            content: Container(
              width: 700,
              height: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 700,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding around the DropdownButton
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 231, 233), // Light background color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: DropdownButton<IconData>(
                      value: _dialogIcon,
                      isExpanded: true, // Ensures the dropdown takes up the full width
                      items: [
                        DropdownMenuItem(
                          value: Icons.info,
                          child: Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue),
                              SizedBox(width: 8),
                              Text("Info"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: Icons.warning,
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange),
                              SizedBox(width: 8),
                              Text("Warning"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: Icons.check_circle,
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text("Success"),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (IconData? value) {
                        setState(() {
                          if (value != null) {
                            _dialogIcon = value;
                          }
                        });
                      },
                      iconEnabledColor: Colors.black, // Set the color of the dropdown arrow
                      iconSize: 30, // Set the size of the dropdown arrow
                      underline: Container(), // Remove the default underline
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.all(16), // Add padding around the text field
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 231, 233), // Light background color
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        labelStyle: TextStyle(
                          color: Colors.grey, // Light gray label color
                        ),
                        border: InputBorder.none, // No border
                      ),
                      maxLines: 20, // Allows multiple lines
                      style: TextStyle(
                        fontSize: 16, // Font size for the text
                        color: Colors.black, // Text color
                      ),
                      onChanged: (value) {
                        setState(() {
                          _dialogContent = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                  superWidget();
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  superWidget();
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  setState(() {
                    _dialogTitle = _titleController.text;
                    _dialogContent = _contentController.text;
                  });
                  Navigator.of(context).pop();
                  superWidget();
                },
              ),
            ],
          );
        },
      );
    },
  );
}