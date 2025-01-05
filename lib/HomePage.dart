import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> items = [];
  String dropdownValue = 'Pants';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  Map<int, bool> selectedItems = {}; 

  
  Future<void> fetchData([String? query]) async {
    final response = await http.post(
      Uri.parse('http://localhost/maryam/search.php'),
      body: {'query': query ?? ''},
    );
    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
        selectedItems.clear();
        for (int i = 0; i < items.length; i++) {
          selectedItems[i] = false;
        }
      });
    } else {
      print('Failed to load data');
    }
  }


  Future<void> addItem(String name, String dropdownValue) async {
    final response = await http.post(
      Uri.parse('http://localhost/maryam/add.php'),
      body: {'name': name, 'dropdown': dropdownValue},
    );
    if (response.statusCode == 200) {
      fetchData();
    } else {
      print('Failed to add item');
    }
  }


  Future<void> deleteSelectedItems() async {
    final List<String> idsToDelete = [];
    selectedItems.forEach((index, isSelected) {
      if (isSelected) {
        idsToDelete.add(items[index]['id']);
      }
    });

    if (idsToDelete.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://localhost/maryam/delete.php'),
        body: {'ids': json.encode(idsToDelete)},
      );
      if (response.statusCode == 200) {
        fetchData();
      } else {
        print('Failed to delete items');
      }
    } else {
      print('No items selected for deletion');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Final Project')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => fetchData(value),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Item',
              ),
            ),
          ),
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['Pants', 'Jacket', 'Shirt']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    addItem(nameController.text, dropdownValue);
                    nameController.clear();
                  },
                  child: Text('Add Item'),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    deleteSelectedItems();
                  },
                  child: Text('Delete Selected'),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: selectedItems[index],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedItems[index] = value!;
                        });
                      },
                    ),
                    title: Text(items[index]['name']),
                    subtitle: Text(items[index]['dropdown']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
