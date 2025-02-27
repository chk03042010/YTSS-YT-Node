import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;
  ThemeData? customTheme;

  void updateTheme(ThemeMode mode, {ThemeData? custom}) {
    setState(() {
      themeMode = mode;
      customTheme = custom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define the light theme
      theme: customTheme ??
          ThemeData(
            primarySwatch: Colors.blue,
            secondaryHeaderColor: Colors.blueAccent,
            cardTheme: CardTheme(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
          ),
      // Define the dark theme
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        cardTheme: CardTheme(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: Colors.grey[800],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // Set the theme mode based on whether a custom theme is provided
      themeMode: customTheme != null ? ThemeMode.light : themeMode,
      home: HomePage(updateTheme: updateTheme),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(ThemeMode, {ThemeData? custom}) updateTheme;

  HomePage({required this.updateTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> announcements = [
    {
      "title": "Math Test",
      "class": "Class 1",
      "due": "Feb 28",
      "postedBy": "Mr. Johnson",
      "description": "Prepare for calculus test on derivatives and integrals."
    },
    {
      "title": "English Essay",
      "class": "Class 2",
      "due": "Mar 3",
      "postedBy": "Ms. Williams",
      "description": "Write a 500-word essay on Shakespeare's Hamlet."
    },
    {
      "title": "Physics Lab",
      "class": "Class 3",
      "due": "Mar 5",
      "postedBy": "Dr. Smith",
      "description": "Prepare for lab on momentum and collisions."
    },
    {
      "title": "History Project",
      "class": "Class 4",
      "due": "Mar 10",
      "postedBy": "Mrs. Davis",
      "description": "Complete research project on World War II."
    },
    {
      "title": "Chemistry Quiz",
      "class": "Class 5",
      "due": "Mar 1",
      "postedBy": "Dr. Wilson",
      "description": "Study periodic table and chemical bonding for quiz."
    },
    {
      "title": "Art Exhibition",
      "class": "Class 6",
      "due": "Mar 15",
      "postedBy": "Ms. Thompson",
      "description": "Prepare your portfolio for the spring exhibition."
    },
    {
      "title": "Computer Science Project",
      "class": "Class 7",
      "due": "Mar 7",
      "postedBy": "Mr. Anderson",
      "description": "Complete your programming assignment on data structures."
    },
    {
      "title": "Music Recital",
      "class": "Class 8",
      "due": "Mar 20",
      "postedBy": "Mr. Lewis",
      "description": "Practice your piece for the upcoming recital."
    },
    {
      "title": "Biology Exam",
      "class": "Class 9",
      "due": "Mar 12",
      "postedBy": "Dr. Harris",
      "description": "Study cell biology and genetics for midterm exam."
    },
    {
      "title": "Physical Education",
      "class": "Class 10",
      "due": "Mar 2",
      "postedBy": "Coach Brown",
      "description": "Bring appropriate gear for basketball tournament."
    },
  ];

  bool isLoggedIn = false;
  List<String> selectedClasses = [];
  List<String> availableClasses = [
    "Class 1",
    "Class 2",
    "Class 3",
    "Class 4",
    "Class 5",
    "Class 6",
    "Class 7",
    "Class 8",
    "Class 9",
    "Class 10"
  ];

  void _toggleLogin(bool? value) {
    setState(() {
      isLoggedIn = value ?? false;
    });
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

  // Format date string to month abbreviation and day
  String formatDueDate(String dateString) {
    try {
      // Check if already in the correct format (like "Feb 28")
      if (dateString.contains(" ")) {
        return dateString;
      }

      List<String> parts = dateString.split('/');
      if (parts.length != 2) return dateString;

      int month = int.tryParse(parts[0]) ?? 1;
      int day = int.tryParse(parts[1]) ?? 1;

      List<String> monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      return "${monthNames[month - 1]} $day";
    } catch (e) {
      return dateString;
    }
  }

  void _addAnnouncement(String title, String selectedClass, String dueDate,
      String postedBy, String description) {
    setState(() {
      // Format the date before adding
      String formattedDate = formatDueDate(dueDate);

      announcements.add({
        "title": title,
        "class": selectedClass,
        "due": formattedDate,
        "postedBy": postedBy,
        "description": description,
      });
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
                                            "${announcements[index]["description"]!}"),
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
                                          color: theme.primaryColor
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "Due: ${announcements[index]["due"]!}",
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
                                      color: theme.colorScheme.onBackground
                                          .withOpacity(0.6),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: (index) {
          if (index == 0) {
            if (isLoggedIn) {
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
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(
                              isLoggedIn: isLoggedIn,
                              onLoginToggle: _toggleLogin,
                              availableClasses: availableClasses,
                              selectedClasses: selectedClasses,
                              onClassToggle: _toggleClassSelection,
                              onMultipleClassSelect: _setSelectedClasses,
                              updateTheme: widget.updateTheme,
                            ),
                          ),
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
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsPage(
                        isLoggedIn: isLoggedIn,
                        onLoginToggle: _toggleLogin,
                        availableClasses: availableClasses,
                        selectedClasses: selectedClasses,
                        onClassToggle: _toggleClassSelection,
                        onMultipleClassSelect: _setSelectedClasses,
                        updateTheme: widget.updateTheme,
                      )),
            );
          }
        },
      ),
    );
  }
}

class AddAnnouncementPage extends StatefulWidget {
  final Function(String, String, String, String, String) onAdd;
  final List<String> availableClasses;
  final List<String> selectedClasses;

  AddAnnouncementPage(
      {required this.onAdd,
      required this.availableClasses,
      required this.selectedClasses});

  @override
  _AddAnnouncementPageState createState() => _AddAnnouncementPageState();
}

class _AddAnnouncementPageState extends State<AddAnnouncementPage> {
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
      appBar: AppBar(
        title: Text("Add Announcement"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    prefixIcon: Icon(Icons.title),
                  )),
              SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Class",
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
              TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: Icon(Icons.description),
                    ),
                  )),
              SizedBox(height: 16),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: "Due Date",
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
                    // Format the date as month abbreviation + day
                    List<String> monthNames = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec'
                    ];

                    setState(() {
                      _dateController.text =
                          "${monthNames[pickedDate.month - 1]} ${pickedDate.day}";
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
                      "You",
                      _descriptionController.text,
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please fill all required fields"),
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

class SettingsPage extends StatefulWidget {
  final bool isLoggedIn;
  final Function(bool?) onLoginToggle;
  final List<String> availableClasses;
  final List<String> selectedClasses;
  final Function(String, bool?) onClassToggle;
  final Function(List<String>) onMultipleClassSelect;
  final Function(ThemeMode, {ThemeData? custom}) updateTheme;

  SettingsPage({
    required this.isLoggedIn,
    required this.onLoginToggle,
    required this.availableClasses,
    required this.selectedClasses,
    required this.onClassToggle,
    required this.onMultipleClassSelect,
    required this.updateTheme,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedTheme = 'Light';
  List<String> _selectedClasses = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedClasses = List.from(widget.selectedClasses);
  }

  void _updateClasses(bool save) {
    if (save) {
      widget.onMultipleClassSelect(_selectedClasses);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          TextButton(
            onPressed: () {
              _updateClasses(true);
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Account Settings",
              style: theme.textTheme.titleLarge,
            ),
          ),
          SwitchListTile(
            title: Text("Logged In"),
            subtitle: Text("Toggle to enable adding announcements"),
            value: widget.isLoggedIn,
            onChanged: widget.onLoginToggle,
            activeColor: theme.primaryColor,
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Theme",
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Choose Theme",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.color_lens),
              ),
              value: _selectedTheme,
              items: [
                DropdownMenuItem(value: 'Light', child: Text('Light')),
                DropdownMenuItem(value: 'Dark', child: Text('Dark')),
                DropdownMenuItem(value: 'Pink', child: Text('Pink')),
                DropdownMenuItem(
                    value: 'YTSS', child: Text('YTSS (Navy & Yellow)')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value;

                  // Apply the theme
                  if (value == 'Light') {
                    widget.updateTheme(ThemeMode.light);
                  } else if (value == 'Dark') {
                    widget.updateTheme(ThemeMode.dark);
                  } else if (value == 'Pink') {
                    widget.updateTheme(ThemeMode.light,
                        custom: ThemeData(
                          primarySwatch: Colors.pink,
                          scaffoldBackgroundColor: Color(0xFFFEE5EC),
                          cardTheme: CardTheme(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          appBarTheme: AppBarTheme(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                          elevatedButtonTheme: ElevatedButtonThemeData(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ));
                  } else if (value == 'YTSS') {
                    widget.updateTheme(ThemeMode.light,
                        custom: ThemeData(
                          primaryColor: Color(0xFF0A1958), // Navy blue
                          scaffoldBackgroundColor: Colors.white,
                          cardTheme: CardTheme(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          appBarTheme: AppBarTheme(
                            backgroundColor: Color(0xFF0A1958),
                            foregroundColor: Color(0xFFFFC700), // Yellow
                            elevation: 0,
                          ),
                          elevatedButtonTheme: ElevatedButtonThemeData(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A1958),
                              foregroundColor: Color(0xFFFFC700),
                            ),
                          ),
                          colorScheme: ColorScheme.light(
                            primary: Color(0xFF0A1958),
                            secondary: Color(0xFFFFC700),
                          ),
                        ));
                  }
                });
              },
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Class Subscriptions",
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Select which classes you want to see announcements for:",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isDropdownOpen = !_isDropdownOpen;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.class_),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedClasses.isEmpty
                            ? "No classes selected"
                            : _selectedClasses.length == 1
                                ? _selectedClasses.first
                                : "${_selectedClasses.length} classes selected",
                      ),
                    ),
                    Icon(_isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          if (_isDropdownOpen)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: theme.cardColor,
              ),
              child: Column(
                children: [
                  ...widget.availableClasses.map((className) {
                    return CheckboxListTile(
                      title: Text(className),
                      value: _selectedClasses.contains(className),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedClasses.add(className);
                          } else {
                            _selectedClasses.remove(className);
                          }
                        });
                      },
                      activeColor: theme.primaryColor,
                      dense: true,
                    );
                  }).toList(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedClasses.clear();
                            });
                          },
                          child: Text("Clear All"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedClasses =
                                  List.from(widget.availableClasses);
                            });
                          },
                          child: Text("Select All"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

