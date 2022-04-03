import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class medicinedetails extends StatefulWidget {
  @override
  _medicinedetailsState createState() => _medicinedetailsState();
}

class _medicinedetailsState extends State<medicinedetails> {
  Future<void> showmedidialog(BuildContext context, int index, e) async {
    dmedicinename.text = medicines[index]["medicinename"];
    dmedicinetype.text = medicines[index]["medicinetype"];
    dusage.text = medicines[index]["medicineusage"];
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
                      medicines[index]["medicineusage"] = dusage.text;
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
                      TextFormField(
                        controller: dusage,
                        decoration: InputDecoration(hintText: "Medicine Usage"),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController disease = TextEditingController();
  TextEditingController medicinename = TextEditingController();
  TextEditingController medicinetype = TextEditingController();
  TextEditingController usage = TextEditingController();
  //dialog textediting controller
  TextEditingController dmedicinename = TextEditingController();
  TextEditingController dmedicinetype = TextEditingController();
  TextEditingController dusage = TextEditingController();
  var medicines = [];
  var medicinesdata = [];
  var diseasemedicines = [];
  var docids = [];

  @override
  void initState() {
    getdiseasemedicines();
    getmedicines();
    //print(medicinesdata);
    super.initState();
  }

  CollectionReference allmedi =
      FirebaseFirestore.instance.collection('Allmedicines');
  CollectionReference disemedi =
      FirebaseFirestore.instance.collection('medicinelist');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Medicines"),
          actions: [
            TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  if (disease.text.isEmpty || disease.text == null) {
                    //print(medicinesdata);
                    medicinesdata.addAll(medicines);
                    //print(medicinesdata);
                    allmedi
                        .doc('medicines')
                        .update({'items': medicinesdata}).whenComplete(() {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Medicines are Added'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("ok")),
                              ],
                            );
                          });
                      getmedicines();
                    });
                  } else {
                    var dismedi = {
                      "disease": disease.text,
                      "medicines": medicines
                    };
                    disemedi.add(dismedi);
                    medicinesdata.addAll(medicines);
                    //print(medicinesdata);
                    allmedi
                        .doc('medicines')
                        .update({'items': medicinesdata}).whenComplete(() {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Medicines are Added'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("ok")),
                              ],
                            );
                          });
                      getmedicines();
                      getdiseasemedicines();
                    });
                  }
                  disease.clear();
                  medicines = [];
                  setState(() {
                    medicines = medicines;
                  });
                },
                child: Text('SAVE')),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children:
                    List<Widget>.generate(diseasemedicines.length, (int index) {
                  return Chip(
                    onDeleted: () {
                      disemedi.doc(docids[index]).delete();
                      diseasemedicines.removeAt(index);
                      docids.removeAt(index);
                      setState(() {
                        diseasemedicines = diseasemedicines;
                        docids = docids;
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
              TextFormField(
                controller: disease,
                decoration: InputDecoration(hintText: "Disease (Optional)"),
              ),
              Column(children: [
                TextFormField(
                  controller: medicinename,
                  decoration: InputDecoration(hintText: "Medicine"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Medicine Name is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: medicinetype,
                  decoration: InputDecoration(hintText: "Medicine Type"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Medicine type is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: usage,
                  decoration: InputDecoration(hintText: "Medicine Usage"),
                ),
              ]),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate())
                      setState(() {
                        var tabletdetails = {
                          "medicinename": medicinename.text,
                          "medicinetype": medicinetype.text,
                          "medicineusage": usage.text,
                          "morning": false,
                          "morningqua": "0",
                          "afternoon": false,
                          "afterqua": "0",
                          "night": false,
                          "nightqua": "0",
                          "totalqua": "0",
                        };
                        medicines.add(tabletdetails);
                        medicinename.clear();
                        medicinetype.clear();
                        usage.clear();
                        //print(medicines);
                      });
                  },
                  child: Text("Add Medicine"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.cyanAccent,
                      onPrimary: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20))),
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
        ));
  }

  getmedicines() async {
    await FirebaseFirestore.instance
        .collection('Allmedicines')
        .doc("medicines")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        medicinesdata = documentSnapshot.data()["items"];
      }
      setState(() {
        medicinesdata = medicinesdata;
      });
      //print(medicinesdata);
    });
  }

  getdiseasemedicines() async {
    setState(() {
      diseasemedicines = [];
      docids = [];
    });
    await FirebaseFirestore.instance
        .collection('medicinelist')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //print(doc.id);
        //print(doc["disease"]);
        //print(doc.data());
        docids.add(doc.id);
        diseasemedicines.add(doc.data());
        setState(() {
          diseasemedicines = diseasemedicines;
          docids = docids;
        });
      });
    });
  }
}
