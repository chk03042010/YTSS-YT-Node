import 'package:flutter_application_1/pages/placeholder.dart';
import 'package:flutter_application_1/util.dart';

Future<bool> firebaseInit() async {
  //receive announcements and classes here
  return true;
}

Future<bool> sendAnnouncementToServer(data, isPublic) async {
  
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
  return true;
}

Future<bool> changeSelectedClassesInServer(classes) async {
  return true;
}

List<(String, bool)> receiveClassesFromServer(classes) {
  //return the classes received from init here
  return getClassesPlaceholder();
}