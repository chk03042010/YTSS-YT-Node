import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/network.dart';
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
  //placeholder announcements
  late List<AnnouncementData> announcements;
  List<String> selectedClasses = [];
  late List<String> availableClasses;

  HomePageState() {
    announcements = getAnnouncementsPlaceholder();
    announcements.sort(AnnouncementData.sortFunction);
    availableClasses = getClassesPlaceholder();
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
    var data = AnnouncementData(title, clazz, due, author, description, uuid);

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
            Expanded(
              child: announcements.isEmpty
                  ? Center(
                      child: Text(
                        "No announcements to display", 
                        style: theme.textTheme.titleMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        if (selectedClasses.isNotEmpty &&
                            !selectedClasses.contains(announcements[index].getClass())) {
                          return SizedBox();
                        }
                        return Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(announcements[index].getTitle()),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Class: ${announcements[index].getClass()}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                            "Posted by: ${announcements[index].getAuthor()}"),
                                        Text(
                                            "Due: ${announcements[index].getDue()}"),
                                        SizedBox(height: 12),
                                        Text("Description:"),
                                        SizedBox(height: 4),
                                        Text(announcements[index].getDesc()),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          if (announcements[index].getAuthorUUID() == account.uuid) {
                                            Navigator.pop(context);
                                            removeAnnouncement(announcements[index]);
                                          }
                                        },
                                        style: announcements[index].getAuthorUUID() != account.uuid ?
                                          ButtonStyle(
                                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                                            mouseCursor: DefaultMouseCursor(),
                                          ) : null,
                                        child: Text("Delete", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: announcements[index].getAuthorUUID() == account.uuid ? Colors.red : Colors.grey
                                        )),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Close"),
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  );
                                },
                              );
                            },

                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          announcements[index].getTitle(),
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: announcements[index].getDaysToDue() < 0 ? Color.fromRGBO(175, 6, 6, 1) :
                                                theme.primaryColor.withAlpha((0.2 * 255).toInt()),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "Due: ${announcements[index].getDue()}", 
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: switch (announcements[index].getDaysToDue()) {
                                              0 => Color.fromRGBO(255, 0, 0, 1),
                                              1 || 2 => Colors.orange,
                                              3 => Colors.yellow,
                                              4 => Colors.lime,
                                              var x => x < 0 ? Color.fromRGBO(255, 120, 120, 1) : Colors.green
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    announcements[index].getClass(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
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