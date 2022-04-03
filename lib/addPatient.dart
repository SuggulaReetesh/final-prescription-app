import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:prashantclinic/addvitals.dart';

class addPatient extends StatefulWidget {
  DocumentSnapshot doctoEdit;
  addPatient({this.doctoEdit});
  @override
  _addPatientState createState() => _addPatientState();
}

class _addPatientState extends State<addPatient> {
  TextEditingController regno = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController patientname =  TextEditingController();
  TextEditingController patientmiddlename =  TextEditingController();
  TextEditingController patientlastname =  TextEditingController();
  TextEditingController age = TextEditingController();
  String dropdownvalue = 'InPerson';
  //TextEditingController pov = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  TextEditingController consultationby = TextEditingController();
  bool malegender = false;
  bool femalegender = false;
  bool othergender = false;
  String gendername = " ";
  var receipts = [];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if(widget.doctoEdit!=null)
    setState(() {
          patientname.text = widget.doctoEdit["name"];
          phoneno.text = widget.doctoEdit["phone"];
        });
  }

  CollectionReference ref =
      FirebaseFirestore.instance.collection('patientdetails');
  CollectionReference regids =
      FirebaseFirestore.instance.collection('RegistrationId');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add patient"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: patientname,
                maxLength: 15,
                decoration: InputDecoration(hintText: "First Name"),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Patient Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: patientmiddlename,
                maxLength: 10,
                decoration: InputDecoration(hintText: "Middle Name"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: patientlastname,
                maxLength: 10,
                decoration: InputDecoration(hintText: "Last Name"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: age,
                decoration: InputDecoration(hintText: "Age"),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Age is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              buildgender(),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: phoneno,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(hintText: "Phone number"),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButton<String>(
                value: dropdownvalue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownvalue = newValue;
                  });
                },
                items: <String>['InPerson', 'Practo', 'Telephone','Video call']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),
              // TextField(
              //   controller: pov,
              //   maxLines: 2,
              //   maxLength: 50,
              //   decoration: InputDecoration(hintText: "Purpose of visit"),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      List<String> splitList = patientname.text.split(' ');
                      List<String> indexList = [];
                      for (int i = 0; i < splitList.length; i++) {
                        for (int j = 0; j < splitList[i].length + i; j++) {
                          indexList
                              .add(splitList[i].substring(0, j).toLowerCase());
                        }
                      }
                      indexList.add(patientname.text);
                      var user = {
                        'regno': regno.text,
                        'appointdate': date.text,
                        'patientname': patientname.text,
                        'patientmiddlename':patientmiddlename.text,
                        'patientlastname':patientlastname.text,
                        'age': age.text,
                        'gender': gendername,
                        'phoneno': phoneno.text,
                        'consultationby': dropdownvalue,
                        //'purpose': "",
                        'BP': "",
                        'searchIndex': indexList,
                        'Weight': "",
                        //'BMI': "",
                        'temp': "",
                        'spo2': "",
                        'p': "",
                        'rtpcr': "",
                        'receipts': receipts
                      };
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => addvitals(user: user)));
                    }
                  },
                  child: Text("Continue"))
            ],
          ),
        ));
  }

  getregno() async {
    await FirebaseFirestore.instance
        .collection('RegistrationId')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        regno.text = doc['id'].toString();
        //print(doc['id']);
      });
      date.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
    });
  }

  Widget buildgender() {
    return Row(
      children: [
        Text("Male"),
        Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.cyanAccent,
          value: malegender,
          onChanged: (bool value) {
            setState(() {
              malegender = value;
              gendername = value ? 'Male' : " ";
              femalegender = false;
              othergender = false;
            });
          },
        ),
        Text("Female"),
        Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.cyanAccent,
          value: femalegender,
          onChanged: (bool value) {
            setState(() {
              femalegender = value;
              gendername = value ? 'Female' : " ";
              malegender = false;
              othergender = false;
            });
          },
        ),
        Text("Others"),
        Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.cyanAccent,
          value: othergender,
          onChanged: (bool value) {
            setState(() {
              othergender = value;
              gendername = value ? 'Other' : " ";
              malegender = false;
              femalegender = false;
            });
          },
        ),
      ],
    );
  }
}
