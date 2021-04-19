import 'package:flutter/material.dart';
import '../models/transactionClass.dart';
import 'package:intl/intl.dart';

//Displaying the list of transactions
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  TransactionList(this.transactions, this.deleteTransaction);

  //Widgets for outputting texts on the card
  Widget objPurchasedText(index) {
    return Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        margin: EdgeInsets.only(left: 10),
        child: Text(
          transactions[index].objPurchased,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Colors.red[400]),
        ));
  }

  Widget objPurchasedDateText(index) {
    return Container(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        margin: EdgeInsets.only(left: 10),
        child: Text(
          DateFormat.yMMMEd().format(transactions[index].dt),
          style: TextStyle(fontSize: 20, color: Colors.purple[300]),
        ));
  }

  Widget amountOfObjPurchased(index) {
    Container(
      child: Text(
          'Rs. ${transactions[index].amount.toStringAsFixed(2)}', //To restrict the amount's decimal placed not more than 2.
          style: TextStyle(fontSize: 25)),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              width: 3,
              color: Colors.lightGreen[900],
              style: BorderStyle.solid)),
    );
  }

  //No Transaction Widgets
  Widget noTransactionText() {
    Container(
        alignment: Alignment.topCenter,
        child: const Text('No Transactions added yet!',
            style: TextStyle(fontSize: 30)));
  }

  Widget noTransactionImage(mediaquery) {
    Container(
      child: Image.asset("assets/images/trans_not_found.png",
          width: mediaquery.size.height * 0.2,
          height: mediaquery.size.height * 0.2),
    );
  }

  //Deleting Transaction widget
  Widget removalOfTransaction(index) {
    Container(
      alignment: Alignment.bottomRight,
      child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            if (deleteTransaction(transactions[index].id)) {
              transactions.remove(transactions[index]);
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Container(
        child: transactions.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    noTransactionText(),
                    noTransactionImage(mediaquery),
                  ])
            : ListView.builder(itemBuilder: (ctx, index) {
                if (index < transactions.length) {
                  return Card(
                    //Making the standard layout using
                    //Row -> (Container->Text,Container->(Column->[(Container->Text),(Container->Text)])))
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: mediaquery.size.width,
                        child: Row(children: <Widget>[
                          amountOfObjPurchased(index),
                          Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                objPurchasedText(index),
                                objPurchasedDateText(index),
                              ])),
                          Flexible(
                            fit: FlexFit.tight,
                            child: removalOfTransaction(index),
                          ),
                        ]),
                      ),
                    ),
                    elevation: 50,
                    shadowColor: Colors.blue[50],
                  );
                  itemCount:
                  transactions.length;
                }
              }));
  }
}
