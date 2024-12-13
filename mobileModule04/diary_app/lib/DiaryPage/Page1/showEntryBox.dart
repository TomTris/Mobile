import 'package:diary_app/Login_Signup/HomePage/homepage.dart';
import 'package:diary_app/snack_bar.dart';
import 'package:diary_app/globalData.dart';
import 'package:flutter/material.dart';

Icon getIcon(String feeling)
{
  late IconData res;
  var color;

  switch (feeling)
  {
    case ('very_happy'):
      res = Icons.sentiment_satisfied_alt;
      color = Colors.orange;
    case ('happy'):
      res = Icons.sentiment_very_satisfied;
      color = const Color.fromARGB(255, 191, 150, 15);
    case ('sad'):
      res = Icons.sentiment_dissatisfied;
      color = Colors.grey;
    case ('very_sad'):
      res = Icons.sentiment_very_dissatisfied;
      color = Colors.black;
    case ('angry'):
      res = Icons.face;
      color = Colors.red;
    case ('neutral'):
      res = Icons.sentiment_neutral;
      color = Colors.green;
    default:
      res = Icons.sentiment_satisfied_alt;
      color = Colors.orange;
  }
  return (
    Icon( res,
      color: color,
      size: 35,
    ));
}

void showEntryBox(BuildContext context, superWidget, String? title) {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String feeling = 'very_happy';
  _titleController.text = 'New Title';
  _contentController.text = 'Content';
  if (title != null){
    for (var each in GlobalData.entriesSorted){
      String? feeling2 = feeling;
      if (title == each.key){
        _titleController.text = title;
        _contentController.text = each.value['value'];
        feeling2 = each?.value['feeling'];
      }
      if (feeling2 != null)
        feeling = feeling2;
    }
  }
  List<String> feelingList = ['very_happy', 'happy', 'sad', 'very_sad', 'angry', 'neutral'];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Container(
              width: 700,height: 60,
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
              ),
            ),
            content: Container(
              width: 700, height: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 700, height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding around the DropdownButton
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 231, 233), // Light background color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3),spreadRadius: 1,blurRadius: 4,offset: Offset(0, 2),),],
                    ),
                    child: DropdownButton<String>(
                      value: feeling,
                      isExpanded: true, // Ensures the dropdown takes up the full width
                      dropdownColor: Colors.white, // Customize the dropdown background color
                      icon: Icon(Icons.arrow_downward), 
                      items: [
                        for (var eachFeeling in feelingList)
                          DropdownMenuItem(
                            value: eachFeeling,
                            child: Row(
                              children: [
                                Icon(getIcon(eachFeeling).icon, color: getIcon(eachFeeling).color),
                                SizedBox(width: 8),
                                Text(eachFeeling),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (String? newFeeling) {
                        setState(() {
                          if (newFeeling != null) {
                            feeling = newFeeling;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 231, 233),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3),spreadRadius: 2,blurRadius: 4,offset: Offset(0, 2),),],
                    ),
                    child: TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        labelStyle: TextStyle(color: Colors.grey,),
                        border: InputBorder.none, // No border
                      ),
                      maxLines: 20,
                      style: TextStyle(fontSize: 16,color: Colors.black,),
                      onChanged: (value) {setState(() {});},
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Delete'),
                onPressed: () async{
                  try {
                    await FirebaseFirestoreService().deleteEntry(_titleController.text);
                    Navigator.of(context).pop();
                    superWidget();
                  }
                  catch (e) {
                    showErrorDialog(context, e.toString());
                  };
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
                onPressed: () async{
                  try {
                    await FirebaseFirestoreService().addEntry(_titleController.text, feeling, _contentController.text);
                    superWidget();
                  }
                  catch (e) {
                    showErrorDialog(context, e.toString());
                  };
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