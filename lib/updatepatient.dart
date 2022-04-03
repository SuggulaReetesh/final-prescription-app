import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prashantclinic/patientdetails.dart';

class updatePatient extends StatefulWidget {
  DocumentSnapshot doctoEdit;
  updatePatient({this.doctoEdit});
  @override
  _updatePatientState createState() => _updatePatientState();
}

class _updatePatientState extends State<updatePatient> {
  TextEditingController regno = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController patientname = TextEditingController();
  TextEditingController patientmiddlename = TextEditingController();
  TextEditingController patientlastname = TextEditingController();
  TextEditingController age = TextEditingController();
  String dropdownvalue = 'InPerson';
  //TextEditingController pov = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  TextEditingController consultationby = TextEditingController();
  bool malegender = false;
  bool femalegender = false;
  bool othergender = false;
  String gendername = " ";
  @override
  void initState() {
    regno.text = widget.doctoEdit['regno'].toString();
    date.text = widget.doctoEdit['appointdate'];
    patientname.text = widget.doctoEdit['patientname'];
    patientmiddlename.text = widget.doctoEdit['patientmiddlename'];
    patientlastname.text = widget.doctoEdit['patientlastname'];
    age.text = widget.doctoEdit['age'];
    phoneno.text = widget.doctoEdit['phoneno'];
    dropdownvalue = widget.doctoEdit['consultationby'];
    //pov.text = widget.doctoEdit['purpose'];
    if (gendername == 'MALE') {
      malegender = true;
    }
    if (gendername == 'FEMALE') {
      femalegender = true;
    }
    if (gendername == 'OTHER') {
      othergender = true;
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  CollectionReference ref =
      FirebaseFirestore.instance.collection('patientdetails');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add patient"),
          actions: [
            TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
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

                    widget.doctoEdit.reference.update({
                      'regno': regno.text,
                      'appointdate': date.text,
                      'patientname': patientname.text,
                      'patientmiddlename':patientmiddlename.text,
                      'patientlastname':patientlastname.text,
                      'age': age.text,
                      'gender': gendername,
                      'phoneno': phoneno.text,
                      'consultationby': dropdownvalue,
                      'searchIndex': indexList
                      //'purpose': pov.text,
                    }).whenComplete(() {
                      //Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => patientdetails()));
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => patientdetails()),
                      //     (Route<dynamic> route) => false);
                    });
                  }
                },
                child: Text('UPDATE'))
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Text("Reg No: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Flexible(
                      child: TextField(
                    controller: regno,
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: "Registration Number",
                        border: InputBorder.none),
                  ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Appointment Date : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Flexible(
                    child: TextField(
                      controller: date,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: "Registration Date",
                          border: InputBorder.none),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: patientname,
                maxLength: 15,
                decoration: InputDecoration(hintText: "Patient Name"),
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
                decoration: InputDecoration(hintText: "Patient Middle Name"),
                maxLength: 10,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: patientlastname,
                decoration: InputDecoration(hintText: "Patient Last Name"),
                maxLength: 10,
                
              ),
              SizedBox(height: 10,),
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
                items: <String>['InPerson', 'Practo', 'Telephone']
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
            ],
          ),
        ));
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
