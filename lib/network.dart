import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/pages/placeholder.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

List<AnnouncementData> _announcements = [];
List<(String, bool)> _classes = [];
List<String> _classeslookup = [];
Future<bool> firebaseInit() async {
  //receive announcements and classes here
  //initialise account, get public and personal announcements, and classes
  //TODO: remove classes when not in classes collection
  account =
      createAccount(); //TODO: remove after setting account in firebaseinit

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    var database = FirebaseFirestore.instance;
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
        _announcements.add(data);
      }
    });
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
            _announcements.add(data);
          }
        });
    //${sec4/3/2/1} ${g3/g2/g1} ${class name}
    await database.collection("classes").doc("sec4").get().then((item) {
      Map<String, dynamic>? content = item.data();
      _classeslookup = content!.keys.toList();
      // for (var minidoc in item) {
      //   print(minidoc.id);
      //   database
      //       .collection("classes")
      //       .doc("sec4")
      //       .collection(minidoc.id)
      //       .get()
      //       .then((event) {
      //         for (var content in event.docs) {
      //           _classeslookup.add(content.id);
      //           print(content.id);
      //         }
      //       });
      // }
    });
    await database
        .collection("users")
        .doc(account.uuid)
        .collection("classes")
        .get()
        .then((item) {
          for (var minidoc in item.docs) {
            Map<String, dynamic> content = minidoc.data();
            _classes.add((minidoc.id, content["isselected"]));
          }
        });
    for (var currentclass in _classeslookup) {
      if (!_classes.contains((currentclass, false)) &&
          !_classes.contains((currentclass, true))) {
        _classes.add((currentclass, false));
      }
    }
    for (var currentclass in _classes) {
      if (!_classeslookup.contains(currentclass.$1)) {
        _classes.remove(currentclass);
        database
            .collection("users")
            .doc(account.uuid)
            .collection("classes")
            .doc(currentclass.$1)
            .delete();
      }
    }
  } on FirebaseException catch (e) {
    // Caught an exception from Firebase.
    print("Failed with error '${e.code}': ${e.message}");
    switch (e.code) {
      default:
    }
    return false;
  }

  return true;
}

Future<bool> sendAnnouncementToServer(
  AnnouncementData data,
  bool isPublic,
) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
    print("Failed with error '${e.code}': ${e.message}");
    switch (e.code) {
      default:
    }
    return false;
  }
  return true;
}

List<AnnouncementData>? receiveAnnouncementFromServer() {
  //return the announcement received from init here
  return _announcements; //getAnnouncementsPlaceholder(); //TODO placeholder
}

Future<bool> deleteAnnouncementFromServer(AnnouncementData data) async {
  try {
    var database = FirebaseFirestore.instance;
    if (data.isPublic()) {
      database.collection("announcements").doc(data.getChecksum()).delete();
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
    // Caught an exception from Firebase.
    print("Failed with error '${e.code}': ${e.message}");
    switch (e.code) {
      default:
    }
    return false;
  }
  return true;
}

Future<bool> completeAnnouncementInServer(data) async {
  //completion is personal a.k.a synced to each uuid, NOT public class.
  try {
    var database = FirebaseFirestore.instance;
    final file = database
        .collection("users")
        .doc(account.uuid)
        .collection("completed")
        .doc(data.getChecksum());

    file.update({"isCompleted": true});
  } on FirebaseException catch (e) {
    // Caught an exception from Firebase.
    print("Failed with error '${e.code}': ${e.message}");
    switch (e.code) {
      default:
    }
    return false;
  }
  return true;
}

Future<bool> changeSelectedClassesInServer(
  String classes,
  bool selected,
) async {
  try {
    var database = FirebaseFirestore.instance;
    final file = database
        .collection("users")
        .doc(account.uuid)
        .collection("classes")
        .doc(classes);
    file.set({"isselected": selected});
  } on FirebaseException catch (e) {
    // Caught an exception from Firebase.
    print("Failed with error '${e.code}': ${e.message}");
    switch (e.code) {
      default:
    }
    return false;
  }
  return true;
}

List<(String, bool)> receiveClassesFromServer() {
  //return the classes received from init here
  return _classes;
  //return getClassesPlaceholder();
}
