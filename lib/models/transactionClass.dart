import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String objPurchased;
  final double amount;
  final DateTime dt;

  Transaction(
      {@required this.id,@required this.objPurchased, @required this.amount, @required this.dt});
}
