import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniinventory/controllers/barang_controller.dart';
import 'package:miniinventory/data/datasources/database_helper.dart';
import 'package:miniinventory/data/models/barang_model.dart';

class BarangFormPage extends StatefulWidget {
  final bool isEdit;
  final BarangModel? barang;

  BarangFormPage({required this.isEdit, this.barang});

  @override
  State<BarangFormPage> createState() => _BarangFormPageState();
}

class _BarangFormPageState extends State<BarangFormPage> {
  RxBool isValid = false.obs;
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();
  final _hargaController = TextEditingController();
  String _kelompok = 'Utama';
  int? _kategoriId;
  List<Map<String, dynamic>> _kategoriList = [];
  final controller = Get.find<BarangController>();

  @override
  void initState() {
    super.initState();
    _loadKategori();
    if (widget.isEdit && widget.barang != null) {
      _namaController.text = widget.barang!.namaBarang;
      _stokController.text = widget.barang!.stok.toString();
      _hargaController.text = widget.barang!.harga.toString();
      _kelompok = widget.barang!.kelompokBarang;
      _kategoriId = widget.barang!.kategoriId;
    }
  }

  Future<void> _loadKategori() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('kategori');
    setState(() => _kategoriList = result);
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _kategoriId != null) {
      final barang = BarangModel(
        id: widget.isEdit ? widget.barang!.id : null,
        namaBarang: _namaController.text,
        kategoriId: _kategoriId!,
        stok: int.parse(_stokController.text),
        kelompokBarang: _kelompok,
        harga: int.parse(_hargaController.text),
      );
      if (widget.isEdit) {
        controller.updateBarang(barang);
      } else {
        controller.addBarang(barang);
      }
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateValidity() {
      final valid = _formKey.currentState?.validate() ?? false;
      isValid.value = valid && _kategoriId != null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Barang' : 'Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Barang*'),
                onChanged: (_) => updateValidity(),
                validator:
                    (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _kategoriId,
                decoration: InputDecoration(labelText: 'Kategori*'),
                items:
                    _kategoriList.map<DropdownMenuItem<int>>((kategori) {
                      return DropdownMenuItem<int>(
                        value: kategori['id'] as int,
                        child: Text(kategori['nama_kategori']),
                      );
                    }).toList(),
                onChanged: (val) {
                  setState(() {
                    _kategoriId = val;
                    updateValidity();
                  });
                },
                validator: (val) => val == null ? 'Pilih kategori' : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _kelompok,
                decoration: InputDecoration(labelText: 'Kelompok Barang*'),
                items:
                    ['Utama', 'Tambahan', 'Sampingan']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    _kelompok = val!;
                    updateValidity();
                  });
                },
              ),

              SizedBox(height: 12),
              TextFormField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stok*'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                onChanged: (_) => updateValidity(),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Harga (Rp)*'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                onChanged: (value) => updateValidity(),
              ),
              SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isValid.value ? Color(0xff081830) : Colors.grey,
                  ),
                  onPressed: isValid.value ? _submit : null,
                  child: Text(
                    widget.isEdit ? 'Simpan Perubahan' : 'Tambah',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
