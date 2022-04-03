import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prashantclinic/patientdetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'mobile.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class clinical extends StatefulWidget {
  DocumentSnapshot doctoEdit;
  int index;
  clinical({this.doctoEdit,this.index});
  @override
  _clinicalState createState() => _clinicalState();
}

class _clinicalState extends State<clinical> {
  Future<void> showmedidialog(BuildContext context, int index, e) async {
    dmedicinename.text = medicines[index]["medicinename"];
    dmedicinetype.text = medicines[index]["medicinetype"];
    dmedicineusage.text = medicines[index]["medicineusage"];
    dmorning = medicines[index]["morning"];
    dafternoon = medicines[index]["afternoon"];
    dnight = medicines[index]["night"];
    dmornqua.text = medicines[index]["morningqua"].toString();
    dafterqua.text = medicines[index]["afterqua"].toString();
    dnightqua.text = medicines[index]["nightqua"].toString();
    dtotalqua.text = medicines[index]["totalqua"].toString();

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text("Edit medicines"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      medicines[index]["medicinename"] = dmedicinename.text;
                      medicines[index]["medicinetype"] = dmedicinetype.text;
                      medicines[index]["medicineusage"] = dmedicineusage.text;
                      medicines[index]["morning"] = dmorning;
                      medicines[index]["afternoon"] = dafternoon;
                      medicines[index]["night"] = dnight;
                      medicines[index]["morningqua"] = dmornqua.text;
                      medicines[index]["afterqua"] = dafterqua.text;
                      medicines[index]["nightqua"] = dnightqua.text;
                      medicines[index]["totalqua"] = dtotalqua.text;

                      Navigator.pop(context);
                    },
                    child: Text("Update"),
                  ),
                ],
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: dmedicinename,
                        decoration: InputDecoration(hintText: "Medicine"),
                      ),
                      TextField(
                        controller: dmedicinetype,
                        decoration: InputDecoration(hintText: "Medicine Type"),
                      ),
                      TextField(
                        controller: dmedicineusage,
                        decoration: InputDecoration(hintText: "Medicine Usage"),
                      ),
                      Row(
                        children: [
                          Text("Morning"),
                          Checkbox(
                            checkColor: Colors.black,
                            activeColor: Colors.cyanAccent,
                            value: dmorning,
                            onChanged: (bool value) {
                              setState(() {
                                dmorning = value;
                                if (dmorning == false) {
                                  dmornqua.clear();
                                }
                              });
                            },
                          ),
                          Visibility(
                            visible: dmorning,
                            child: Flexible(
                                child: TextField(
                              controller: dmornqua,
                              decoration: InputDecoration(hintText: "Quantity"),
                            )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Afternoon"),
                          Checkbox(
                            checkColor: Colors.black,
                            activeColor: Colors.cyanAccent,
                            value: dafternoon,
                            onChanged: (bool value) {
                              setState(() {
                                dafternoon = value;
                                if (dafternoon == false) {
                                  dafterqua.clear();
                                }
                              });
                            },
                          ),
                          Visibility(
                            visible: dafternoon,
                            child: Flexible(
                                child: TextField(
                              controller: dafterqua,
                              decoration: InputDecoration(hintText: "Quantity"),
                            )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Night"),
                          Checkbox(
                            checkColor: Colors.black,
                            activeColor: Colors.cyanAccent,
                            value: dnight,
                            onChanged: (bool value) {
                              setState(() {
                                dnight = value;
                                if (dnight == false) {
                                  dnightqua.clear();
                                }
                              });
                            },
                          ),
                          Visibility(
                            visible: dnight,
                            child: Flexible(
                                child: TextField(
                              controller: dnightqua,
                              decoration: InputDecoration(hintText: "Quantity"),
                            )),
                          ),
                        ],
                      ),
                      Visibility(
                          visible: dnight || dmorning || dafternoon,
                          child: TextField(
                              controller: dtotalqua,
                              decoration:
                                  InputDecoration(hintText: "Total Quantity"))),
                    ],
                  ),
                ));
          });
        });
  }

  TextEditingController clinifeat = TextEditingController();
  TextEditingController medicinename = TextEditingController();
  TextEditingController medicinetype = TextEditingController();
  TextEditingController medicineusage = TextEditingController();

  bool morning = false;
  bool afternoon = false;
  bool night = false;
  TextEditingController mornqua = TextEditingController();
  TextEditingController afterqua = TextEditingController();
  TextEditingController nightqua = TextEditingController();
  TextEditingController totalqua = TextEditingController();
  TextEditingController precadv = TextEditingController();
  //dialog textediting controller
  TextEditingController dmedicinename = TextEditingController();
  TextEditingController dmedicinetype = TextEditingController();
  TextEditingController dmedicineusage = TextEditingController();
  bool dmorning = false;
  bool dafternoon = false;
  bool dnight = false;
  TextEditingController dmornqua = TextEditingController();
  TextEditingController dafterqua = TextEditingController();
  TextEditingController dnightqua = TextEditingController();
  TextEditingController dtotalqua = TextEditingController();
  TextEditingController rtpcr = TextEditingController();
  bool rtpcrcheck = false;
  bool homequaratine = false;
  bool strictbedrest = false;
  TextEditingController days = TextEditingController();

  TextEditingController pov = TextEditingController();
  var receipts = [];
  var medicinesdata1 = [];
  var tabdata1 = [];
  var diseasemedicines = [];
  @override
  void initState() {
    getdiseasemedicines(diseasemedicines);
    getmedicines1(medicinesdata1, tabdata1);

    //pov.text = widget.doctoEdit['purpose'];
    receipts = widget.doctoEdit['receipts'];
    if(widget.index>=0){
      var selectedreceipt = receipts[widget.index];
      pov.text = selectedreceipt["purposeofvisit"];
      precadv.text = selectedreceipt["Precadv"];
      clinifeat.text = selectedreceipt["Clinicalfeatures"];
      medicines = selectedreceipt["medirecodrs"];
      print(selectedreceipt);
    }
    super.initState();
  }

  List<String> sugmedi = ['Paracetmol', 'dolo650'];
  var medicines = [];
  var covidmedi = [
    {
      "medicinename": "teradoxy-ab 100mg",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": true,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "fluvir 75mg",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": true,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "mucaryl 600mg (in 1 glass of water)",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": true,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "rivaright 10mg ",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "eliquis 2.5mg/5mg",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "dexozol-d (before food)",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": true,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "pantofor-d (before food)",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": true,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "elclari 500mg",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": true,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "cheeron",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "letcee",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "lemcee",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "zincovit",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "doxit-sl 100mg",
      "medicinetype": "caps",
      "medicineusage": "",
      "morning": true,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "digihaler 200mcg",
      "medicinetype": " ",
      "medicineusage": "",
      "morning": true,
      "morningqua": "2puff",
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": "2puff",
      "totalqua": 0
    },
    {
      "medicinename": "lupifit",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "montek -lc",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "worthmont lc",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "ALEX-L-SF",
      "medicinetype": "syp",
      "medicineusage": "",
      "morning": true,
      "morningqua": "5ml",
      "afternoon": true,
      "afterqua": "5ml",
      "night": true,
      "nightqua": "5ml",
      "totalqua": 0
    },
    {
      "medicinename": "ALEX-L",
      "medicinetype": "syp",
      "medicineusage": "",
      "morning": true,
      "morningqua": "5ml",
      "afternoon": true,
      "afterqua": "5ml",
      "night": true,
      "nightqua": "5ml",
      "totalqua": 0
    },
    {
      "medicinename": "Vintodox",
      "medicinetype": "syp",
      "medicineusage": "",
      "morning": true,
      "morningqua": "5ml",
      "afternoon": true,
      "afterqua": "5ml",
      "night": true,
      "nightqua": "5ml",
      "totalqua": 0
    },
    {
      "medicinename": "VOPAXA-CV(325mg)",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": true,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "ZEETHRO(500mg)",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "RRRB(10mg)",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "Sisneuro-D",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": true,
      "afterqua": 1,
      "night": false,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "MUCINAC-AB",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": false,
      "morningqua": 1,
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": 1,
      "totalqua": 0
    },
    {
      "medicinename": "Thrive well protein powder(2tsp in milk)",
      "medicinetype": "Tab",
      "medicineusage": "",
      "morning": true,
      "morningqua": "2tsp",
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": "2tsp",
      "totalqua": 0
    },
    {
      "medicinename": "Digihaler-FF(250mcg)",
      "medicinetype": "",
      "medicineusage": "",
      "morning": true,
      "morningqua": "2puff",
      "afternoon": false,
      "afterqua": "",
      "night": true,
      "nightqua": "2puff",
      "totalqua": 0
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clinical Details"),
        actions: [
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                var localreceipt = {
                  'Clinicalfeatures': clinifeat.text,
                  'Precadv': precadv.text,
                  'purposeofvisit': pov.text,
                  'medirecodrs': medicines,
                  'receiptdate': DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
                };
                if(widget.index>=0){
                  receipts[widget.index]=localreceipt;
                }
                else{
                receipts.add(localreceipt);}
                widget.doctoEdit.reference
                    .update({'receipts': receipts}).whenComplete(() {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Do you want to print receipt ?'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  _createPDF();
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => patientdetails()));
                                },
                                child: Text("YES")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => patientdetails()));
                                },
                                child: Text("NO")),
                          ],
                        );
                      });
                });
              },
              child: Text('SAVE')),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            maxLength: 100,
            controller: pov,
            decoration: InputDecoration(hintText: "Purpose of visit"),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Rt-pcr"),
              Checkbox(
                checkColor: Colors.black,
                activeColor: Colors.cyanAccent,
                value: rtpcrcheck,
                onChanged: (bool value) {
                  setState(() {
                    rtpcrcheck = value;
                    if (rtpcrcheck == false) {
                      rtpcr.clear();
                    }
                  });
                },
              ),
              // Visibility(
              //   visible: rtpcrcheck,
              //   child: Flexible(
              //       child: TextField(
              //     controller: rtpcr,
              //     decoration: InputDecoration(hintText: "result"),
              //   )),
              // ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Home quaratine"),
              Checkbox(
                checkColor: Colors.black,
                activeColor: Colors.cyanAccent,
                value: homequaratine,
                onChanged: (bool value) {
                  setState(() {
                    homequaratine = value;
                  });
                  if (homequaratine == true) {
                    precadv.text =
                        precadv.text + ",home quarantine for 14 days";
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Strict Bed Rest"),
              Checkbox(
                checkColor: Colors.black,
                activeColor: Colors.cyanAccent,
                value: strictbedrest,
                onChanged: (bool value) {
                  setState(() {
                    strictbedrest = value;
                  });
                  if (strictbedrest == true) {
                    precadv.text = precadv.text + ",Strict Bed Rest";
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            maxLength: 100,
            controller: clinifeat,
            decoration: InputDecoration(hintText: "Diagnosis"),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            maxLength: 50,
            controller: precadv,
            decoration: InputDecoration(hintText: "Precautions / Advice"),
          ),
          SizedBox(
            height: 10,
          ),
          //dynamicchips(diseasemedicines),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children:
                List<Widget>.generate(diseasemedicines.length, (int index) {
              return ActionChip(
                onPressed: () {
                  medicines = diseasemedicines[index]["medicines"];
                  setState(() {
                    medicines = medicines;
                  });
                },
                label: Text(diseasemedicines[index]["disease"]),
                backgroundColor: Colors.blue,
                elevation: 6.0,
                shadowColor: Colors.grey[60],
                padding: EdgeInsets.all(8.0),
              );
            }),
          ),
          SizedBox(height: 10),
          Column(children: [
            AutoCompleteTextField(
              controller: medicinename,
              clearOnSubmit: false,
              suggestions: medicinesdata1,
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                hintText: "Medicine Name",
              ),
              itemFilter: (item, query) {
                return item.toLowerCase().startsWith(query.toLowerCase());
              },
              itemSorter: (a, b) {
                return a.compareTo(b);
              },
              itemBuilder: (context, item) {
                return Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        item,
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                );
              },
              itemSubmitted: (item) {
                medicinename.text = item;

                medicinetype.text = tabdata1[medicinesdata1.indexOf(item)];
              },
              key: null,
            ),
            SizedBox(height: 10),
            TextField(
              controller: medicinetype,
              decoration: InputDecoration(hintText: "Medicine Type"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: medicineusage,
              decoration: InputDecoration(hintText: "Usage"),
            ),
          ]),
          Column(children: [
            Row(
              children: [
                Text("Morning"),
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.cyanAccent,
                  value: morning,
                  onChanged: (bool value) {
                    setState(() {
                      morning = value;
                      if (morning == false) {
                        mornqua.clear();
                      }
                    });
                  },
                ),
                Visibility(
                  visible: morning,
                  child: Flexible(
                      child: TextField(
                    onChanged: (text) {
                      days.clear();
                    },
                    controller: mornqua,
                    decoration: InputDecoration(hintText: "Quantity"),
                  )),
                ),
              ],
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Column(children: [
            Row(
              children: [
                Text("Afternoon"),
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.cyanAccent,
                  value: afternoon,
                  onChanged: (bool value) {
                    setState(() {
                      afternoon = value;
                      if (afternoon == false) {
                        afterqua.clear();
                      }
                    });
                  },
                ),
                Visibility(
                  visible: afternoon,
                  child: Flexible(
                      child: TextField(
                    onChanged: (text) {
                      days.clear();
                    },
                    controller: afterqua,
                    decoration: InputDecoration(hintText: "Quantity"),
                  )),
                ),
              ],
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Column(children: [
            Row(
              children: [
                Text("Night"),
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.cyanAccent,
                  value: night,
                  onChanged: (bool value) {
                    setState(() {
                      night = value;
                      if (night == false) {
                        nightqua.clear();
                      }
                    });
                  },
                ),
                Visibility(
                  visible: night,
                  child: Flexible(
                      child: TextField(
                    onChanged: (text) {
                      days.clear();
                    },
                    controller: nightqua,
                    decoration: InputDecoration(hintText: "Quantity"),
                  )),
                ),
              ],
            ),
          ]),
          SizedBox(height: 10),
          Row(children: [
            Flexible(
                child: Visibility(
                    visible: night || morning || afternoon,
                    child: TextField(
                      controller: days,
                      onChanged: (text) {
                        var localqua = 0;
                        if (night && double.tryParse(nightqua.text) != null) {
                          localqua += int.parse(nightqua.text);
                        }
                        if (afternoon &&
                            double.tryParse(afterqua.text) != null) {
                          localqua += int.parse(afterqua.text);
                        }
                        if (morning && double.tryParse(mornqua.text) != null) {
                          localqua += int.parse(mornqua.text);
                        }
                        if (double.tryParse(days.text) != null) {
                          totalqua.text =
                              (localqua * int.parse(days.text)).toString();
                        }
                      },
                      decoration: InputDecoration(hintText: "Days"),
                    ))),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Visibility(
                  visible: night || morning || afternoon,
                  child: TextField(
                      controller: totalqua,
                      decoration: InputDecoration(hintText: "Total Quantity"))),
            )
          ]),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  var tabletdetails = {
                    "medicinename": medicinename.text,
                    "medicinetype": medicinetype.text,
                    "morning": morning,
                    "morningqua": mornqua.text,
                    "afternoon": afternoon,
                    "afterqua": afterqua.text,
                    "night": night,
                    "nightqua": nightqua.text,
                    "totalqua": totalqua.text,
                    "medicineusage": medicineusage.text
                  };
                  medicines.add(tabletdetails);
                  medicinename.clear();
                  medicinetype.clear();
                  medicineusage.clear();
                  morning = false;
                  mornqua.clear();
                  afternoon = false;
                  afterqua.clear();
                  night = false;
                  nightqua.clear();
                  totalqua.clear();
                  //print(medicines);
                });
              },
              child: Text("Add Medicine"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.cyanAccent,
                  onPrimary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20))),
          ActionChip(
            onPressed: () {
              setState(() {
                medicines = covidmedi;
              });
            },
            labelPadding: EdgeInsets.all(2.0),
            label: Text(
              "Covid",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blue,
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            padding: EdgeInsets.all(8.0),
          ),
          ListView(
            shrinkWrap: true,
            children: medicines
                .map((e) => InkWell(
                    onTap: () {},
                    child: Card(
                      child: ListTile(
                        onTap: () async {},
                        title: Text(e['medicinename']),
                        leading: IconButton(
                          onPressed: () async {
                            //print(e);
                            var index = medicines.indexOf(e);
                            await showmedidialog(context, index, e);
                            setState(() {
                              medicines = medicines;
                            });
                          },
                          icon: Icon(Icons.edit),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            medicines.remove(e);
                            setState(() {
                              medicines = medicines;
                            });
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    )))
                .toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawImage(PdfBitmap(await _readImageData('mainlogo.jpg')),
        Rect.fromLTWH(0, 0, 60, 110));

    PdfFont font = await getFont(GoogleFonts.playball(fontSize: 40));
    page.graphics.drawString('PRASHANTH CLINIC',
        PdfStandardFont(PdfFontFamily.helvetica, 32, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(90, 10, 500, 70), brush: PdfBrushes.red);
    page.graphics.drawString('Inhale the Charm, Exhale the Char', font,
        bounds: Rect.fromLTWH(110, 45, 350, 70), brush: PdfBrushes.purple);

    page.graphics.drawImage(PdfBitmap(await _readImageData('lungs.png')),
        Rect.fromLTWH(420, 10, 90, 85));

    page.graphics.drawString('Reg No: 70371',
        PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(410, 95, 150, 50));

    page.graphics.drawString('Dr. K. PRASHANTH KUMAR',
        PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(100, 75, 300, 50));
    page.graphics.drawString(' MBBS,MD',
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(300, 78, 300, 50));
    page.graphics.drawString('Pulmonologist & Diabetologist (Fellow in CCEBDM)',
        PdfStandardFont(PdfFontFamily.helvetica, 13.1),
        bounds: Rect.fromLTWH(95, 95, 300, 50),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    page.graphics.drawLine(
        PdfPen(PdfColor(5, 6, 50), width: 1), Offset(0, 120), Offset(700, 120));
    page.graphics.drawLine(
        PdfPen(PdfColor(5, 6, 50), width: 1), Offset(0, 708), Offset(700, 708));

    page.graphics.drawLine(PdfPen(PdfColor(5, 6, 50), width: 1),
        Offset(150, 190), Offset(150, 650));

    page.graphics.drawString('Patient ID:',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 130, page.getClientSize().width, 50));
    page.graphics.drawString(widget.doctoEdit['regno'].toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(85, 130, page.getClientSize().width, 50));

    page.graphics.drawString('Patient Name:',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(150, 130, page.getClientSize().width, 50));
    page.graphics.drawString(widget.doctoEdit['patientname'] +' '+ widget.doctoEdit['patientmiddlename']+' '+widget.doctoEdit['patientlastname'],
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(262, 130, page.getClientSize().width, 50));

    page.graphics.drawString('Consulted Via: ',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 150, page.getClientSize().width, 50));

    page.graphics.drawString(widget.doctoEdit['consultationby'],
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(115, 150, page.getClientSize().width, 50));
    page.graphics.drawString('Age: ',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(200, 150, page.getClientSize().width, 50));
    page.graphics.drawString(
        widget.doctoEdit['age'], PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(240, 150, page.getClientSize().width, 50));

    String getgender(String g) {
      if (g == 'Male') {
        return 'M';
      } else if (g == 'Female') {
        return 'F';
      } else {
        return 'Other';
      }
    }

    page.graphics.drawString('Sex: ',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(280, 150, page.getClientSize().width, 50));
    page.graphics.drawString(getgender(widget.doctoEdit['gender']),
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(315, 150, page.getClientSize().width, 50));

    page.graphics.drawString('Date: ',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(380, 150, page.getClientSize().width, 50));
    page.graphics.drawString( DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(420, 150, page.getClientSize().width, 50));

    page.graphics.drawString('Rx',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(160, 195, page.getClientSize().width, 50));

    page.graphics.drawString('Vitals',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 195, page.getClientSize().width, 50));

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 1);

    PdfGridRow row;
    for (int i = 0; i < medicines.length; i++) {
      String usage = (i + 1).toString() +
          ". " +
          medicines[i]['medicinetype'] +
          " " +
          medicines[i]['medicinename'] + " "+ medicines[i][ 'medicineusage'] +
          " ";
      row = grid.rows.add();
      //row.cells[0].value = medicines[i]['medicinename'];
      if (medicines[i]["morning"]) {
        usage += 'M:' + medicines[i]["morningqua"].toString() + " ";
      }
      // else {
      //   usage += 'M:X ';
      // }
      if (medicines[i]["afternoon"]) {
        usage += "A:" + medicines[i]["afterqua"].toString() + " ";
      }
      // else {
      //   usage += 'A:X ';
      // }
      if (medicines[i]["night"]) {
        usage += "N:" + medicines[i]["nightqua"].toString() + " ";
      }
      // else {
      //   usage += 'N:X ';
      // }
      usage += " " + "Qty:" + medicines[i]['totalqua'].toString();
      row.cells[0].value = usage;
      row.cells[0].style.borders = PdfBorders(
          left: PdfPen(PdfColor(255, 255, 255, 0), width: 1),
          top: PdfPen(PdfColor(255, 255, 255, 0), width: 1),
          bottom: PdfPen(PdfColor(255, 255, 255, 0), width: 1),
          right: PdfPen(PdfColor(255, 255, 255, 0), width: 1));
      //print(medicines[i]);
    }

    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 1, right: 1, top: 1, bottom: 1),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 20),
    );

    //Draw the grid
    grid.draw(page: page, bounds: const Rect.fromLTWH(160, 220, 515, 700));

    page.graphics.drawString('Spo2: ' + widget.doctoEdit['spo2'],
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 220, page.getClientSize().width, 50));
    page.graphics.drawString('PR    : ' + widget.doctoEdit['p'],
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 240, page.getClientSize().width, 50));
    page.graphics.drawString('BP    : ' + widget.doctoEdit['BP'],
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 260, page.getClientSize().width, 50));
    page.graphics.drawString('Wt     : ' + widget.doctoEdit['Weight'],
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 280, page.getClientSize().width, 50));
    if (rtpcrcheck == true) {
      page.graphics.drawString('Rt-pcr: ' + widget.doctoEdit['rtpcr'],
          PdfStandardFont(PdfFontFamily.helvetica, 15),
          bounds: Rect.fromLTWH(0, 300, 145, 50));
    }
    // if (homequaratine == true) {
    //   page.graphics.drawString('home quarantine for 14 days',
    //       PdfStandardFont(PdfFontFamily.helvetica, 15),
    //       bounds: Rect.fromLTWH(0, 320, 145, 50));
    // }
    // if (strictbedrest == true) {
    //   page.graphics.drawString(
    //       'Strict Bed Rest ', PdfStandardFont(PdfFontFamily.helvetica, 15),
    //       bounds: Rect.fromLTWH(0, 360, 145, 50));
    // }

    page.graphics.drawString('Complaints:',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 320, page.getClientSize().width, 50));
    page.graphics.drawString(
        pov.text, PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 340, 145, 140),
        format: PdfStringFormat(wordWrap: PdfWordWrapType.word));

    page.graphics.drawString('Diagnosis:',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 430, page.getClientSize().width, 50));

    page.graphics.drawString(
        clinifeat.text, PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 450, 145, 140),
        format: PdfStringFormat(wordWrap: PdfWordWrapType.word));

    page.graphics.drawString('Investigation: ',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 580, page.getClientSize().width, 50));

    page.graphics.drawString(
        precadv.text, PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 600, 150, 100));

    page.graphics.drawImage(PdfBitmap(await _readImageData('sign.png.png')),
        Rect.fromLTWH(390, 610, 150, 80));

    page.graphics.drawString('Valid for one visit within 7 days',
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(160, page.getClientSize().height - 75, 700, 50),
        brush: PdfBrushes.purple);
    page.graphics.drawString(
        'Plot No. 109, H.No.32-157/1, Sri Sathya Sai Enclave, Old Bowenpally, Secunderabad - 500 009, Ph : 7995894243',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: Rect.fromLTWH(0, page.getClientSize().height - 50,
            page.getClientSize().width, 50),
        brush: PdfBrushes.red);
    page.graphics.drawString(
        'Timings: MON to SAT : 5 pm to 8 pm, SUN : 10 am to 12 pm on Appointment only',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(40, page.getClientSize().height - 35,
            page.getClientSize().width, 50));
    page.graphics.drawString('email : prashanthdc8@gmail.com',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(180, page.getClientSize().height - 22,
            page.getClientSize().width, 50));

    List<int> bytes = document.save();
    document.dispose();
    saveAndLaunchFile(bytes, widget.doctoEdit['patientname'] + '.pdf');
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  getmedicines1(List medicinesdata1, List tabdata1) async {
    await FirebaseFirestore.instance
        .collection('Allmedicines')
        .doc("medicines")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var tempdata = documentSnapshot.data()["items"];
        //print(tempdata);
        if (tempdata.length > 0) {
          for (int i = 0; i < tempdata.length; i++) {
            medicinesdata1.add(tempdata[i]["medicinename"]);
            tabdata1.add(tempdata[i]["medicinetype"]);
          }
        }
      }
      setState(() {
        medicinesdata1 = medicinesdata1;
        tabdata1 = tabdata1;
      });
      //print(medicinesdata1);
    });
  }

  getdiseasemedicines(List diseasemedicines) async {
    await FirebaseFirestore.instance
        .collection('medicinelist')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //print(doc["disease"]);
        //print(doc.data());
        diseasemedicines.add(doc.data());
        setState(() {
          diseasemedicines = diseasemedicines;
        });
      });
    });
  }

  dynamicchips(List diseasemedicines) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List<Widget>.generate(diseasemedicines.length, (int index) {
        return ActionChip(
          onPressed: () {},
          label: Text(diseasemedicines[index]["disease"]),
        );
      }),
    );
  }
}
