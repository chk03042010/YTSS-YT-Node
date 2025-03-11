import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/pages/placeholder.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class NetworkClass {
  String name;
  bool selected;

  NetworkClass(this.name, this.selected);

  @override
  bool operator ==(Object other) =>
      other is NetworkClass && other.hashCode == hashCode;

  @override
  int get hashCode => name.hashCode;
}

List<AnnouncementData> _announcementServer = [];
List<NetworkClass> _classUser = [];
List<String> _classServer = [];
String getMessageFromErrorCodeAuth(e) {
  switch (e.code) {
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "wrong-password":
      return "Wrong email/password combination.";
    case "user-not-found":
      return "No user found with this email.";
    case "user-disabled":
      return "User disabled.";
    case "too-many=requests":
      return "Too many requests to log into this account.";
    case "operation-not-allowed":
      return "Server error, please try again later.";
    case "invalid-email":
      return "Email address is invalid.";
    default:
      return "Login failed. Please try again.";
  }
}

String getMessageFromErrorCodeDB(e) {
  switch (e.code) {
    case "aborted":
      return "";
    case "already-exists":
      return "";
    case "cancelled":
      return "";
    case "data-loss":
      return "";
    case "deadline-exceeded":
      return "";
    case "failed-precondition":
      return "";
    case "internal":
      return "";
    case "invalid-argument":
      return "";
    case "not-found":
      return "";
    case "out-of-range":
      return "";
    case "permission-denied":
      return "";
    case "resource-exhausted":
      return "";
    case "unauthenticated":
      return "";
    case "unavailable":
      return "";
    case "unimplemented":
      return "";
    default:
      return "";
  }
}

Future<bool> firebaseInit([bool initApp = true]) async {
  try {
    if (initApp) {
      // account = createAccount();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // account = await registerAccount(
      //   "aleph@ytss.edu.sg",
      //   "password1",
      //   "alpha",
      // );
      account = await signIn("aleph@ytss.edu.sg", "password1");
    }

    var database = FirebaseFirestore.instance;

    //get all public announcements
    await database.collection("announcements").get().then((event) {
      for (var doc in event.docs) {
        Map<String, dynamic> content = doc.data();
        AnnouncementData data = AnnouncementData(
          content["title"],
          content["class"],
          DateTime.parse(content["due"].toDate().toString()),
          content["author"],
          content["desc"],
          content["authorUUID"],
          true,
        );
        data.setId(content["id"]);

        //check if user has completed it
        database
            .collection("users")
            .doc(account.uuid)
            .collection("completed")
            .doc(data.getChecksum())
            .get()
            .then((item) {
              final content2 = item.data();
              if (content2!["isCompleted"]) {
                data.complete(true);
              }
            });

        //read if annc is complete, if it is call this function
        _announcementServer.add(data);
      }
    });

    //get all private announcements
    await database
        .collection("users")
        .doc(account.uuid)
        .collection("announcements")
        .get()
        .then((item) {
          for (var doc in item.docs) {
            Map<String, dynamic> content = doc.data();
            AnnouncementData data = AnnouncementData(
              content["title"],
              content["class"],
              DateTime.parse(content["due"].toDate().toString()),
              content["author"],
              content["desc"],
              content["authorUUID"],
              false,
            );
            data.setId(content["id"]);

            //check if private announcement is completed
            database
                .collection("users")
                .doc(account.uuid)
                .collection("completed")
                .doc(data.getChecksum())
                .get()
                .then((item) {
                  final content2 = item.data();
                  if (content2!["isCompleted"]) {
                    data.complete(true);
                  }
                });

            //read if annc is complete, if it is call this function
            _announcementServer.add(data);
          }
        });

    //class name format: ${Sec 4/3/2/1} ${class name}
    for (String level in ["Sec 4", "Sec 3", "Sec 2", "Sec 1"]) {
      await database.collection("classes").doc(level).get().then((item) {
        Map<String, dynamic>? content = item.data();
        for (String name in (content?.keys.toList() ?? [])) {
          _classServer.add("$level $name");
          _classUser.add(NetworkClass("$level $name", false));
        }
      });
    }

    //get selected classes
    await database
        .collection("users")
        .doc(account.uuid)
        .collection("classes")
        .get()
        .then((item) {
          for (var minidoc in item.docs) {
            Map<String, dynamic> content = minidoc.data();
            if (!_classUser.contains(NetworkClass(minidoc.id, false))) {
              _classUser.add(NetworkClass(minidoc.id, content["isselected"]));
            } else if (content["isselected"]) {
              _classUser[_classUser.indexOf(NetworkClass(minidoc.id, false))]
                  .selected = content["isselected"];
            }
          }
        });

    //removing classes from the user that no longer exists.
    for (var currentclass in _classUser) {
      if (!_classServer.contains(currentclass.name)) {
        _classUser.remove(currentclass);
        database
            .collection("users")
            .doc(account.uuid)
            .collection("classes")
            .doc(currentclass.name)
            .delete();
      }
    }
  } on FirebaseException catch (e) {
    // Caught an exception from Firebase.
    getMessageFromErrorCodeDB(e);
    return false;
  }

  return true;
}

Future<bool> sendAnnouncementToServer(
  AnnouncementData data,
  bool isPublic,
) async {
  try {
    var database = FirebaseFirestore.instance;
    data.setId(Random().nextInt(1 << 16));
    if (isPublic) {
      await database.collection("announcements").doc(data.getChecksum()).set({
        "author": account.name,
        "authorUUID": data.getAuthorUUID(),
        "class": data.getClass(),
        "desc": data.getDesc(),
        "due": data.getDueAsDateTime(),
        "id": data.getId(),
        "title": data.getTitle(),
      });

      await database
          .collection("users")
          .doc(account.uuid)
          .collection("completed")
          .doc(data.getChecksum())
          .set({"isCompleted": false});
    } else {
      await database
          .collection("users")
          .doc(account.uuid)
          .collection("announcements")
          .doc(data.getChecksum())
          .set({
            "author": account.name,
            "authorUUID": data.getAuthorUUID(),
            "class": data.getClass(),
            "desc": data.getDesc(),
            "due": data.getDueAsDateTime(),
            "id": data.getId(),
            "title": data.getTitle(),
          });

      await database
          .collection("users")
          .doc(account.uuid)
          .collection("completed")
          .doc(data.getChecksum())
          .set({"isCompleted": false});
    }
  } on FirebaseException catch (e) {
    // Caught an exception from Firebase.
    getMessageFromErrorCodeDB(e);
    return false;
  }
  return true;
}

List<AnnouncementData>? receiveAnnouncementFromServer() {
  return _announcementServer;
}

Future<bool> deleteAnnouncementFromServer(AnnouncementData data) async {
  try {
    var database = FirebaseFirestore.instance;
    if (data.isPublic()) {
      database.collection("announcements").doc(data.getChecksum()).delete();
      //TODO: use Cloud Functions to delete all users' announcements
    } else {
      database
          .collection("users")
          .doc(account.uuid)
          .collection("announcements")
          .doc(data.getChecksum())
          .delete();
    }

    database
        .collection("users")
        .doc(account.uuid)
        .collection("completed")
        .doc(data.getChecksum())
        .delete();
  } on FirebaseException catch (e) {
    getMessageFromErrorCodeDB(e);
    return false;
  }
  return true;
}

Future<bool> completeAnnouncementInServer(data) async {
  try {
    var database = FirebaseFirestore.instance;
    final file = database
        .collection("users")
        .doc(account.uuid)
        .collection("completed")
        .doc(data.getChecksum());

    file.update({"isCompleted": true});
  } on FirebaseException catch (e) {
    getMessageFromErrorCodeDB(e);
    return false;
  }
  return true;
}

Future<bool> changeSelectedClassesInServer(String clazz, bool selected) async {
  try {
    var database = FirebaseFirestore.instance;
    final file = database
        .collection("users")
        .doc(account.uuid)
        .collection("classes")
        .doc(clazz);
    file.set({"isselected": selected});
  } on FirebaseException catch (e) {
    getMessageFromErrorCodeDB(e);
    return false;
  }
  return true;
}

List<NetworkClass> receiveClassesFromServer() {
  return _classUser;
}

Future<Account> registerAccount(
  String emailAddress,
  String password,
  String name,
) async {
  // Initial default session
  var currentSession = Account(name: "guest", email: "guest", uuid: "0");

  try {
    // Create user in FirebaseAuth
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    // Get the current authenticated user
    User? user = FirebaseAuth.instance.currentUser;
    String uuid = (user != null) ? user.uid : "0";

    // Store user information in Firestore
    var database = FirebaseFirestore.instance;
    await database.collection("users").doc(uuid).set({"name": name});

    // Update current session with the new user details
    currentSession = Account(name: name, email: emailAddress, uuid: uuid);
  } on FirebaseAuthException catch (e) {
    getMessageFromErrorCodeAuth(e);
    return currentSession;
  }

  // Return the updated current session
  return currentSession;
}

Future<Account> signIn(String emailAddress, String password) async {
  var currentSession = Account(name: "guest", email: "guest", uuid: "0");

  try {
    // Sign in with Firebase Authentication
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    String name = "", uuid = "0";
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uuid = user.uid;
      var database = FirebaseFirestore.instance;

      // Await the result from Firestore to ensure the name is fetched before continuing
      var docSnapshot = await database.collection("users").doc(uuid).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? content = docSnapshot.data();
        name =
            content?["name"] ??
            "guest"; // Ensure name is safely fetched, default to "guest"
      }
    }

    // Update currentSession with fetched data
    currentSession = Account(name: name, email: emailAddress, uuid: uuid);
  } on FirebaseAuthException catch (e) {
    getMessageFromErrorCodeAuth(e);
    return currentSession;
  }

  return currentSession;
}

Future<bool> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } on FirebaseAuthException catch (e) {
    getMessageFromErrorCodeAuth(e);
    return false;
  }
  return true;
}

Future<bool> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    getMessageFromErrorCodeAuth(e);
    return false;
  }
  return true;
}
