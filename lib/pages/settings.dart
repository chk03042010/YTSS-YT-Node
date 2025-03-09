import 'package:flutter/material.dart';
import 'package:flutter_application_1/network.dart';
import 'package:flutter_application_1/util.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onLoginToggle;
  final List<String> availableClasses;
  final List<String> selectedClasses;
  final Function(String, bool?) onClassToggle;
  final Function(List<String>) onMultipleClassSelect;

  const SettingsPage({
    super.key,
    required this.onLoginToggle,
    required this.availableClasses,
    required this.selectedClasses,
    required this.onClassToggle,
    required this.onMultipleClassSelect,
  });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  List<String> _selectedClasses = [];
  bool _isDropdownOpen = false;

  String _newTheme = appState.selectedTheme;
  String _oldTheme = "";
  bool _isChangesMade = false;

  @override
  void initState() {
    super.initState();
    _selectedClasses = List.from(widget.selectedClasses);
    _oldTheme = appState.selectedTheme;
  }

  void updateTheme(String? value) {
    if (value == _newTheme) {
      return;
    }

    if (value != _oldTheme) {
      _isChangesMade = true;
    }

    _newTheme = value ?? appState.selectedTheme;
    changeAppTheme(_newTheme, widget, this);
  }

  void saveChanges() {
    widget.onMultipleClassSelect(_selectedClasses);
    changeAppTheme(_newTheme, widget, this);
    Navigator.pop(context);
    appSaveToPref();

    showSnackBar(context, "Settings Saved!");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          TextButton(
            onPressed: () => saveChanges(),
            child: Text(
              "Save",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appState.themeData.$2.colorScheme.secondary,
              ),
            ),
          ),
        ],
        leading: BackButton(
          onPressed: () {
            if (_isChangesMade) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final theme = Theme.of(context);
                  return AlertDialog(
                    title: Text("Warning! There are unsaved changes."),
                    titleTextStyle: theme.textTheme.titleSmall,
                    actions: [
                      TextButton(
                        onPressed: () {
                          changeAppTheme(_oldTheme, widget, this);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Revert changes",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),

      body: ListView(
        children: [
          // Top bar section
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("Account Settings", style: theme.textTheme.titleLarge),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return SwitchListTile(
                title: Text("Logged In"),
                subtitle: Text("Toggle to enable adding announcements"),
                value: appState.isLoggedIn,
                onChanged: (val) {
                  stateSetter(() => appState.isLoggedIn = val);
                  widget.onLoginToggle(val);
                },
                activeColor: theme.primaryColor,
              );
            },
          ),

          // Theme section
          Divider(),

          Padding(
            padding: EdgeInsets.all(16),
            child: Text("Theme", style: theme.textTheme.titleLarge),
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
              value: appState.selectedTheme,
              items: [
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
                DropdownMenuItem(value: 'pink', child: Text('Pink')),
                DropdownMenuItem(
                  value: 'ytss',
                  child: Text('YTSS (Navy & Yellow)'),
                ),
              ],
              onChanged: (value) {
                updateTheme(value);
              },
            ),
          ),

          // Class section
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
                    Icon(
                      _isDropdownOpen
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
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
                      onChanged: (bool? value) async {
                        _isChangesMade = true;

                        if (value == true) {
                          await changeSelectedClassesInServer(className, true);
                          //TODO: add exception handle
                        } else {
                          await changeSelectedClassesInServer(className, false);
                        }

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
                  }),
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
                              _selectedClasses = List.from(
                                widget.availableClasses,
                              );
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
