import 'package:get/get.dart';
import 'package:miniinventory/data/datasources/database_helper.dart';
import 'package:miniinventory/data/models/barang_model.dart';

class BarangController extends GetxController {
  var barangList = <BarangModel>[].obs;
  var selectedIds = <int>{}.obs;
  final isLoading = true.obs;

  Future<void> loadBarang() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 3));
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('barang');
    barangList.value = result.map((e) => BarangModel.fromMap(e)).toList();
    isLoading.value = false;
  }

  Future<void> addBarang(BarangModel barang) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('barang', barang.toMap());
    await loadBarang();
  }

  Future<void> updateBarang(BarangModel barang) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'barang',
      barang.toMap(),
      where: 'id = ?',
      whereArgs: [barang.id],
    );
    await loadBarang();
  }

  Future<void> deleteBarang(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('barang', where: 'id = ?', whereArgs: [id]);
    await loadBarang();
  }

  Future<void> deleteSelectedBarang() async {
    final db = await DatabaseHelper.instance.database;
    for (var id in selectedIds) {
      await db.delete('barang', where: 'id = ?', whereArgs: [id]);
    }
    selectedIds.clear();
    await loadBarang();
  }

  void toggleSelection(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }
}
