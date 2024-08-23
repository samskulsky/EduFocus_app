import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String userId;
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  List<String>? sharedWith;

  Note({
    required this.userId,
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.sharedWith,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      sharedWith: json['sharedWith'] != null
          ? List<String>.from(json['sharedWith'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sharedWith': sharedWith,
    };
  }
}

Stream<List<Note>> getNotes(String userId) {
  return FirebaseFirestore.instance
      .collection('notes')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
}

void addNote(Note note) {
  FirebaseFirestore.instance
      .collection('notes')
      .doc(note.id)
      .set(note.toJson());
}

void updateNote(Note note) {
  FirebaseFirestore.instance
      .collection('notes')
      .doc(note.id)
      .update(note.toJson());
}

void deleteNote(String id) {
  FirebaseFirestore.instance.collection('notes').doc(id).delete();
}

Future<Note> getNoteById(String id) async {
  final doc =
      await FirebaseFirestore.instance.collection('notes').doc(id).get();
  return Note.fromJson(doc.data()!);
}

Stream<Note> noteStream(String id) {
  return FirebaseFirestore.instance
      .collection('notes')
      .doc(id)
      .snapshots()
      .map((doc) => Note.fromJson(doc.data()!));
}
