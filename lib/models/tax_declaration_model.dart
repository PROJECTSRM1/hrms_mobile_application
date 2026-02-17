import 'package:flutter/material.dart';

class TaxDeclarationModel extends ChangeNotifier {

  /// ======================
  /// SEC 80C
  /// ======================
  double sec80c = 0;
  Map<String, double> sec80cValues = {};

  /// ======================
  /// OTHER DEDUCTIONS
  /// ======================
  double otherDeductions = 0;
  Map<String, double> otherDeductionValues = {};

  /// ======================
  /// HRA
  /// ======================
  double hra = 0;
  Map<String, dynamic> hraValues = {};

  /// ======================
  /// MEDICAL 80D
  /// ======================
  double medical80d = 0;
  Map<String, double> medicalValues = {};

  /// ======================
  /// INCOME / LOSS
  /// ======================
  double incomeLoss = 0;
  Map<String, dynamic> incomeLossValues = {};

  /// ======================
  /// OTHER INCOME
  /// ======================
  double otherIncome = 0;
  Map<String, dynamic> otherIncomeValues = {};

  /// ======================
  /// TCS / TDS
  /// ======================
  double tcsTds = 0;
  Map<String, dynamic> tcsTdsValues = {};

  /// ======================
  /// UPDATE METHODS
  /// ======================

  void updateSec80C(Map<String, double> values, double total) {
    sec80cValues = Map.from(values);
    sec80c = total;
    notifyListeners();
  }

  void updateOtherDeductions(Map<String, double> values, double total) {
    otherDeductionValues = Map.from(values);
    otherDeductions = total;
    notifyListeners();
  }

  void updateHRA(Map<String, dynamic> values, double total) {
    hraValues = Map.from(values);
    hra = total;
    notifyListeners();
  }

  void updateMedical80D(Map<String, double> values, double total) {
    medicalValues = Map.from(values);
    medical80d = total;
    notifyListeners();
  }

  void updateIncomeLoss(Map<String, dynamic> values, double total) {
    incomeLossValues = Map.from(values);
    incomeLoss = total;
    notifyListeners();
  }

  void updateOtherIncome(Map<String, dynamic> values, double total) {
    otherIncomeValues = Map.from(values);
    otherIncome = total;
    notifyListeners();
  }

  void updateTcsTds(Map<String, dynamic> values, double total) {
    tcsTdsValues = Map.from(values);
    tcsTds = total;
    notifyListeners();
  }

  /// ======================
  /// OPTIONAL: RESET ALL
  /// ======================

  void resetAll() {
    sec80c = 0;
    otherDeductions = 0;
    hra = 0;
    medical80d = 0;
    incomeLoss = 0;
    otherIncome = 0;
    tcsTds = 0;

    sec80cValues.clear();
    otherDeductionValues.clear();
    hraValues.clear();
    medicalValues.clear();
    incomeLossValues.clear();
    otherIncomeValues.clear();
    tcsTdsValues.clear();

    notifyListeners();
  }
}
