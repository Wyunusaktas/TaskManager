import 'package:etkinlikuygulamasi/screens/LoginScreen.dart';
import 'package:etkinlikuygulamasi/screens/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlikuygulamasi/screens/add_screen.dart';
import 'package:etkinlikuygulamasi/screens/edit_screen.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProjectListScreen(),
    );
  }
}

class ProjectListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('projects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          double centerLeft = MediaQuery.of(context).size.width / 2 - 34;
          double centerTop = MediaQuery.of(context).size.height * 0.11;

          return Stack(
            children: [
              Positioned(
                left: centerLeft,
                top: centerTop,
                child: Text(
                  "Task List",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(top: 120.0, bottom: 1),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Title: ${data['title']}'),
                            const Divider(),
                            Text('Category: ${data['category']}'),
                            const Divider(),
                            Text('Status: ${data['status']}'),
                            const Divider(),
                            Text(
                                'Assigned Date: ${data['assignedDate'].toDate()}'),
                            const Divider(),
                            Text('Importance: ${data['importance']}'),
                            const Divider(),
                            Text('Progress: ${data['progress']}'),
                            const Divider(),
                            Text('Assigned To: ${data['assignedTo']}'),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProjectScreen(
                                          documentId: document.id,
                                          title: data['title'],
                                          category: data['category'],
                                          status: data['status'],
                                          assignedDate:
                                              data['assignedDate'].toDate(),
                                          importance: data['importance'],
                                          progress: data['progress'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Edit'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Project'),
                                          content: const Text(
                                              'Are you sure you want to delete this project?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('projects')
                                                    .doc(document.id)
                                                    .delete()
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                }).catchError((error) {
                                                  print(
                                                      'Failed to delete project: $error');
                                                });
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 18,
                left: 16,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.14,
                  height: MediaQuery.of(context).size.width * 0.14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.notifications,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 18,
                right: MediaQuery.of(context).size.width * 0.44,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.14,
                  height: MediaQuery.of(context).size.width * 0.14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProjectScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 18,
                right: 16,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.14,
                  height: MediaQuery.of(context).size.width * 0.14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon:
                        Icon(Icons.exit_to_app, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Opacity(
                  opacity: 0.7,
                  child: SvgPicture.asset(
                    "assets/images/wave_purple_up.svg",
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
