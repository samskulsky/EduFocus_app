// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../screens/home.dart';
import '../setup/setup.dart';

class AppUser {
  String uid;
  String phoneNumber;
  String firstName;
  String lastName;
  String? email;
  String? fcmToken;
  DateTime createdAt;
  DateTime updatedAt;
  String schoolType; // middle, high, college
  String role;
  List<Course>? courses;
  List<RecurringScheduleItem>? scheduleItems;
  List<DailyUsageItem>? dailyUsage;
  List<Day>? days;

  AppUser({
    required this.uid,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.email,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
    required this.schoolType,
    required this.role,
    this.courses,
    this.scheduleItems,
    this.dailyUsage,
    this.days,
  });

  AppUser.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        phoneNumber = map['phoneNumber'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        email = map['email'],
        fcmToken = map['fcmToken'],
        createdAt = map['createdAt'].toDate(),
        updatedAt = map['updatedAt'].toDate(),
        schoolType = map['schoolType'],
        role = map['role'],
        courses = // if courses is null, return null, else map each course
            map['courses'] == null
                ? null
                : List<Course>.from(
                    map['courses'].map((x) => Course.fromMap(x))),
        scheduleItems = // if scheduleItems is null, return null, else map each schedule item
            map['scheduleItems'] == null
                ? null
                : List<RecurringScheduleItem>.from(map['scheduleItems']
                    .map((x) => RecurringScheduleItem.fromMap(x))),
        dailyUsage = // if dailyUsage is null, return null, else map each daily usage item
            map['dailyUsage'] == null
                ? null
                : List<DailyUsageItem>.from(
                    map['dailyUsage'].map((x) => DailyUsageItem.fromMap(x))),
        days = // if days is null, return null, else map each day
            map['days'] == null
                ? null
                : List<Day>.from(map['days'].map((x) => Day.fromMap(x)));

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'schoolType': schoolType,
      'role': role,
      'courses': courses?.map((x) => x.toMap()).toList(),
      'scheduleItems': scheduleItems?.map((x) => x.toMap()).toList(),
      'dailyUsage': dailyUsage?.map((x) => x.toMap()).toList(),
      'days': days?.map((x) => x.toMap()).toList(),
    };
  }
}

class Day {
  DateTime date;
  String dayName;

  Day({
    required this.date,
    required this.dayName,
  });

  Day.fromMap(Map<String, dynamic> map)
      : date = map['date'].toDate(),
        dayName = map['dayName'];

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'dayName': dayName,
    };
  }
}

class DailyUsageItem {
  DateTime date;
  num points;

  DailyUsageItem({
    required this.date,
    required this.points,
  });

  DailyUsageItem.fromMap(Map<String, dynamic> map)
      : date = map['date'].toDate(),
        points = map['points'];

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'points': points,
    };
  }
}

class RecurringScheduleItem {
  String id;
  String? courseId;
  String name;
  List<String> days;
  DateTime startTime;
  DateTime endTime;

  RecurringScheduleItem({
    required this.id,
    this.courseId,
    required this.name,
    required this.days,
    required this.startTime,
    required this.endTime,
  });

  RecurringScheduleItem.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        courseId = map['courseId'],
        name = map['name'],
        days = List<String>.from(map['days']),
        startTime = map['startTime'].toDate(),
        endTime = map['endTime'].toDate();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'name': name,
      'days': days,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class Course {
  String id;
  String name;
  List<String> attributes;
  DateTime startDate;
  DateTime endDate;
  String icon;
  String color;

  Course({
    required this.id,
    required this.name,
    required this.attributes,
    required this.startDate,
    required this.endDate,
    required this.icon,
    required this.color,
  });

  Course.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        attributes = // if attributes is null, return empty list, else map each attribute
            map['attributes'] == null
                ? []
                : List<String>.from(map['attributes']),
        startDate = map['startDate'].toDate(),
        endDate = map['endDate'].toDate(),
        icon = map['icon'],
        color = map['color'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'icon': icon,
      'color': color,
    };
  }
}

Future<void> setupFlow(String uid) async {
  bool exists = await userExists(uid);

  if (!exists) {
    Get.offAll(() => const SetupPage());
  } else {
    Get.offAll(() => const HomeScreen());
  }
}

Future<bool> userExists(String uid) async {
  if (uid.isEmpty) return false;
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return doc.exists;
}

Future<void> createUser(AppUser appUser) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(appUser.uid)
      .set(appUser.toMap());
}

Future<void> updateUser(AppUser appUser) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(appUser.uid)
      .update(appUser.toMap());
}

Stream<AppUser> userStream(String uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((doc) => AppUser.fromMap(doc.data()!));
}

Future<void> addCourse(String uid, Course course) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({
        'courses': FieldValue.arrayUnion([course.toMap()])
      })
      .then((value) => print('Course added'))
      .catchError((error) => print('Failed to add course: $error'));
}

Future<void> deleteCourse(String uid, Course course) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({
        'courses': FieldValue.arrayRemove([course.toMap()])
      })
      .then((value) => print('Course deleted'))
      .catchError((error) => print('Failed to delete course: $error'));
}

Future<void> updateCourse(AppUser appUser, Course course) async {
  int index = appUser.courses!.indexWhere((c) => c.id == course.id);
  appUser.courses![index] = course;

  updateUser(appUser);
}
