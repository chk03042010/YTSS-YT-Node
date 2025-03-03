import 'package:flutter/material.dart';
import 'package:flutter_application_1/network.dart';
import 'package:flutter_application_1/pages/homepage_widget.dart';
import './settings.dart';
import './placeholder.dart';
import 'announcement.dart';
import '../util.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //announcements and classes
  late List<AnnouncementData> announcements;
  List<String> selectedClasses = [];
  List<String> availableClasses = [];
  
  //filter category
  bool showCompleted = true;
  bool showUncompleted = true;
  bool showPersonal = true;
  bool showPublic = true;

  HomePageState() {
    announcements = receiveAnnouncementFromServer() ?? [];
    announcements.sort(AnnouncementData.sortFunction);
    
    var classes = getClassesPlaceholder();
    for (var (clazz, selected) in classes) {
      availableClasses.add(clazz);
      if (selected) {
        selectedClasses.add(clazz);
      }
    }
  }

  void _toggleLogin(bool value) {
    setState(() { appState.isLoggedIn = value; });
  }

  void _toggleClassSelection(String className, bool? value) {
    setState(() {
      if (value == true) {
        selectedClasses.add(className);
      } else {
        selectedClasses.remove(className);
      }
    });
  }

  void _setSelectedClasses(List<String> classes) {
    setState(() {
      selectedClasses = List.from(classes);
    });
  }

  Future<bool> addAnnouncement(String title, String clazz, DateTime due, String author, String description, int uuid, bool isPublic) async {
    var data = AnnouncementData(title, clazz, due, author, description, uuid, isPublic);

    if (!await sendAnnouncementToServer(data, isPublic)) {
        return false;
    }

    setState(() {
      announcements.add(data);
      announcements.sort(AnnouncementData.sortFunction);
    });

    return true;
  }

  void removeAnnouncement(AnnouncementData data) {
    setState(() {
      announcements.remove(data);
    });
  }

  MaterialPageRoute getSettingsPageMaterial() {
    return MaterialPageRoute(
      builder: (context) => SettingsPage(
        onLoginToggle: _toggleLogin,
        availableClasses: availableClasses,
        selectedClasses: selectedClasses,
        onClassToggle: _toggleClassSelection,
        onMultipleClassSelect: _setSelectedClasses,
      ),
    );
  }

  void showFilterPopup(context) {
    showDialog(context: context, builder: (BuildContext context) {
      final theme = Theme.of(context);
      return AlertDialog(
        scrollable: true,
        title: const Text("Filter Announcements"),
        titleTextStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 30.0),
        content: StatefulBuilder(builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            child: Table(
              columnWidths: { 0: FlexColumnWidth(), 1: FlexColumnWidth(0.2) },
              children: [
                TableRow(children: [
                  Text("Show Completed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  Checkbox(checkColor: Colors.white, value: showCompleted,
                    onChanged: (bool? value) { setState(() { showCompleted = value!; }); },
                  ),
                ]),
                TableRow(children: [
                  Text("Show Uncompleted", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  Checkbox(checkColor: Colors.white, value: showUncompleted,
                    onChanged: (bool? value) { setState(() { showUncompleted = value!; }); },
                  ),
                ]),
                TableRow(children: [
                  Text("Show Personal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  Checkbox(checkColor: Colors.white, value: showPersonal,
                    onChanged: (bool? value) { setState(() { showPersonal = value!; }); },
                  ),
                ]),
                TableRow(children: [
                  Text("Show Public", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  Checkbox(checkColor: Colors.white, value: showPublic,
                    onChanged: (bool? value) { setState(() { showPublic = value!; }); },
                  ),
                ])
              ]
            )
          )
        )),
        actions: [
          ElevatedButton(
            child: const Text("Filter"),
            onPressed: () {
              setState((){});
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Announcements", 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.filter_alt_outlined),
              tooltip: "Pick a filter to categorise the announcements.",
              onPressed: () => showFilterPopup(context),
            ),

            Divider(),

            Expanded(
              child: announcements.isEmpty
                  ? Center(
                      child: Text(
                        "No announcements to display", 
                        style: theme.textTheme.titleMedium,
                      ),
                    )
                  //uncompleted ones at the top
                  : createAnnouncementList(announcements, selectedClasses,
                                            showUncompleted, showCompleted, showPersonal, showPublic,
                                            theme, context, setState, removeAnnouncement)     
            )
          ]
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"), 
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"), 
        ],
        onTap: (index) {
          if (index == 0) { // Add
            if (appState.isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddAnnouncementPage(
                        homePageState: this,
                        availableClasses: availableClasses,
                        selectedClasses: selectedClasses)),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Sign in Required"), 
                  content:
                      Text("You need to be signed in to add announcements."), 
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          getSettingsPageMaterial()
                        );
                      },
                      child: Text("Go to Settings"), 
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            }
          } else if (index == 1) { // Settings
            Navigator.push(
              context,
              getSettingsPageMaterial()
            );
          }
        },
      ),
    );
  }
}