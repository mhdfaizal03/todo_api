import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/main.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descreptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['description'];
      titleController.text = title;
      descreptionController.text = desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text(
          isEdit ? 'edit ToDo' : 'add ToDo',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: titleController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: 'ToDo here',
                  hintStyle: TextStyle(color: whiteFadeColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: descreptionController,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 10,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: 'Descreption here',
                  hintStyle: TextStyle(color: whiteFadeColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white12),
                      elevation: MaterialStatePropertyAll(4)),
                  onPressed: isEdit ? updateData : submitData,
                  child: Text(isEdit ? 'Update' : 'Submit'))
            ],
          ),
        ),
      ),
    );
  }

  void submitData() async {
    final title = titleController.text;
    final desc = descreptionController.text;
    final body = {
      "title": title,
      "description": desc,
      "is_completed": false,
    };
    const uri = 'https://api.nstack.in/v1/todos';
    final url = Uri.parse(uri);
    final response = await http.post(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 201) {
      showMessage('ToDo Created', Colors.green);
      print(response);
      titleController.clear();
      descreptionController.clear();
    } else {
      showMessage('Create failed', Colors.red);
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you cannot update without todo data');
      return;
    }
    final id = todo['_id'];
    // final isCompleted = todo['is_completed'];
    final title = titleController.text;
    final desc = descreptionController.text;
    final body = {
      "title": title,
      "description": desc,
      "is_completed": false,
    };
    final uri = 'https://api.nstack.in/v1/todos/$id';
    final url = Uri.parse(uri);
    final response = await http.put(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      showMessage('ToDo Updated', Colors.green);
      print(response);
    } else {
      showMessage('Update failed', Colors.red);
    }
  }

  void showMessage(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
