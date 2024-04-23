import 'package:etkinlikuygulamasi/screens/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

class EditProjectScreen extends StatefulWidget {
  final String documentId;
  final String title;
  final String category;
  final String status;
  final DateTime assignedDate;
  final String importance;
  final int progress;

  EditProjectScreen({
    required this.documentId,
    required this.title,
    required this.category,
    required this.status,
    required this.assignedDate,
    required this.importance,
    required this.progress,
  });

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController assignedDateController = TextEditingController();
  final TextEditingController importanceController = TextEditingController();
  final TextEditingController progressController = TextEditingController();
  DateTime _assignedDate = DateTime.now();
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    categoryController.text = widget.category;
    statusController.text = widget.status;
    assignedDateController.text = widget.assignedDate.toString();
    importanceController.text = widget.importance.toString();
    progressController.text = widget.progress.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            waveUp(),
            const Text(
              "Edit Task",
              style: TextStyle(fontSize: 15),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2),
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60.0),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      TextField(
                        controller: categoryController,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      DropdownButtonFormField<String>(
                        value: statusController.text,
                        onChanged: (String? value) {
                          setState(() {
                            statusController.text = value!;
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
                        value: importanceController.text,
                        onChanged: (String? value) {
                          setState(() {
                            importanceController.text = value!;
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
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'Select Assigned Date: ${_assignedDate.toString().substring(0, 10)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('projects')
                              .doc(widget.documentId)
                              .update({
                            'title': titleController.text,
                            'category': categoryController.text,
                            'status': statusController.text,
                            'assignedDate': _assignedDate,
                            'importance': importanceController.text,
                            'progress': _progress.toInt(),
                          }).then((value) {
                            Navigator.pop(context); // Ana sayfaya geri dön
                          }).catchError((error) {
                            print('Failed to update project: $error');
                          });
                        },
                        child: const Text('Save'),
                      ),
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
          ], // children
        ), //
      ),
    );
  }
}

Positioned waveUp() {
  return Positioned(
    top: 0,
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

Positioned waveDown() {
  return Positioned(
    bottom: 0,
    child: Opacity(
      opacity: 0.1,
      child: SvgPicture.asset(
        "assets/images/wave-grey_down.svg",
        height: 120,
        width: 100,
      ),
    ),
  );
}
