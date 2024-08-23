import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String userId;
  String id;
  String type; // 'assignment', 'quiz', 'exam'
  String status; // 'completed', 'incomplete'
  String title;
  String description;
  DateTime dueDate;
  DateTime createdAt;
  DateTime reminder;
  String courseId;
  List<String> attachments;
  List<StudyPlanItem>? studyPlan;

  Todo({
    required this.userId,
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.createdAt,
    required this.reminder,
    required this.courseId,
    required this.attachments,
    this.studyPlan,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      type: json['type'],
      status: json['status'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      createdAt: DateTime.parse(json['createdAt']),
      reminder: DateTime.parse(json['reminder']),
      courseId: json['courseId'],
      attachments: List<String>.from(json['attachments']),
      studyPlan: json['studyPlan'] != null
          ? (json['studyPlan'] as List)
              .map((item) => StudyPlanItem.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'type': type,
      'status': status,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'reminder': reminder.toIso8601String(),
      'courseId': courseId,
      'attachments': attachments,
      'studyPlan': studyPlan?.map((item) => item.toJson()).toList(),
    };
  }
}

class StudyPlanItem {
  DateTime dueDate;
  int length;

  StudyPlanItem({
    required this.dueDate,
    required this.length,
  });

  Map<String, dynamic> toJson() {
    return {
      'dueDate': dueDate,
      'length': length,
    };
  }

  factory StudyPlanItem.fromJson(Map<String, dynamic> json) {
    return StudyPlanItem(
      dueDate: json['dueDate'].toDate(),
      length: json['length'],
    );
  }
}

Stream<List<Todo>> getTodos(String userId) {
  return FirebaseFirestore.instance
      .collection('todos')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
    // sort todos by due date
    var todos = snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    // only return todos that are not completed
    todos = todos.where((todo) => todo.status != 'completed').toList();
    return todos;
  });
}

Future<void> completeTodo(String userId, String todoId) {
  return FirebaseFirestore.instance
      .collection('todos')
      .doc(todoId)
      .update({'status': 'completed'});
}

Future<void> deleteTodo(String userId, String todoId) {
  return FirebaseFirestore.instance.collection('todos').doc(todoId).delete();
}

Future<void> addTodo(Todo todo) {
  return FirebaseFirestore.instance
      .collection('todos')
      .doc(todo.id)
      .set(todo.toJson());
}

Future<void> updateTodo(Todo todo) {
  return FirebaseFirestore.instance
      .collection('todos')
      .doc(todo.id)
      .update(todo.toJson());
}
