import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_web/provider/main_provider.dart';
import 'package:test_web/screens/auth/login_screen.dart';
import 'package:test_web/screens/home/home_screen.dart';
import 'package:test_web/utilites/constants.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCSt4U9Cn7hlV7WVEK2uKgN2_EuydofS7M",
        authDomain: "testweb-5bb8e.firebaseapp.com",
        databaseURL: "https://testweb-5bb8e-default-rtdb.firebaseio.com",
        projectId: "testweb-5bb8e",
        storageBucket: "testweb-5bb8e.appspot.com",
        messagingSenderId: "807453431526",
        appId: "1:807453431526:web:b9d450e3724e58388e4d27",
        measurementId: "G-95NYM8R87H"),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ChangeNotifierProvider<MainProvider>(
      create: (context) => MainProvider(),
      builder: (context, child) => MaterialApp(
        title: "test",
        theme: ThemeData(
          splashColor: kMainColor,
          unselectedWidgetColor: kSecondaryColor,
          accentColor: kMainColor,
          scaffoldBackgroundColor: kMainColor,
          fontFamily: "Poppins",
          primaryColor: const Color(0xff1D2D61),
        ),
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
