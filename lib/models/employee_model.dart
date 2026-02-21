class Employee {
  final String id;
  final String empId;
  final String name;
  final String department;
  final String role;
  final int roleId;   // ✅ NEW
  final String phone;
  final bool isActive;
  final String email;


  Employee({
    required this.id,
    required this.empId,
    required this.name,
    required this.department,
    required this.role,
    required this.roleId,   // ✅ NEW
    required this.phone,
    required this.isActive,
    required this.email,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'].toString(),
      empId: json['emp_code'] ?? "",
      name: "${json['first_name']} ${json['last_name']}",
      department: json['department_name'] ?? "-",
      roleId: json['role_id'] ?? 0, // ✅ IMPORTANT
      role: json['role_id'] == 3 ? "Manager" : "Employee",
      phone: json['mobile'] ?? "-",
      isActive: json['is_active'] == true,
      email: json['email'] ?? "",
    );
  }
}
