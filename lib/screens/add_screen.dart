import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:etkinlikuygulamasi/screens/main_page.dart';

void main() {
  runApp(AddScreen());
}

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: AddProjectScreen(),
    );
  }
}

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _assignedToController =
      TextEditingController(); // Yeni input alanı için controller
  String _status = 'In Progress';
  double _progress = 0;
  String _importance = 'Normal';
  DateTime _assignedDate = DateTime.now();

  void _addProject() {
    FirebaseFirestore.instance
        .collection('projects')
        .doc(_titleController.text)
        .set({
      'title': _titleController.text,
      'category': _categoryController.text,
      'status': _status,
      'progress': _progress.toInt(),
      'importance': _importance,
      'assignedDate': _assignedDate,
      'assignedTo': _assignedToController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project added successfully')),
      );
      _titleController.clear();
      _categoryController.clear();
      _assignedToController.clear();
      setState(() {
        _status = 'In Progress';
        _progress = 0;
        _importance = 'Normal';
        _assignedDate = DateTime.now();
      });
      _sendNotification(_assignedToController.text); // Bildirim gönder
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add project: $error')),
      );
    });
  }

  void _sendNotification(String recipient) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            waveUp(),
            const Text(
              "Add Task",
              style: TextStyle(fontSize: 15),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2),
                ),
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30.0),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      TextField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      TextField(
                        controller: _assignedToController,
                        decoration: InputDecoration(
                          labelText: 'Assign To',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      DropdownButtonFormField<String>(
                        value: _status,
                        onChanged: (String? value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                        items: <String>[
                          'Not Started',
                          'In Progress',
                          'Completed'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          const Text('Progress:'),
                          Expanded(
                            child: Slider(
                              value: _progress,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: _progress.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _progress = value;
                                });
                              },
                            ),
                          ),
                          Text('$_progress%'),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      DropdownButton<String>(
                        value: _importance,
                        onChanged: (String? value) {
                          setState(() {
                            _importance = value!;
                          });
                        },
                        items: <String>['Normal', 'Important', 'Very Important']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: const Text('Importance'),
                        style: const TextStyle(color: Colors.black),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                      ),
                      const SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: _assignedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              setState(() {
                                _assignedDate = selectedDate;
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: Text(
                          'Select Assigned Date: ${_assignedDate.toString().substring(0, 10)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _addProject,
                        child: const Text('Add'),
                      ),
                      const SizedBox(height: 50.0),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      ));
                },
                icon: (const Icon(Icons.arrow_back))),
            waveDown(),
          ],
        ),
      ),
    );
  }
}

Container waveUp() {
  return Container(
    alignment: Alignment.topCenter,
    child: Opacity(
      opacity: 0.7,
      child: SvgPicture.asset(
        "assets/images/wave_purple_up.svg",
        height: 150,
        width: 100,
      ),
    ),
  );
}

Container waveDown() {
  return Container(
    alignment: Alignment.bottomCenter,
    child: Opacity(
      opacity: 0.1,
      child: SvgPicture.asset(
        "assets/images/wave-grey_down.svg",
        height: 100,
        width: 100,
      ),
    ),
  );
}
