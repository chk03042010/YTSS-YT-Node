import 'package:flutter/material.dart';
import '../util.dart';

class AddAnnouncementPage extends StatefulWidget {
  final Function(String, String, String, String, String) onAdd;
  final List<String> availableClasses;
  final List<String> selectedClasses;

  const AddAnnouncementPage(
    {super.key, required this.onAdd,
      required this.availableClasses,
      required this.selectedClasses});

  @override
  AddAnnouncementPageState createState() => AddAnnouncementPageState();
}

class AddAnnouncementPageState extends State<AddAnnouncementPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedClass;

  @override
  Widget build(BuildContext context) {
    // Use available classes if we have selected classes, otherwise use all classes
    List<String> classOptions = widget.selectedClasses.isNotEmpty
        ? widget.selectedClasses
        : widget.availableClasses;

    return Scaffold(
      appBar: AppBar(title: Text("Add Announcement")), //TODO: lang
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              //title bar
              TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",  //TODO: lang
                    prefixIcon: Icon(Icons.title),
                  )),
              SizedBox(height: 16),

              //class dropdown selection box
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Class",  //TODO: lang
                  prefixIcon: Icon(Icons.class_),
                ),

                value: _selectedClass,
                items: classOptions.map((className) {
                  return DropdownMenuItem(
                      value: className, child: Text(className));
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    _selectedClass = value.toString();
                  });
                },
              ),
              SizedBox(height: 16),

              //description text area
              TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description (Keep it short)",  //TODO: lang
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: Icon(Icons.description),
                    ),
                  )),
              SizedBox(height: 16),

              //due date picker
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: "Due Date",  //TODO: lang
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = dateFormatDateTime(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty &&
                      _selectedClass != null &&
                      _dateController.text.isNotEmpty) {
                    widget.onAdd(
                      _titleController.text,
                      _selectedClass ?? "",
                      _dateController.text,
                      "You", //TODO: lang
                      _descriptionController.text,
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please fill all required fields"),  //TODO: lang
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ));
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                      child: Text("Publish", style: TextStyle(fontSize: 16))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}