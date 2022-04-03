import 'package:flutter/material.dart';
import 'package:prashantclinic/addPatient.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prashantclinic/medicinedetails.dart';
import 'package:prashantclinic/patientdetails.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:prashantclinic/registeredpatients.dart';
import 'package:prashantclinic/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Prescription App",
      theme: ThemeData(
        primaryColor: Colors.cyanAccent,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/logo.png'),
        nextScreen: HomeView(),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.cyanAccent,
        duration: 3000,
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Choose Option"),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 26.0),
            child: SingleChildScrollView(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 200),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => addPatient()));
                      },
                      child: Text(
                        "New Patient",
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyanAccent,
                          onPrimary: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 200),
                    child: ElevatedButton(
                      child: Text("Patient Records"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => patientdetails()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyanAccent,
                          onPrimary: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 200),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => medicinedetails()));
                      },
                      child: Text(
                        "Add Medicine",
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyanAccent,
                          onPrimary: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 200),
                    child: ElevatedButton(
                      child: Text("Settings"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Settings()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyanAccent,
                          onPrimary: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 300, height: 200),
                    child: ElevatedButton(
                      child: Text("Registered Patients"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RegisteredPatients()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyanAccent,
                          onPrimary: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                    ),
                  ),
                ],
              ),
            ))));
  }
}
