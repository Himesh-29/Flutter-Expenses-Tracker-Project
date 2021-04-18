import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/newTransaction.dart';
import './models/transactionClass.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());
}

//Making the basic class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          accentColor: Colors.tealAccent[400],
          fontFamily: 'PlayfairDisplay',
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(fontFamily: 'New_Tegomin', fontSize: 30)),
          )),
      home: MyHomePage(),
    );
  }
}

//Creating the HomePage stateful widget
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//Creating The main MyHomePageState class which is stateful and changes the UI
class _MyHomePageState extends State<MyHomePage> {
  //Sample List
  final List<Transaction> transactions = [
    // Transaction(objPurchased: "Apple", amount: 50.99, dt: DateTime.now()),
    // Transaction(objPurchased: "Orange", amount: 40.99, dt: DateTime.now()),
  ];

  bool showChart = false;

  //To open a UI showModalBottomSheet when '+' button is triggered
  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  //Adds a new transaction by calling the NewTransaction Class to instantiate the card for that entry
  void addTransaction(String obj_purchase, double amt, DateTime datePassed) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        objPurchased: obj_purchase,
        amount: amt,
        dt: datePassed);
    //To simply add the card to UI on the spot and not after hot-reloading
    setState(() {
      transactions.add(tx);
    });
  }

  //Deleting a widget by passing a function which takes the index from where it should be deleted and that index is determined by the ID associated with it.
  void deleteTransaction(String idToBeDeleted) {
    setState(() {
      transactions.removeWhere((tnx) => tnx.id == idToBeDeleted);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expenses Tracker'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              GestureDetector(
                child: Icon(CupertinoIcons.add_circled_solid),
                onTap: () => startAddNewTransaction(context),
              )
            ]),
          )
        : AppBar(
            title: Text('Expenses Tracker'),
            actions: <Widget>[
              //To add the '+' icon button on the appBar
              IconButton(
                  icon: Icon(Icons.add_circle_sharp),
                  onPressed: () => {
                        startAddNewTransaction(
                            context) //opens up the UI to fill up the form for a new transaction
                      }),
            ],
          );

    final statusBar = mediaquery.padding.top;
    final pageBody = SafeArea(
        child: Container(
      height: mediaquery.size.height,
      child: Column(
          //To make column list of cards
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //To make the Chart scrollable incase it doesn't fit in size

            Container(
              width: mediaquery.size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Show the chart: ',
                        style: Theme.of(context).textTheme.title,
                        textScaleFactor: 1.2),
                    Switch.adaptive(
                      value: showChart,
                      onChanged: (val) {
                        setState(() {
                          showChart = val;
                        });
                      },
                    ),
                  ]),
            ),
            showChart
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Chart(transactions),
                  )

                // Calling the transactionList class with the number of transactions occuring and the delete transaction function defined above
                : Container(
                    height: (mediaquery.size.height -
                            appbar.preferredSize.height -
                            statusBar) *
                        0.85,
                    width: mediaquery.size.width,
                    child: TransactionList(transactions, deleteTransaction)),
          ]),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appbar,
          )
        : Scaffold(
            //appBar
            appBar: appbar,
            body: pageBody,

            // Adding a flaoting action button at the end to open up the UI to fill up the form for a new transaction
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_circle_sharp),
              onPressed: () => startAddNewTransaction(context),
            ),
          );
  }
}
