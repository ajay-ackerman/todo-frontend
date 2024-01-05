import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:todo_app/main.dart';

class TodoListTile extends StatefulWidget {
  const TodoListTile({super.key, required this.items});
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
                      onChanged: (bool? value) {
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
                      onPressed: () {
                        // Handle delete action here
                        // You might want to remove the item from the list or perform other actions.
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
}
