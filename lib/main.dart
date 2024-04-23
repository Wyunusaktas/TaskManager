import 'package:etkinlikuygulamasi/api/firebase_api.dart';
import 'package:etkinlikuygulamasi/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();
  runApp(ProviderScope(child: EtkinlikHome()));
}

class EtkinlikHome extends StatefulWidget {
  const EtkinlikHome({super.key});

  @override
  State<EtkinlikHome> createState() => _EtkinlikHomeState();
}

class _EtkinlikHomeState extends State<EtkinlikHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
