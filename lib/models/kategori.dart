class Kategori {
  final int? id;
  final String? name;
  final double? nominal;
  final double? balance;

  const Kategori({this.id, this.name, this.nominal, this.balance});

  factory Kategori.fromJson(Map<String, dynamic> json) => Kategori(
      id: json['id'],
      name: json['name'],
      nominal: json['nominal'],
      balance: json['balance']);
  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'nominal': nominal, 'balance': balance};
}
