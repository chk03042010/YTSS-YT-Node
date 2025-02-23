import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900], // Darker Blue
        scaffoldBackgroundColor: Colors.white, // White background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white, // White text
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber[700], // Brighter Yellow
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.amber[700], // Yellow selected icon
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.blue[900],
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> tasks = [
    {"task": "Complete Flutter Project", "due": "Due: Feb 25, 2025"},
    {"task": "Study for Exams", "due": "Due: Mar 1, 2025"},
  ];

  int _selectedIndex = 0;

  void _addTask() {
    setState(() {
      tasks.add({"task": "New Task", "due": "Due: TBD"});
    });
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do List")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue[50], // Soft blue background
                    shadowColor: Colors.blue[900],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        tasks[index]["task"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      subtitle: Text(
                        tasks[index]["due"]!,
                        style: TextStyle(color: Colors.blueGrey[700]),
                      ),
                      trailing: Icon(Icons.check_circle, color: Colors.amber[700]),
                    ),
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: _addTask,
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.announcement), label: "Announcements"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}



