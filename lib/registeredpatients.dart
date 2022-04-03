import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addPatient.dart';
import 'editPatient.dart';

class RegisteredPatients extends StatefulWidget {
  @override
  _RegisteredPatientsState createState() => _RegisteredPatientsState();
}

class _RegisteredPatientsState extends State<RegisteredPatients> {
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool order = true;
    return Scaffold(
        appBar: AppBar(title: Text("Registered Patients")),
        body: Column(children: <Widget>[
          ElevatedButton(
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2050))
                  .then((selecteddate) {
                setState(() {
                  date =
                      DateFormat("yyyy-MM-dd").format(selecteddate).toString();
                });
              });
            },
            child: Text(date),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('PatientData')
                    .where("appointdate", isEqualTo: date)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('We got error an error ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Loading");
                    case ConnectionState.none:
                      return Text("Oops No data Present");
                    case ConnectionState.done:
                      return Text("We are done !");

                    default:
                      return new ListView(
                          children: snapshot.data.docs
                              .map((doc) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => addPatient(
                                                  doctoEdit: doc,
                                                )));
                                  },
                                  child: 
                                  Card(
                                    child: ExpansionTile(
                                      title: Text(
                                        'Patient Name: ' +
                                            doc['name']
                                                .toString()
                                                .toUpperCase(),
                                      ),
                                      children: [
                                        Table(
                                          //defaultColumnWidth: FixedColumnWidth(10.0),
                                          border: TableBorder.all(
                                              color: Colors.black,
                                              style: BorderStyle.solid,
                                              width: 2),
                                          children: [
                                            TableRow(children: [
                                              Column(children: [
                                                Text(
                                                  'Appointment Date',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ]),
                                              Column(children: [
                                                Text(doc['appointdate']
                                                    .toString())
                                              ]),
                                            ]),
                                            TableRow(children: [
                                              Column(children: [
                                                Text('Appointment Time', style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                              ]),
                                              Column(children: [
                                                Text(doc['timing'].toString())
                                              ]),
                                            ]),
                                            TableRow(children: [
                                              Column(children: [
                                                Text('Consultation Mode', style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                              ]),
                                              Column(children: [
                                                Text(doc['consultation']
                                                    .toString())
                                              ]),
                                            ]),
                                            TableRow(children: [
                                              Column(children: [
                                                Text('Consultation Type', style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                              ]),
                                              Column(children: [
                                                Text(doc['consultationtype']
                                                    .toString())
                                              ]),
                                            ]),
                                            TableRow(children: [
                                              Column(children: [
                                                Text('Appointment Fee', style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                              ]),
                                              Column(children: [
                                                Text(doc['consultationfee']
                                                    ?.toString())
                                              ]),
                                            ]),
                                            TableRow(children: [
                                              Column(children: [
                                                Text('Mobile Number', style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                              ]),
                                              Column(children: [
                                                Text(doc['phone'].toString())
                                              ]),
                                            ]),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        TextButton(onPressed: (){
                                           Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => addPatient(
                                                  doctoEdit: doc,
                                                )));
                                        }, child: Text("Diagnose Patient"))
                                      ],
                                    ),
                                    
                                    // child: ListTile(
                                    //   subtitle: Text('Date: ' +
                                    //       doc['appointdate'].toString() +
                                    //       "   " +
                                    //       "Phone: " +
                                    //       doc['phone'].toString() +
                                    //       "   " +
                                    //       'Timing: ' +
                                    //       doc['timing'].toString()),
                                    //   title:
                                    //       Text('Patient Name: ' + doc['name']),
                                    // ),
                                  )))
                              .toList());
                  }
                }),
          )
        ]));
  }
}
