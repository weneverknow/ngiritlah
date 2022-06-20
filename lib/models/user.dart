class User {
  final int? id;
  final String? name;
  final double? salary;
  final double? salaryBalance;

  const User({this.id, this.name, this.salary, this.salaryBalance});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        name: json['name'],
        salary: json['salary'],
        salaryBalance: json['salary_balance']);
  }
}
