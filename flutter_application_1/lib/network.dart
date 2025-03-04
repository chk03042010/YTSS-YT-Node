import 'package:flutter_application_1/pages/placeholder.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/util.dart';

Future<bool> firebaseInit() async {
  //receive announcements and classes here
  //initialise account, get public and personal announcements, and classes
  return true;
}

Future<bool> sendAnnouncementToServer(data, isPublic) async {
  //data.setId(...)
  return true;
}

List<AnnouncementData>? receiveAnnouncementFromServer() {
  //return the announcement received from init here
  return getAnnouncementsPlaceholder(); //TODO placeholder
}

Future<bool> deleteAnnouncementFromServer(data) async {
  return true;
}

Future<bool> completeAnnouncementInServer(data) async {
  //completion is personal a.k.a synced to each uuid, NOT public class.
  return true;
}

Future<bool> changeSelectedClassesInServer(classes) async {
  return true;
}

List<(String, bool)> receiveClassesFromServer(classes) {
  //return the classes received from init here
  return getClassesPlaceholder();
}