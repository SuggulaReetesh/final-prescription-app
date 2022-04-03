import 'package:flutter/material.dart';
import 'package:prashantclinic/addclinical.dart';

class addvitals extends StatefulWidget {
  final user;
  addvitals({@required this.user});

  @override
  _addvitalsState createState() => _addvitalsState();
}

class _addvitalsState extends State<addvitals> {
  @override
  void initState() {
    //print(widget.user);
    super.initState();
  }

  TextEditingController bp = TextEditingController();
  TextEditingController wt = TextEditingController();
  //TextEditingController bmi = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController spo2 = TextEditingController();
  TextEditingController p = TextEditingController();
  TextEditingController rtpcr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add vital details"),
        actions: [],
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
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                widget.user['BP'] = bp.text;
                widget.user['Weight'] = wt.text;
                widget.user['temp'] = temp.text;
                widget.user['spo2'] = spo2.text;
                widget.user['p'] = p.text;
                widget.user['rtpcr'] = rtpcr.text;
                //print(widget.user);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => addclinical(user: widget.user)));
              },
              child: Text("Continue"))
        ],
      ),
    );
  }
}
