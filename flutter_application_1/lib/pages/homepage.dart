import 'package:flutter/material.dart';
import './settings.dart';
import './placeholder.dart';
import 'announcement.dart';
import '../util.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  final Function(ThemeMode, {ThemeData? custom}) updateTheme;

  const HomePage({super.key, required this.updateTheme});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //placeholder announcements
  List<Map<String, String>> announcements = getAnnouncementsPlaceholder();
  List<String> selectedClasses = [];
  List<String> availableClasses = getClassesPlaceholder();

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

  void _addAnnouncement(String title, String selectedClass, String dueDate,
      String postedBy, String description) {
    setState(() {
      // Format the date before adding
      String formattedDate = dateFormatString(dueDate);
      
      //TODO: lang
      announcements.add({
        "title": title, 
        "class": selectedClass,
        "due": formattedDate,
        "postedBy": postedBy,
        "description": description,
      });
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
        updateTheme: widget.updateTheme,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Announcements", //TODO: lang
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
                        "No announcements to display", //TODO: lang
                        style: theme.textTheme.titleMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        if (selectedClasses.isNotEmpty &&
                            !selectedClasses
                                .contains(announcements[index]["class"])) {
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
                                    title: Text(announcements[index]["title"]!),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Class: ${announcements[index]["class"]!}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                            "Posted by: ${announcements[index]["postedBy"]!}"),
                                        Text(
                                            "Due: ${announcements[index]["due"]!}"),
                                        SizedBox(height: 12),
                                        Text("Description:"),
                                        SizedBox(height: 4),
                                        Text(
                                            announcements[index]["description"]!),
                                      ],
                                    ),
                                    actions: [
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
                                          announcements[index]["title"]!,
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
                                          color: theme.primaryColor.withAlpha((0.2 * 255).toInt()),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "Due: ${announcements[index]["due"]!}", //TODO: lang
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: theme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    announcements[index]["class"]!,
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
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"), //TODO: lang
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"), //TODO: lang
        ],
        onTap: (index) {
          if (index == 0) { // Add
            if (appState.isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddAnnouncementPage(
                        onAdd: _addAnnouncement,
                        availableClasses: availableClasses,
                        selectedClasses: selectedClasses)),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Sign in Required"), //TODO: lang
                  content:
                      Text("You need to be signed in to add announcements."), //TODO: lang
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
                      child: Text("Go to Settings"), //TODO: lang
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