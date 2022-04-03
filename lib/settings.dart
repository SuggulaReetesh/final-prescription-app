import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String selectedstarttime = "12:00 AM";
  String selectedendtime = "12:00 AM";
  var timeslotsdata = [];
  TextEditingController fee = new TextEditingController();
  TextEditingController reports = new TextEditingController();
  CollectionReference allslots = FirebaseFirestore.instance.collection('slots');
  var currentfee =
      FirebaseFirestore.instance.collection('Consultationfee').doc('fee');
  bool enablefeebutton = true;
  String feeupdatestatus = " ";
  DateTime selectedDate = DateTime.now();

  String _selectedDate = '';
  var _dateCount = [];
  String _range = '';
  String _rangeCount = '';
  //bool isSwitched = false;
  bool istimeslotSwitched = false;
  var temptimeslots = [];
  var suggestiontimeslots = [];
  var tests = []; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettimeslots();
    currentfee.get().then((value) => {fee.text = value.data()['fee']});
    getpresenttimeslots(temptimeslots);
    getreports();
  }

  Future<void> selectstarttime(BuildContext context) async {
    final TimeOfDay t =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null) {
      setState(() {
        selectedstarttime = t.format(context);
      });
    }
  }

  Future<void> selectendtime(BuildContext context) async {
    final TimeOfDay t =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null) {
      setState(() {
        selectedendtime = t.format(context);
      });
    }
  }

  Future<void> selectdate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2060),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
    getselecteddayslots(DateFormat('yyyy-MM-dd')
        .parse(selectedDate.toString())
        .toString()
        .substring(0, 10));
  }

  // void toggleSwitch(bool value) {
  //   if (isSwitched == false) {
  //     setState(() {
  //       isSwitched = true;
  //     });
  //   } else {
  //     setState(() {
  //       isSwitched = false;
  //     });
  //   }
  // }

  void toggletimeslotSwitch(bool value) {
    if (istimeslotSwitched == false) {
      setState(() {
        istimeslotSwitched = true;
        temptimeslots = suggestiontimeslots;
      });
    } else {
      setState(() {
        istimeslotSwitched = false;
        temptimeslots = [];
      });
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value;
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('settings'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Card(
                  child: ExpansionTile(
                title: Text("Consultation fee"),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextField(
                      controller: fee,
                      onChanged: (value) {
                        if (value == "") {
                          setState(() {
                            enablefeebutton = false;
                          });
                        } else {
                          setState(() {
                            enablefeebutton = true;
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(hintText: "Enter Consultation fee"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: enablefeebutton
                        ? () {
                            currentfee
                                .update({'fee': fee.text.toString()})
                                .then((_) => setState(() {
                                      feeupdatestatus =
                                          "fee updated successfully";
                                    }))
                                .catchError((_) => setState(() {
                                      feeupdatestatus =
                                          "fee is not updated. try again";
                                    }));
                          }
                        : null,
                    child: Text("Update Fee"),
                  ),
                  Text(
                    '$feeupdatestatus',
                    style: TextStyle(color: Colors.green),
                  )
                ],
              )),
              SizedBox(
                height: 10,
              ),
              Card(
                child: ExpansionTile(
                  title: Text("Add Slots"),
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          children: [
                            Text("select single or multiple dates"),
                            // Switch(
                            //   onChanged: toggleSwitch,
                            //   value: isSwitched,
                            // ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: SfDateRangePicker(
                          backgroundColor: Colors.blue[50],
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode:
                              //isSwitched?
                              DateRangePickerSelectionMode.multiple
                          //: DateRangePickerSelectionMode.single,
                          // initialSelectedRange: PickerDateRange(
                          //     DateTime.now().subtract(const Duration(days: 4)),
                          //     DateTime.now().add(const Duration(days: 3))),
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Row(
                          children: [
                            Text("Time slot suggestions"),
                            Switch(
                              onChanged: toggletimeslotSwitch,
                              value: istimeslotSwitched,
                            ),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Start:"),
                        RawMaterialButton(
                          fillColor: Colors.blue,
                          onPressed: () {
                            selectstarttime(context);
                          },
                          child: Text(
                            selectedstarttime,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text("End:"),
                        RawMaterialButton(
                          fillColor: Colors.blue,
                          onPressed: () {
                            selectendtime(context);
                          },
                          child: Text(
                            selectedendtime,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: ElevatedButton(
                        child: Text("Add TimeSlot"),
                        onPressed: () {
                          var newtimeslot = {
                            "timing": selectedstarttime + "-" + selectedendtime,
                            "enabled": true
                          };
                          setState(() {
                            temptimeslots.add(newtimeslot);
                          });
                          // allslots
                          //     .doc('timings')
                          //     .update({"slot": timeslotsdata}).whenComplete(
                          //         () => gettimeslots());

                          // getpresenttimeslots(newtimeslot);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: temptimeslots
                          .map((e) => Card(
                                  child: ListTile(
                                trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        temptimeslots
                                            .removeAt(temptimeslots.indexOf(e));
                                      });
                                    }),
                                title: Text(e["timing"]),
                              )))
                          .toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    (temptimeslots.length > 0 && _dateCount.length > 0)
                        ? ElevatedButton(
                            child: Text("Save"),
                            onPressed: () {
                              // if (!isSwitched) {
                              //   FirebaseFirestore.instance
                              //       .collection('presentslots')
                              //       .doc(DateFormat('yyyy-MM-dd')
                              //           .parse(_selectedDate.toString())
                              //           .toString()
                              //           .substring(0, 10))
                              //       .get()
                              //       .then((DocumentSnapshot documentSnapshot) {
                              //     if (documentSnapshot.exists) {
                              //       timeslotsdata =
                              //           documentSnapshot.data()["slot"];
                              //       timeslotsdata..addAll(temptimeslots);
                              //       FirebaseFirestore.instance
                              //           .collection('presentslots')
                              //           .doc(DateFormat('yyyy-MM-dd')
                              //               .parse(_selectedDate.toString())
                              //               .toString()
                              //               .substring(0, 10))
                              //           .update({"slot": timeslotsdata});
                              //     } else {
                              //       FirebaseFirestore.instance
                              //           .collection('presentslots')
                              //           .doc(DateFormat('yyyy-MM-dd')
                              //               .parse(_selectedDate.toString())
                              //               .toString()
                              //               .substring(0, 10))
                              //           .set({"slot": temptimeslots});
                              //     }
                              //   });
                              // } else {
                              for (var i = 0; i < _dateCount.length; i++) {
                                FirebaseFirestore.instance
                                    .collection('presentslots')
                                    .doc(DateFormat('yyyy-MM-dd')
                                        .parse(_dateCount[i].toString())
                                        .toString()
                                        .substring(0, 10))
                                    .get()
                                    .then((DocumentSnapshot documentSnapshot) {
                                  if (documentSnapshot.exists) {
                                    timeslotsdata =
                                        documentSnapshot.data()["slot"];
                                    timeslotsdata..addAll(temptimeslots);
                                    FirebaseFirestore.instance
                                        .collection('presentslots')
                                        .doc(DateFormat('yyyy-MM-dd')
                                            .parse(_dateCount[i].toString())
                                            .toString()
                                            .substring(0, 10))
                                        .update({"slot": timeslotsdata});
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection('presentslots')
                                        .doc(DateFormat('yyyy-MM-dd')
                                            .parse(_dateCount[i].toString())
                                            .toString()
                                            .substring(0, 10))
                                        .set({"slot": temptimeslots});
                                  }

                                  // allslots.doc('timings').update({
                                  //   "slot": timeslotsdata
                                  // }).whenComplete(() => gettimeslots());
                                  getpresenttimeslots(temptimeslots);
                                }).whenComplete(() {
                                  setState(() {
                                    temptimeslots = [];
                                  });
                                });
                              }
                            })
                        : Container()
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: ExpansionTile(
                  title: Text("Manage Slots"),
                  children: [
                    RawMaterialButton(
                      fillColor: Colors.blue,
                      onPressed: () {
                        selectdate(context);
                      },
                      child: Text(
                        DateFormat('yyyy-MM-dd')
                            .parse(selectedDate.toString())
                            .toString()
                            .substring(0, 10),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: timeslotsdata
                          .map((e) => Card(
                                  // child: SwitchListTile(
                                  child: ListTile(
                                // controlAffinity:
                                //     ListTileControlAffinity.leading,
                                //secondary: IconButton(
                                trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      timeslotsdata
                                          .removeAt(timeslotsdata.indexOf(e));
                                      FirebaseFirestore.instance
                                          .collection('presentslots')
                                          .doc(DateFormat('yyyy-MM-dd')
                                              .parse(selectedDate.toString())
                                              .toString()
                                              .substring(0, 10))
                                          .update({
                                        "slot": timeslotsdata
                                      }).whenComplete(() => gettimeslots());
                                      // allslots.doc('timings').update({
                                      //   "slot": timeslotsdata
                                      // }).whenComplete(() => gettimeslots());
                                    }),
                                // value: e["enabled"],
                                // onChanged: (bool value) {
                                //   if (value == false) {
                                //     disabletimeslots(e);
                                //   }
                                //   setState(() {
                                //     e["enabled"] = value;
                                //   });
                                // allslots.doc('timings').update({
                                //   "slot": timeslotsdata
                                // }).whenComplete(() => gettimeslots());
                                //},
                                title: Text(e["timing"].toString()),
                              )))
                          .toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: ExpansionTile(
                  title: Text("Reports"),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Reports added here will be displayed in website"),
                    ),
                     Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                      controller: reports,
                      decoration: InputDecoration(
                          hintText: "Enter Report Available at Clinic"),
                    ),),
                    TextButton(
                        onPressed: () {
                          tests.add(reports.text);
                          setState(() {
                            tests = tests;
                          });
                          FirebaseFirestore.instance
                              .collection('tests')
                              .doc('reports')
                              .update({"tests": tests}).then((value) {
                            getreports();
                          });
                          reports.clear();
                        },
                        child: Text("Add Report")),
                    ListView(
                      shrinkWrap: true,
                      children: tests
                          .map((e) => Card(
                                  child: ListTile(
                                trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      tests.removeAt(tests.indexOf(e));
                                      setState(() {
                                        tests = tests;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('tests')
                                          .doc('reports')
                                          .update({
                                        "tests": tests
                                      }).whenComplete(() => getreports());
                                    }),
                                title: Text(e.toString()),
                              )))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  getpresenttimeslots(List temptimeslots) async {
    //List<dynamic> markers = [];
    var tempdata = [];
    // await FirebaseFirestore.instance
    //     .collection('presentslots')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) => {
    //           querySnapshot.docs.forEach((doc) => {
    //                 tempdata = doc.data()["slot"],
    //                 tempdata.add(newtimeslot),
    //                 FirebaseFirestore.instance
    //                     .collection('presentslots')
    //                     .doc(doc.id)
    //                     .update({"slot": tempdata}),
    //               })
    //         });
    //print("maarelr");
    //print( markers);
    await FirebaseFirestore.instance
        .collection('slots')
        .doc("timings")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        tempdata = documentSnapshot.data()["slot"];
        tempdata..addAll(temptimeslots);
        final jsonList = tempdata.map((item) => jsonEncode(item)).toList();
        final uniqueJsonList = jsonList.toSet().toList();
        final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
        FirebaseFirestore.instance
            .collection('slots')
            .doc("timings")
            .update({"slot": result});
      }
      //print(timeslotsdata);
    });
  }

  gettimeslots() async {
    await FirebaseFirestore.instance
        .collection('slots')
        .doc("timings")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        suggestiontimeslots = documentSnapshot.data()["slot"];
      }
      setState(() {
        suggestiontimeslots = suggestiontimeslots;
      });
      //print(timeslotsdata);
    });
  }

  disabletimeslots(e) async {
    var tempdata = [];
    await FirebaseFirestore.instance
        .collection('presentslots')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.asMap().forEach((index, doc) => {
                    tempdata = doc.data()["slot"],
                    //tempdata.add(newtimeslot),
                    for (var i = 0; i < tempdata.length; i++)
                      {
                        //print(tempdata[i]['timing'].toString()),
                        //print(e['timing'].toString()),
                        if (tempdata[i]['timing'].toString() ==
                            e['timing'].toString())
                          {tempdata[i]['enabled'] = false}
                      },
                    //print(tempdata),
                    FirebaseFirestore.instance
                        .collection('presentslots')
                        .doc(doc.id)
                        .update({"slot": tempdata}),
                  })
            });
  }

  getreports() async {
    await FirebaseFirestore.instance
        .collection('tests')
        .doc('reports')
        .get()
        .then((value) {
      if (value.exists) {
        tests = value.data()["tests"];
      } else {
        FirebaseFirestore.instance
            .collection('tests')
            .doc('reports')
            .set({"tests": []});
      }
      setState(() {
        tests = tests;
      });
    });
  }

  getselecteddayslots(String parse) async {
    FirebaseFirestore.instance
        .collection('presentslots')
        .doc(parse)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        timeslotsdata = documentSnapshot.data()["slot"];
        setState(() {
          timeslotsdata = timeslotsdata;
        });
      } else {
        FirebaseFirestore.instance
            .collection('presentslots')
            .doc(parse.toString())
            .set({"slot": []});
      }
    });
  }
}
