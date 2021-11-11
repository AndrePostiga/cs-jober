import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grupolaranja20212/Models/Task.dart';

class TodoListPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: [
            Expanded(child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Enter Task Name"),
            )),
            TextButton(
              child: const Text(
                "Add Task",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                _addTask();
              },
            )
          ],
        ),


        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("todos").snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const LinearProgressIndicator();

            return Expanded(child: _buildList(snapshot.requireData));
          },
        ),


      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: _buildBody(context),
    );
  }

  void _addTask() {
    FirebaseFirestore.instance.collection("todos")
        .add({"title": _controller.text});

    _controller.text = "";

  }

  Widget _buildList(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return ListView.builder(
      itemCount:  snapshot.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        final task = Task.fromSnapshot(doc);
        return _buildListItem(task);
      },
    );
  }

  Widget _buildListItem(Task task) {
    return Dismissible(
      key: Key(task.taskId.toString()),
      onDismissed: (direction) {
        _deleteTask(task);
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title: Text(task.tittle),
      ),
    );
  }

  void _deleteTask(Task task) async {
    await FirebaseFirestore.instance.collection("todos")
        .doc(task.taskId)
        .delete();
  }
}
