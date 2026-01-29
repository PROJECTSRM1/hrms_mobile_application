class PayrollModel {
  final int empId;
  final String employeeName;
  final String designation;
  final int basic;
  final int hra;
  final int specialAllowance;
  final int netSalary;

  PayrollModel({
    required this.empId,
    required this.employeeName,
    required this.designation,
    required this.basic,
    required this.hra,
    required this.specialAllowance,
    required this.netSalary,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      empId: json['emp_id'],
      employeeName: json['employee_name'],
      designation: json['designation'],
      basic: json['basic'],
      hra: json['hra'],
      specialAllowance: json['special_allowance'],
      netSalary: json['net_salary'],
    );
  }
}
