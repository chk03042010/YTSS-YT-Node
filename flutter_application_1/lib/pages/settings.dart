import 'package:flutter/material.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onLoginToggle;
  final List<String> availableClasses;
  final List<String> selectedClasses;
  final Function(String, bool?) onClassToggle;
  final Function(List<String>) onMultipleClassSelect;
  final Function(ThemeMode, {ThemeData? custom}) updateTheme;

  const SettingsPage({super.key, 
    required this.onLoginToggle,
    required this.availableClasses,
    required this.selectedClasses,
    required this.onClassToggle,
    required this.onMultipleClassSelect,
    required this.updateTheme,
  });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
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
          // Top bar section
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Account Settings", //TODO: lang
              style: theme.textTheme.titleLarge,
            ),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return SwitchListTile(
                title: Text("Logged In"), //TODO: lang
                subtitle: Text("Toggle to enable adding announcements"), //TODO: lang
                value: appState.isLoggedIn,
                onChanged: (val) {
                  stateSetter(() => appState.isLoggedIn = val);
                  widget.onLoginToggle(val);
                },
                activeColor: theme.primaryColor,
              );
            }
          ),

          // Theme section
          Divider(),

          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Theme", //TODO: lang
              style: theme.textTheme.titleLarge,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Choose Theme", //TODO: lang
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

          // Class section
          Divider(),

          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Class Subscriptions", //TODO: lang
              style: theme.textTheme.titleLarge,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Select which classes you want to see announcements for:", //TODO: lang
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
                            ? "No classes selected" //TODO: lang
                            : _selectedClasses.length == 1
                                ? _selectedClasses.first
                                : "${_selectedClasses.length} classes selected", //TODO: lang
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
                          child: Text("Clear All"), //TODO: lang
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedClasses =
                                  List.from(widget.availableClasses);
                            });
                          },
                          child: Text("Select All"), //TODO: lang
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

