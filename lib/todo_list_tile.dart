import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:todo_app/main.dart';

class TodoListTile extends StatefulWidget {
  const TodoListTile({Key? key, required this.items}) : super(key: key);
  final List<PanelItemModel> items;

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all(8),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.items[index].isExpanded = isExpanded;
        });
      },
      children: widget.items.map<ExpansionPanel>((PanelItemModel item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Container(
                width: 100,
                child: Row(
                  children: [
                    // Add your delete icon here
                    SizedBox(width: 8), // Adjust spacing as needed
                    Checkbox(
                      value: item.completed,
                      onChanged: (bool? value) async {
                        item.completed = !item.completed;
                        await updateItemInDatabase(item);
                        setState(() {
                          item.completed = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              title: Container(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.title),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        var id = item.id;
                        final response = await http.delete(
                            Uri.parse('http://10.0.2.2:8080/api/todos/$id'),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            });
                        if (response.statusCode != 200) {
                          throw Exception(
                              '========================Failed to update data===================');
                        }
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          body: ListTile(
            title: Container(child: Text(item.description ?? "  ")),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Future<void> updateItemInDatabase(PanelItemModel item) async {
    Map<String, dynamic> dataToUpdate = {
      'completed': item.completed,
    };

    // Convert the data to JSON
    String jsonData = jsonEncode(dataToUpdate);

    // Make the PUT request
    var id = item.id;
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8080/api/todos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );
    if (response.statusCode != 200) {
      throw Exception(
          '========================Failed to update data===================');
    }
  }
}
