class Employee {
  final String id; // 👈 ADD THIS
  final String empId;
  final String name;
  final String department;
  final String role;
  final String phone;
  final bool isActive;

  Employee({
    required this.id,
    required this.empId,
    required this.name,
    required this.department,
    required this.role,
    required this.phone,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'].toString(), // 👈 IMPORTANT
      empId: json['emp_code'] ?? "",
      name: "${json['first_name']} ${json['last_name']}",
      department: json['department_name'] ?? "-",
      role: json['role_id'] == 2 ? "Employee" : "Other",
      phone: json['mobile'] ?? "-",
      isActive: json['is_active'] == true,
    );
  }
}
