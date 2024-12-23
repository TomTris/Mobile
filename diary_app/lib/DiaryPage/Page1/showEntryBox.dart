import 'package:diary_app/Login_Signup/HomePage/homepage.dart';
import 'package:diary_app/snack_bar.dart';
import 'package:diary_app/globalData.dart';
import 'package:flutter/material.dart';

//'update' / 'create'
void showEntryBox(BuildContext context, superWidget, String? title, String? noteId) {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String feeling = 'very_happy';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
  }

  _titleController.text = '';
  _contentController.text = '';
  if (noteId != null){
    for (var each in GlobalData.entriesSorted){
      if (noteId == each.key){
        _titleController.text = each.value['title'];
        _contentController.text = each.value['content'];
        feeling = each.value['feeling'];
        break ;
      }
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
                                Icon(GlobalData.getIcon(eachFeeling).icon, color: GlobalData.getIcon(eachFeeling).color),
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
              if (noteId != null)
              TextButton(
                child: Text('Delete'),
                onPressed: () async{
                  try {
                    await FirebaseFirestoreService().deleteEntry(noteId);
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
                child: noteId == null ? Text('Create') : Text('Update'),
                onPressed: () async{
                  try {
                    Navigator.of(context).pop();
                    noteId == null
                    ? await FirebaseFirestoreService().addEntry(_titleController.text, feeling, _contentController.text)
                    : await FirebaseFirestoreService().updateEntry(noteId, _titleController.text, feeling, _contentController.text);
                    superWidget();
                  }
                  catch (e) {
                    showErrorDialog(context, e.toString());
                  };
                },
              ),
            ],
          );
        },
      );
    },
  );
}
