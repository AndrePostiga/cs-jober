import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String tittle;
  final String? taskId;

  Task(this.tittle, [this.taskId]);

  factory Task.fromSnapshot(DocumentSnapshot snapshot){
    return Task(
      snapshot.get("title"),
      snapshot.id,
    );
  }
}