class BarangModel {
  final int? id;
  final String namaBarang;
  final int kategoriId;
  final int stok;
  final String kelompokBarang;
  final int harga;

  BarangModel({
    this.id,
    required this.namaBarang,
    required this.kategoriId,
    required this.stok,
    required this.kelompokBarang,
    required this.harga,
  });

  factory BarangModel.fromMap(Map<String, dynamic> map) {
    return BarangModel(
      id: map['id'],
      namaBarang: map['nama_barang'],
      kategoriId: map['kategori_id'],
      stok: map['stok'],
      kelompokBarang: map['kelompok_barang'],
      harga: map['harga'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'kategori_id': kategoriId,
      'stok': stok,
      'kelompok_barang': kelompokBarang,
      'harga': harga,
    };
  }
}
