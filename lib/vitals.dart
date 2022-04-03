import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prashantclinic/patientdetails.dart';

class Vitals extends StatefulWidget {
  DocumentSnapshot doctoEdit;
  Vitals({this.doctoEdit});
  @override
  _VitalsState createState() => _VitalsState();
}

class _VitalsState extends State<Vitals> {
  TextEditingController bp = TextEditingController();
  TextEditingController wt = TextEditingController();
  //TextEditingController bmi = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController spo2 = TextEditingController();
  TextEditingController p = TextEditingController();
  TextEditingController rtpcr = TextEditingController();
  CollectionReference ref =
      FirebaseFirestore.instance.collection('patientdetails');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add vital details"),
        actions: [
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                widget.doctoEdit.reference.update({
                  'BP': bp.text,
                  'Weight': wt.text,
                  //'BMI': bmi.text,
                  'temp': temp.text,
                  'spo2': spo2.text,
                  'p': p.text,
                  'rtpcr': rtpcr.text
                }).whenComplete(() {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => patientdetails()));
                });
              },
              child: Text('SAVE'))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: bp,
            decoration: InputDecoration(hintText: "Blood Pressure"),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: wt,
            decoration: InputDecoration(hintText: "Weight"),
          ),
          SizedBox(
            height: 10,
          ),
          // TextField(
          //   controller: bmi,
          //   keyboardType: TextInputType.number,
          //   decoration: InputDecoration(hintText: "Body Mass Index"),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          TextField(
            controller: temp,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Temperature"),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: spo2,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "SPO2"),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: p,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "PR"),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: rtpcr,
            decoration: InputDecoration(hintText: "Rt-pcr"),
          )
        ],
      ),
    );
  }
}
