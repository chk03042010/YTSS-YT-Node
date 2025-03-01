/// This utility file should not ever import the dart library.
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/network.dart';

class Account {
  String name, email;
  int uuid;

  Account({
    required this.name,
    required this.email,
    required this.uuid
  });
}

void showSnackBar(context, msg) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),  
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ));
}

class DefaultMouseCursor extends WidgetStateMouseCursor {
  const DefaultMouseCursor();
  @override
  MouseCursor resolve(Set<WidgetState> states) {
    return SystemMouseCursors.basic;
  }
  @override
  String get debugDescription => 'DefaultMouseCursor()';
}

Uint8List int32bytes(int value) => Uint8List(4)..buffer.asInt32List()[0] = value;

class AnnouncementData {
  final int _id;

  final int _authorUUID;
  
  String _title, _clazz, _author, _desc;
  DateTime _due;
  bool _isCompleted = false;
  final bool _isPublic;

  late Digest _checksum; //SHA-256

  void _calcChecksum() {
    var b0 = utf8.encode(_title);
    var b1 = utf8.encode(_clazz);
    var b2 = int32bytes(_due.millisecondsSinceEpoch);
    var b3 = utf8.encode(_author);
    var b4 = utf8.encode(_desc);
    var b5 = int32bytes(_authorUUID);

    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);
    input.add(b0);
    input.add(b1);
    input.add(b2);
    input.add(b3);
    input.add(b4);
    input.add(b5);
    input.close();

    _checksum = output.events.single;
  }

  AnnouncementData(String title, String clazz, DateTime due, String author,
                  String description, int authorUUID, bool isPublic) :
      _title = title, _clazz = clazz, _due = due, _author = author,
      _desc = description, _authorUUID = authorUUID, _isPublic = isPublic,
      _id = DateTime.now().microsecondsSinceEpoch {
    _calcChecksum();

    var completed = prefs?.getBool("announcement_completion_$_checksum");
    if (completed != null && completed) {
      _isCompleted = true;
    } else {
      prefs?.setBool("announcement_completion_$_checksum", false);
    }
  }

  void setTitle(String title) { _title = "$title${_isPublic ? "" : " (Personal)"}"; _calcChecksum(); }
  void setClass(String clazz) { _clazz = clazz; _calcChecksum(); }
  void setAuthor(String author) { _author = author; _calcChecksum(); }
  void setDue(DateTime due) { _due = due; _calcChecksum(); }
  void setDesc(String desc) { _desc = desc; _calcChecksum(); }
  Future<bool> complete() async {
    _isCompleted = true;
    await prefs?.setBool("announcement_completion_$_checksum", true);
    return await completeAnnouncementInServer(this);
  }

  int getAuthorUUID() { return _authorUUID; }
  String getTitle() { return _title; }
  String getClass() { return _clazz; }
  String getAuthor() { return _authorUUID == account.uuid ? "You" : _author; }
  String getDue() { return dateFormatDateTime(_due); }
  String getDesc() { return _desc; }
  bool isCompleted() { return _isCompleted; }
  bool isPublic() { return _isPublic; }

  int getDaysToDue() {
    return _due.difference(DateTime.now()).inDays;
  }

  String getChecksum() {
    return "$_checksum";
  }
  
  int getId() {
    return _id;
  }

  @override
  int get hashCode {
    return ByteData.sublistView(Uint8List.fromList(_checksum.bytes)).getInt32(0);
  }

  static int sortFunction(AnnouncementData a, AnnouncementData b) {
    if (a.isCompleted() && !b.isCompleted()) {
      return 1;
    } else if (!a.isCompleted() && b.isCompleted()) {
      return -1;
    }

    return a._due.millisecondsSinceEpoch - b._due.millisecondsSinceEpoch;
  }
  
  @override
  bool operator == (Object other) {
    if (other is! AnnouncementData) {
      return false;
    }

    return getChecksum() == other.getChecksum();
  }
}

  // Format the date as month abbreviation + day
String dateFormatDateTime(DateTime pickedDate) {
  // TODO: lang
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

  return "${monthNames[pickedDate.month - 1]} ${pickedDate.day}";
}