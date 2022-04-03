import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prashantclinic/clinical.dart';
import 'package:prashantclinic/mobile.dart';
import 'package:prashantclinic/updatepatient.dart';
import 'package:prashantclinic/vitals.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class editPatient extends StatefulWidget {
  DocumentSnapshot doctoEdit;
  editPatient({this.doctoEdit});

  @override
  _editPatientState createState() => _editPatientState();
}

class _editPatientState extends State<editPatient> {
  Future<void> showreciptdialog(BuildContext context, int index, e) async {
    var medicines = receipts[receipts.indexOf(e)]["medirecodrs"];
    var tempclini =
        receipts[receipts.indexOf(e)]["Clinicalfeatures"].toString();
    var tempprecadv = receipts[receipts.indexOf(e)]["Precadv"].toString();
    var temppurpose =
        receipts[receipts.indexOf(e)]["purposeofvisit"].toString();
    var tempappointdate =   receipts[receipts.indexOf(e)]["receiptdate"].toString();   
    //print(medicines);
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Column(children: [
                  Text(receipts[receipts.indexOf(e)]["Clinicalfeatures"]
                      .toString()),
                  Text(receipts[receipts.indexOf(e)]["Precadv"].toString()),
                ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                  TextButton(
                    onPressed: () {
                      _createPDF(
                          medicines, tempprecadv, tempclini, temppurpose, tempappointdate);
                    },
                    child: Text("Print"),
                  )
                ],
                content: Container(
                    width: double.minPositive,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: medicines.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(medicines[index]["medicinename"]),
                          );
                        })));
          });
        });
  }

  String age;
  String appointdate;
  String consultationby;
  String gender;
  String regno;
  String patientname;
  String phoneno;
  //String purpose;

  var receipts = [];
  @override
  void initState() {
    age = widget.doctoEdit['age'];
    appointdate = widget.doctoEdit['appointdate'];
    consultationby = widget.doctoEdit['consultationby'];
    gender = widget.doctoEdit['gender'];
    regno = widget.doctoEdit['regno'].toString();
    patientname = widget.doctoEdit['patientname'];
    phoneno = widget.doctoEdit['phoneno'];
    //purpose = widget.doctoEdit['purpose'];
    receipts = widget.doctoEdit['receipts'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Patient Details"),
          actions: [
            TextButton(
                onPressed: () {
                  widget.doctoEdit.reference
                      .delete()
                      .whenComplete(() => Navigator.pop(context));
                },
                child: Text('Delete',
                    style: TextStyle(
                      color: Colors.black,
                    ))),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
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
                              'Registration No:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ]),
                          Column(children: [Text(regno)]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('Name',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(patientname)]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('Age',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(age)]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('Gender',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(gender)]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('Phone No',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(phoneno)]),
                        ]),
                      ],
                    ),
                    // Text(
                    //   "Registration No: " + regno,
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    // Text(
                    //   "Name : " + patientname,
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    // Text(
                    //   "Age : " + age.toString(),
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    // Text(
                    //   "Gender : " + gender,
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    // Text(
                    //   "Purpose of visit : " + purpose,
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    // Text(
                    //   "Phone no : " + phoneno,
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => updatePatient(
                                          doctoEdit: widget.doctoEdit,
                                        )));
                          },
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
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
                              'Blood Pressure',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ]),
                          Column(children: [Text(widget.doctoEdit['BP'])]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('Weight',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(widget.doctoEdit['Weight'])]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('Temperature',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(widget.doctoEdit['temp'])]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('Spo2',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(widget.doctoEdit['spo2'])]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('PR',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(widget.doctoEdit['p'])]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text('Rt-pcr',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [Text(widget.doctoEdit['rtpcr'])]),
                        ]),
                      ],
                    ),
                    // Text("BP    : " + widget.doctoEdit['BP']),
                    // Text("Weight: " + widget.doctoEdit['Weight']),
                    // Text("BMI   : " + widget.doctoEdit['BMI']),
                    // Text("Temp  : " + widget.doctoEdit['temp']),
                    // Text("Spo2  : " + widget.doctoEdit['spo2']),
                    // Text("PR    : " + widget.doctoEdit['p']),
                    // Text("Rt-pcr    : " + widget.doctoEdit['rtpcr']),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Vitals(
                                          doctoEdit: widget.doctoEdit,
                                        )));
                          },
                          child: const Text('Add/Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => clinical(
                                doctoEdit: widget.doctoEdit, index: -1)));
                  },
                  child: Text("Add medicines / Advice"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.cyanAccent,
                      onPrimary: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20))),
              SizedBox(height: 20),
              Text("Receipts"),
              SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                children: receipts
                    .map((e) => InkWell(
                        onTap: () {},
                        child: Card(
                          child: ListTile(
                            // onTap: () async {
                            //   var index = receipts.indexOf(e);
                            //   await showreciptdialog(context, index, e);
                            // },
                            title: Text(receipts[receipts.indexOf(e)]
                                    ["Clinicalfeatures"]
                                .toString()),
                            trailing: Wrap(
                              spacing: 1, // space between two icons
                              children: <Widget>[
                                IconButton(
                                    onPressed: () async {
                                      var index = receipts.indexOf(e);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => clinical(
                                                  doctoEdit: widget.doctoEdit,
                                                  index: index)));
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () async {
                                      var index = receipts.indexOf(e);
                                      await showreciptdialog(context, index, e);
                                    },
                                    icon: Icon(Icons.visibility)) // icon-2
                              ],
                            ),
                            // trailing: IconButton(
                            //     onPressed: () async {
                            //       var index = receipts.indexOf(e);
                            //       await showreciptdialog(context, index, e);
                            //     },
                            //     icon: Icon(Icons.visibility)),
                            leading: IconButton(
                                onPressed: () async {
                                  receipts.removeAt(receipts.indexOf(e));
                                  setState(() {
                                    receipts = receipts;
                                  });
                                  widget.doctoEdit.reference
                                      .update({'receipts': receipts});
                                },
                                icon: Icon(Icons.delete)),
                          ),
                        )))
                    .toList(),
              ),
            ],
          ),
        )));
  }

  Future<void> _createPDF(medicines, String tempprecadv, String tempclini,
      String temppurpose, String tempappointdate) async {
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
    page.graphics.drawString(widget.doctoEdit['patientname'] + ' '+ widget.doctoEdit['patientmiddlename']+' '+ widget.doctoEdit['patientlastname'],
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
    page.graphics.drawString(tempappointdate,
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
          medicines[i]['medicinename'] +
          " " +
          medicines[i]['medicineusage'] +
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
    if (widget.doctoEdit['rtpcr'].isNotEmpty) {
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
    //       bounds: Rect.fromLTWH(0, 340, 145, 50));
    // }

    page.graphics.drawString('Complaints:',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 320, page.getClientSize().width, 50));
    page.graphics.drawString(
        temppurpose, PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 340, 145, 140),
        format: PdfStringFormat(wordWrap: PdfWordWrapType.word));

    page.graphics.drawString('Diagnosis:',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 430, page.getClientSize().width, 50));

    page.graphics.drawString(
        tempclini, PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(0, 450, 145, 140),
        format: PdfStringFormat(wordWrap: PdfWordWrapType.word));

    page.graphics.drawString('Investigation: ',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, 580, page.getClientSize().width, 50));

    page.graphics.drawString(
        tempprecadv, PdfStandardFont(PdfFontFamily.helvetica, 16),
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
}
