import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniinventory/controllers/barang_controller.dart';
import 'package:miniinventory/data/models/barang_model.dart';
import 'package:miniinventory/views/barang_form_page.dart';

class BarangDetailSheet extends StatelessWidget {
  final BarangModel barang;
  final BarangController controller = Get.put(BarangController());

  BarangDetailSheet({required this.barang});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              'https://placehold.co/600x400/png',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),

          ItemDetailBottomSheet(title: 'Nama Barang', value: barang.namaBarang),
          SizedBox(height: 4),
          ItemDetailBottomSheet(
            title: 'Kelompok',
            value: barang.kelompokBarang,
          ),
          SizedBox(height: 4),
          ItemDetailBottomSheet(title: 'Stok', value: barang.stok.toString()),
          SizedBox(height: 4),
          ItemDetailBottomSheet(
            title: 'Harga',
            value: formatter.format(barang.harga),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text(
                    'Hapus Barang',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    controller.deleteBarang(barang.id!);
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff081830),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    'Edit Barang',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(() => BarangFormPage(isEdit: true, barang: barang));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemDetailBottomSheet extends StatelessWidget {
  const ItemDetailBottomSheet({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$title: ', style: TextStyle(fontSize: 16)),
        Text(
          ' $value',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
        ),
      ],
    );
  }
}
