import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/add_todo.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'ToDo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        onPressed: navigateAddForm,
        label: const Row(
          children: [Text('Add ToDo')],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: items.isEmpty
              ? const Center(
                  child: Text(
                    'Empty ToDo',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    final title = item['title'];
                    final description = item['description'];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        color: Colors.white24,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(title),
                          subtitle: Text(description),
                          trailing: PopupMenuButton(itemBuilder: (_) {
                            return [
                              PopupMenuItem(
                                onTap: () {
                                  navigateEditForm(item);
                                },
                                child: const Text('Edit'),
                              ),
                              PopupMenuItem(
                                child: const Text('Delete'),
                                onTap: () {
                                  deleteData(item['_id'].toString());
                                },
                              ),
                            ];
                          }),
                        ),
                      ),
                    );
                  }),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    const uri = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {
      showMessage('can\'t fetch data', Colors.red);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteData(String id) async {
    final uri = 'https://api.nstack.in/v1/todos/$id';
    final url = Uri.parse(uri);
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
      showMessage('Delete data successfully', Colors.green);
    } else {
      showMessage('Delete data failed', Colors.red);
    }
  }

  void showMessage(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> navigateAddForm() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodo());

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });

    fetchTodo();
  }

  void navigateEditForm(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddTodo(
              todo: item,
            ));

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });

    fetchTodo();
  }
}
