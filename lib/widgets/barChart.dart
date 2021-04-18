import 'package:flutter/material.dart';

//Returning the stack layout of bar graph made for one day
class BarChart extends StatelessWidget {
  final String day_of_week;
  final double spending;
  final double percentOfTotSpending;

  BarChart(this.day_of_week, this.spending, this.percentOfTotSpending);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(children: <Widget>[
        Container(
            height: constraints.maxHeight * 0.15,
            child: Text('₹ ${spending.toStringAsFixed(0)}')),
        SizedBox(height: constraints.maxHeight * 0.05),
        Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                //bottomost widget - Will show white-greyish background if it has amount=0
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(230, 230, 230, 1),
                  ),
                ),
                //Topmost widget - Will show an amber look to see how much total amount is spent
                Container(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                      heightFactor: percentOfTotSpending,
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber[400],
                      ))),
                )
              ],
            )),
        SizedBox(height: constraints.maxHeight * 0.05),
        Container(
            height: constraints.maxHeight * 0.15, child: Text(day_of_week)),
      ]);
    });
  }
}
