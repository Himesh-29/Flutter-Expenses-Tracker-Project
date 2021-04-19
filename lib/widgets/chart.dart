import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transactionClass.dart';
import '../widgets/BarChart.dart';

//Making the chart class which contains everything present in the chart container in the starting UI
class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions); //Accepts the transactions from main.dart

  //VERY IMP
  //A getter named groupedTransactionValues which returns List of (string.object) map
  List<Map<String, Object>> get groupedTransactionValues {
    //To generate list with 7 items(as week has 7 days)
    return List.generate(7, (index) {
      final weekDay = DateTime.now()
          .subtract(Duration(days: index)); //Getting the weekDay it is
      var totSum =
          0.0; //Defining variable which holds the total amount spent in one day
      for (var i = 0; i < recentTransactions.length; i++) {
        //To check whether the given weekDay is equal to today
        if (recentTransactions[i].dt.day == weekDay.day &&
            recentTransactions[i].dt.month == weekDay.month &&
            recentTransactions[i].dt.year == weekDay.year) {
          totSum += recentTransactions[i].amount;
        }
      }
      //To return a map with properties Day and Amount which contain the day and amount spent in that weekday
      return {
        'Day': DateFormat.E().format(weekDay).toString().substring(0, 3),
        'Amount': totSum,
      };
    }).reversed.toList();
  }

  //To get the total spending done in a week
  double get totSpendingInWeek {
    return groupedTransactionValues.fold(0.0, (sum, element) {
      return sum + element['Amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery=MediaQuery.of(context);
    return Card(
      child:
          //Making a container for chart
          Container(
              width: mediaquery.size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Holding the CHART Text value in the Chart bar
                    Container(
                        margin: EdgeInsets.all(1),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        color: Colors.blue[50],
                        child: const Text("CHART OF YOUR TOTAL SPENDING",
                            style: TextStyle(fontWeight: FontWeight.w900))),

                    //Defining the bar charts for each weekday
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: groupedTransactionValues.map((data) {
                        return Container(
                          constraints: BoxConstraints(
                              maxWidth: mediaquery.size.width,
                              maxHeight:
                                  mediaquery.size.height * 0.3),
                          child: BarChart(
                            data['Day'],
                            data['Amount'],
                            totSpendingInWeek == 0
                                ? 0.0
                                : (data['Amount'] as double) /
                                    totSpendingInWeek,
                          ),
                        );
                      }).toList(),
                    )
                  ])),
      elevation: 5.0, //it controls how strong the drop shadow should be
      shadowColor: Colors.indigo[900],
    );
  }
}
