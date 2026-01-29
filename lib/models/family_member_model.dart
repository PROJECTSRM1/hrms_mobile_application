class FamilyMember {
  int relationId;
  String firstName;
  String lastName;
  String aadhar;
  int occupationId;
  String? phone;
  String? email;
  String presentAddress;
  String permanentAddress;

  FamilyMember({
    required this.relationId,
    required this.firstName,
    required this.lastName,
    required this.aadhar,
    required this.occupationId,
    this.phone,
    this.email,
    required this.presentAddress,
    required this.permanentAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      "relation_id": relationId,
      "first_name": firstName,
      "last_name": lastName,
      "aadhar": aadhar,
      "occupation_id": occupationId,
      "phone": phone,
      "email": email,
      "present_address": presentAddress,
      "permanent_address": permanentAddress,
    };
  }
}
