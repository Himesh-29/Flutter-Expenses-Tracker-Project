import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//New Transaction is made stateful so that while typing inside the form which opens up when user presses '+' button, the data does not get lost
class NewTransaction extends StatefulWidget {
  Function fn;

  NewTransaction(this.fn);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  void datePicker() {
    showDatePicker(
            context: context,
            initialDate: selectedDate == null ? DateTime.now() : selectedDate,
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((datePicked) {
      if (datePicked == null) return;
      setState(() {
        selectedDate = datePicked;
      });
    });
  }

  //Creating a controller so that we can get the input in it from the text Field.
  final object_controller = TextEditingController();
  final amt_controller = TextEditingController();
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    //Creating a layout which opens when user presses the '+' button on keyboard
    final mediaquery = MediaQuery.of(context);
    return Card(
        elevation: 10,
        child: Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: mediaquery.viewInsets.top + 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //creating a textfield which accepts the object which as purchased
                  TextField(
                      controller: object_controller,
                      decoration: InputDecoration(
                          fillColor: Colors.purple[300],
                          contentPadding: EdgeInsets.all(10),
                          labelText: 'Object Purchased')),
                  //creating a textfield which accepts the amount for which the object was purchased
                  TextField(
                      controller: amt_controller,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                          fillColor: Colors.purple[300],
                          contentPadding: EdgeInsets.all(10),
                          labelText: 'Amount(in Rs.)')),

                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: selectedDate == null
                              ? const Text("No date chosen!")
                              : Text(
                                  'Picked Date: ${DateFormat.yMMMEd().format(selectedDate)}'),
                        ),
                        FlatButton(
                            child: Text('Choose the Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[400],
                                    backgroundColor: Colors.lightBlue[50])),
                            onPressed: datePicker),
                      ],
                    ),
                  ),

                  //Creating a 'New transaction' button
                  Container(
                      alignment: Alignment.bottomRight,
                      child: Platform.isIOS
                          ? CupertinoButton(
                              child: const Text('Add transaction'),
                              onPressed: () {
                                //If the content in the object purchased is empty or the amount for which it was purchased is less than 0, then exit the function
                                if (object_controller.text.isEmpty ||
                                    double.parse(amt_controller.text) < 0 ||
                                    selectedDate == null) {
                                  return;
                                }
                              })
                          : FlatButton(
                              child: const Text('Add transaction'),
                              onPressed: () {
                                //If the content in the object purchased is empty or the amount for which it was purchased is less than 0, then exit the function
                                if (object_controller.text.isEmpty ||
                                    double.parse(amt_controller.text) < 0 ||
                                    selectedDate == null) {
                                  return;
                                }

                                //To provide the object purchased and amount to the Newtransaction widget
                                widget.fn(
                                    object_controller.text,
                                    double.parse(amt_controller.text),
                                    selectedDate);
                                Navigator.of(context)
                                    .pop(); //To close the new transaction window/overlay when a new transaction is added.
                              },

                              //textColor and color of the button add transaction
                              textColor: Colors.purple[900],
                              color: Colors.green[100],
                            )),
                ],
              ),
            )));
  }
}
