import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          currentUserEmail = user.email;
        });
      }
    });
  }

  void deleteNotification(String notificationId) {
    FirebaseFirestore.instance
        .collection('Notifications')
        .doc(notificationId)
        .delete();
  }

  void deleteAllNotifications(List<DocumentSnapshot> notifications) {
    for (var notification in notifications) {
      deleteNotification(notification.id);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (currentUserEmail != null) {
                FirebaseFirestore.instance
                    .collection('Notifications')
                    .where('assignedEmail', isEqualTo: currentUserEmail)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  deleteAllNotifications(querySnapshot.docs);
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          waveUp(),
          Positioned.fill(
            top: 100,
            bottom: 100,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: currentUserEmail != null
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Notifications')
                          .where('assignedEmail', isEqualTo: currentUserEmail)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView(
                          children: snapshot.data!.docs.map((document) {
                            Timestamp timestamp = document['timestamp'];
                            DateTime notificationDate = timestamp.toDate();
                            String formattedDate =
                                "${notificationDate.day}.${notificationDate.month}.${notificationDate.year} ${notificationDate.hour}:${notificationDate.minute}";

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(document['title']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(document['body']),
                                    const SizedBox(height: 4),
                                    Text(
                                      ' $formattedDate',
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    deleteNotification(document.id);
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          waveDown(),
        ],
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
            height: 100,
            width: 50,
          )));
}

Positioned waveDown() {
  return Positioned(
      bottom: 0,
      child: Opacity(
          opacity: 0.1,
          child: SvgPicture.asset(
            "assets/images/wave-grey_down.svg",
            height: 100,
            width: 100,
          )));
}
