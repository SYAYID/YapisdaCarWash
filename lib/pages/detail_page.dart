import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  DetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail',
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
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem('Jenis Pembayaran:', data['jenis_pembayaran'] ?? ''),
                  SizedBox(height: 20.0),
                  _buildDetailItem('Jenis Kendaraan:', data['jenis_kendaraan'] ?? ''),
                  SizedBox(height: 20.0),
                  _buildDetailItem('Jenis Pelayanan:', data['jenis_pelayanan'] ?? ''),
                  SizedBox(height: 20.0),
                  _buildDetailItem('Plat Kendaraan:', data['plat_kendaraan'] ?? ''),
                  SizedBox(height: 20.0),
                  _buildDetailItem('Harga Pelayanan:', 'Rp ${data['harga_pelayanan'] ?? ''}'),
                  SizedBox(height: 20.0),
                  _buildDetailItem('Tanggal Dibuat:', DateFormat('dd-MM-yyyy').format(data['timestamp'].toDate())),
                  SizedBox(height: 20.0),
                  _buildDetailItem('Gambar:', ''),
                  SizedBox(height: 16.0),
                  Image.network(
                    data['url'] ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
        SizedBox(height: 8.0),
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
