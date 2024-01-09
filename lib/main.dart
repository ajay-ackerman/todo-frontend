import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/add_task.dart';
import 'package:todo_app/todo_list_tile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isChecked = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(child: MyExpansionPanel()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the AddTaskScreen and wait for a result (new task).

          List<String>? res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          );
          print(res);
          print('-------------------------------------------------');
          String? newTask = res?[0], newDesc = res?[1];
          // Handle the new task (if any) returned from the AddTaskScreen.
          if (newTask != null) {
            addNew(newTask, newDesc);
          }
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addNew(String newTask, String? newDesc) async {
    print(
        "===================================================================================================================================================in addNew methon===========================================================================================================================================");
    Map<String, dynamic> dataToUpdate = {
      'title': newTask,
      'description': newDesc,
      'completed': false
    };

    // Convert the data to JSON
    String jsonData = jsonEncode(dataToUpdate);
    final response = await http
        .post(Uri.parse('http://10.0.2.2:8080/api/todos'), body: jsonData);

    if (response.statusCode != 200) {
      throw Exception(
          '========================Failed to create task===================');
    }
  }
}

class MyExpansionPanel extends StatefulWidget {
  @override
  _MyExpansionPanelState createState() => _MyExpansionPanelState();
}

class _MyExpansionPanelState extends State<MyExpansionPanel> {
  Future<List<PanelItemModel>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/api/todos'));
    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print(data.toString() + "===================================");
      return data.map((item) {
        return PanelItemModel(
            item['id'], item['title'], item['description'], item['completed']);
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        // snapshot.connectionState == ConnectionState.done ||
        if (snapshot.hasData) {
          List<PanelItemModel> items = snapshot.data as List<PanelItemModel>;
          return SingleChildScrollView(child: TodoListTile(items: items));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  // saving final state
}

class PanelItemModel {
  final int id;
  final String title;
  final String? description;
  bool isExpanded;
  bool completed;

  PanelItemModel(this.id, this.title, this.description, this.completed,
      {this.isExpanded = false});
}
