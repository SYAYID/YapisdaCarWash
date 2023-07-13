import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  final String documentId;

  EditPage({required this.documentId});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController jenisPembayaranController;
  late TextEditingController jenisKendaraanController;
  late TextEditingController jenisPelayananController;
  late TextEditingController platKendaraanController;
  late TextEditingController hargaPelayananController;

  @override
  void initState() {
    super.initState();
    jenisPembayaranController = TextEditingController();
    jenisKendaraanController = TextEditingController();
    jenisPelayananController = TextEditingController();
    platKendaraanController = TextEditingController();
    hargaPelayananController = TextEditingController();

    fetchDocumentData();
  }

  @override
  void dispose() {
    jenisPembayaranController.dispose();
    jenisKendaraanController.dispose();
    jenisPelayananController.dispose();
    platKendaraanController.dispose();
    hargaPelayananController.dispose();
    super.dispose();
  }

  void fetchDocumentData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection('catatan').doc(widget.documentId).get();
    Map<String, dynamic>? data = snapshot.data();

    if (data != null) {
      setState(() {
        jenisPembayaranController.text = data['jenis_pembayaran'] ?? '';
        jenisKendaraanController.text = data['jenis_kendaraan'] ?? '';
        jenisPelayananController.text = data['jenis_pelayanan'] ?? '';
        platKendaraanController.text = data['plat_kendaraan'] ?? '';
        hargaPelayananController.text = data['harga_pelayanan'].toString();

        print('Retrieved Data:');
        print('jenis_pembayaran: ${data['jenis_pembayaran']}');
        print('jenis_kendaraan: ${data['jenis_kendaraan']}');
        print('jenis_pelayanan: ${data['jenis_pelayanan']}');
        print('plat_kendaraan: ${data['plat_kendaraan']}');
        print('harga_pelayanan: ${data['harga_pelayanan']}');
      });
    }
  }

  void saveData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('catatan').doc(widget.documentId).update({
      'jenis_pembayaran': jenisPembayaranController.text,
      'jenis_kendaraan': jenisKendaraanController.text,
      'jenis_pelayanan': jenisPelayananController.text,
      'plat_kendaraan': platKendaraanController.text,
      'harga_pelayanan': int.parse(hargaPelayananController.text),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Data',
          style: TextStyle(
            fontFamily: 'JosefinSansReg',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditableItem('Jenis Pembayaran:', jenisPembayaranController),
              SizedBox(height: 30),
              _buildEditableItem('Jenis Kendaraan:', jenisKendaraanController),
              SizedBox(height: 30),
              _buildEditableItem('Jenis Pelayanan:', jenisPelayananController),
              SizedBox(height: 30),
              _buildEditableItem('Plat Kendaraan:', platKendaraanController),
              SizedBox(height: 30),
              _buildEditableItem('Harga Pelayanan:', hargaPelayananController),
              SizedBox(height: 30),
              _buildDetailItem(
                  'Tanggal Dibuat:', DateFormat('dd-MM-yyyy').format(DateTime.now())),
              SizedBox(height: 30),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'JosefinSansReg',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableItem(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSansReg',
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: controller,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'JosefinSansReg',
          ),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSansReg',
          ),
        ),
        SizedBox(height: 20),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'JosefinSansReg',
          ),
        ),
      ],
    );
  }
}
