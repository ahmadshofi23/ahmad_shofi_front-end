import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniinventory/controllers/barang_controller.dart';
import 'package:intl/intl.dart';
import 'package:miniinventory/views/barang_detail_sheet.dart';
import 'package:miniinventory/views/barang_form_page.dart';

class BarangListPage extends StatelessWidget {
  final BarangController controller = Get.put(BarangController());
  final TextEditingController _searchController = TextEditingController();

  BarangListPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadBarang();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
        actions: [
          Obx(
            () =>
                controller.selectedIds.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: controller.deleteSelectedBarang,
                    )
                    : SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        final filtered =
            controller.barangList
                .where(
                  (barang) => barang.namaBarang.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
                )
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari barang...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) => controller.barangList.refresh(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Text(
                '${filtered.fold<int>(0, (sum, item) => sum + item.stok)} Data Yang Ditampilkan',
              ),
            ),
            if (filtered.isEmpty)
              Expanded(child: Center(child: Text('Tidak ditemukan')))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.loadBarang,
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final barang = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          child: ListTile(
                            leading: Obx(
                              () => Checkbox(
                                value: controller.selectedIds.contains(
                                  barang.id,
                                ),
                                onChanged:
                                    (_) =>
                                        controller.toggleSelection(barang.id!),
                              ),
                            ),
                            title: Text(barang.namaBarang),
                            subtitle: Text(
                              'Stok: ${barang.stok} | Harga: ${NumberFormat.currency(locale: "id_ID", symbol: "Rp ").format(barang.harga)}',
                            ),
                            onTap:
                                () => showModalBottomSheet(
                                  context: context,
                                  builder:
                                      (_) => BarangDetailSheet(barang: barang),
                                ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Get.to(
                                  () => BarangFormPage(
                                    isEdit: true,
                                    barang: barang,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox.shrink();
        }
        final filtered =
            controller.barangList
                .where(
                  (barang) => barang.namaBarang.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
                )
                .toList();

        final totalHarga = filtered
            .fold<Map<int, int>>({}, (acc, barang) {
              acc.update(
                barang.id!,
                (value) => value + (barang.harga * barang.stok),
                ifAbsent: () => barang.harga * barang.stok,
              );
              return acc;
            })
            .values
            .fold(0, (a, b) => a + b);

        final totalStok = filtered.fold<int>(0, (sum, item) => sum + item.stok);

        return BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Stok: $totalStok'),
                Text(
                  'Total Harga: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(totalHarga)}',
                ),
              ],
            ),
          ),
        );
      }),

      floatingActionButton: ElevatedButton.icon(
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Tambah Barang', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xff081830)),
        onPressed: () => Get.to(() => BarangFormPage(isEdit: false)),
      ),
    );
  }
}
