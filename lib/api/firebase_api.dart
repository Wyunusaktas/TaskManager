import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');
    saveTokenToDatabase(fcmToken);
  }

  Future<void> saveTokenToDatabase(String? token) async {
    if (token != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final email = user.email;
        await _firestore.collection('Tokens').doc(token).set({
          'token': token,
          'email': email,
        });
      }
    }
  }

  Future<void> updateUserEmail(String newEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final tokenSnapshot = await _firestore
          .collection('Tokens')
          .where('email', isEqualTo: user.email)
          .get();
      for (var doc in tokenSnapshot.docs) {
        await doc.reference.update({'email': newEmail});
      }
    }
  }

  performFirebaseOperations() {}
}
