import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/controller/contact_controller.dart';
import 'package:flutter_exam/firebase_options.dart';
import 'package:flutter_exam/screens/auth/sign_in.dart';
import 'package:flutter_exam/services/auth_services.dart';
import 'package:get/get.dart';

import 'screens/home_page.dart';

var contactController = Get.put(ContactController());

// ASC DESC
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: AuthServices.authServices.getCurrentUser() != null ? HomePage() : SignInPage(),
    );
  }
}
