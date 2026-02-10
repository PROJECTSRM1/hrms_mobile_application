import 'package:flutter/material.dart';

class TaxDeclarationModel extends ChangeNotifier {
  double sec80c = 0;
  double otherDeductions = 0;
  double hra = 0;
  double medical80d = 0;
  double incomeLoss = 0;
  double otherIncome = 0;
  double tcsTds = 0;

  void updateSec80C(double value) {
    sec80c = value;
    notifyListeners();
  }
}
