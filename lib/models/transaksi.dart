class Transaksi {
  final int? id;
  final int? idKategori;
  final String? keterangan;
  final int? type;
  final double? nominal;
  final DateTime? createdDate;

  const Transaksi(
      {this.id,
      this.idKategori,
      this.keterangan,
      this.type,
      this.nominal,
      this.createdDate});

  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
      id: json['id'],
      idKategori: json['id_kategori'],
      keterangan: json['keterangan'],
      type: json['type'],
      nominal: json['nominal'],
      createdDate: DateTime.fromMillisecondsSinceEpoch(json['created_date']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_kategori': idKategori,
        'keterangan': keterangan,
        'type': type,
        'nominal': nominal,
        'created_date': (createdDate ?? DateTime.now()).millisecondsSinceEpoch
      };
}
