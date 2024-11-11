import 'package:aqarat_apps/start_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.setLanguageCode('ar');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',  // مسار البداية
      routes: {
        '/startpage': (context) => const StartPage(),  // صفحة البداية بعد تسجيل الخروج
        // أضف مسارات أخرى حسب الحاجة
      },
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}
