import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'editPatient.dart';

class patientdetails extends StatefulWidget {
  @override
  _patientdetailsState createState() => _patientdetailsState();
}

class _patientdetailsState extends State<patientdetails> {
  TextEditingController search = TextEditingController();
  String searchString;
  bool order = true;

  @override
  void initState(){
    super.initState();
    //printalluserdetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Search Patients")),
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                  onChanged: (val) {
                    setState(() {
                      searchString = val;
                    });
                  },
                  controller: search,
                  decoration: InputDecoration(
                      hintText: "Search patient",
                      suffixIcon: IconButton(
                        onPressed: () {
                          search.clear();
                          setState(() {
                            order = !order;
                          });
                        },
                        icon: Icon(Icons.filter_list),
                      )))),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: (searchString == null || searchString.trim() == '')
                    ? FirebaseFirestore.instance
                        .collection('patientdetails1')
                        .orderBy("regno", descending: order)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection(
                            'patientdetails1') //.orderBy("regno", descending: true)
                        .where('searchIndex', arrayContains: searchString)
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
                                            builder: (_) => editPatient(
                                                  doctoEdit: doc,
                                                )));
                                  },
                                  child: Card(
                                    child: ListTile(
                                      subtitle: Text('Reg No : ' +
                                          doc['regno'].toString()),
                                      title: Text('Patient Name: ' +
                                          doc['patientname']),
                                    ),
                                  )))
                              .toList());
                  }
                  // if (snapshot.hasData) {
                  //   final List<DocumentSnapshot> documents = snapshot.data.docs;
                  //   return ListView(
                  //       children: documents
                  //           .map((doc) => GestureDetector(
                  //               onTap: () {
                  //                 Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (_) => editPatient(
                  //                               doctoEdit: doc,
                  //                             )));
                  //               },
                  //               child: Card(
                  //                 child: ListTile(
                  //                   subtitle: Text('Reg No : ' + doc['regno']),
                  //                   title: Text(
                  //                       'Patient Name: ' + doc['patientname']),
                  //                 ),
                  //               )))
                  //           .toList());
                  // } else if (snapshot.hasError) {
                  //   return Text('Its Error!');
                  // } else {
                  //   return Text("No Data");
                  // }
                }),
          )
        ]));
  }

  printalluserdetails() async{
    await FirebaseFirestore.instance.collection('patientdetails1').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
       // updaterecords(doc.id);
        var tempreceipts =[];
         tempreceipts = doc["receipts"];
        var tempappointdate = doc["appointdate"];
        for(var i=0;i<tempreceipts.length;i++){
          tempreceipts[i].addAll({'receiptdate': tempappointdate});
        }  
        FirebaseFirestore.instance.collection('patientdetails1').doc(doc.id).update({"receipts":tempreceipts});
       
        //print(doc['id']);
        
      });
    });

  }

  updaterecords(String id) async{
    await  FirebaseFirestore.instance.collection('patientdetails1').doc(id).set({'patientlastname': ''}, SetOptions(merge: true)).whenComplete((){
      print("its done");
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
