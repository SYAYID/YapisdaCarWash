import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes/common/theme_helper.dart';
import 'home_page.dart';

class PaymentFormScreen extends StatefulWidget {
  @override
  _PaymentFormScreenState createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  String? selectedPayment;
  String? selectedVehicle;
  String? selectedService;
  String? vehiclePlate;
  File? selectedImage;

  final List<String> paymentOptions = ['Transfer Bank', 'E-Wallet', 'Tunai'];
  final List<String> vehicleOptions = ['Motor', 'Mobil'];
  final List<String> serviceOptions = [
    'Cuci Body',
    'Cuci Kolong',
    'Cuci Motor Besar',
    'Cuci Motor Kecil',
    'Vacuum'
  ];
  final Map<String, int> servicePrices = {
    'Cuci Body': 35000,
    'Cuci Kolong': 45000,
    'Vacuum': 25000,
    'Cuci Motor Besar': 15000,
    'Cuci Motor Kecil': 10000,
  };

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> saveImageUrlToDatabase(String imageUrl) async {
    try {
      int price = servicePrices[selectedService] ?? 0;
      await FirebaseFirestore.instance.collection('catatan').add({
        'url': imageUrl,
        'timestamp': DateTime.now(),
        'jenis_pembayaran': selectedPayment,
        'jenis_kendaraan': selectedVehicle,
        'jenis_pelayanan': selectedService,
        'plat_kendaraan': vehiclePlate,
        'harga_pelayanan': price,
      });
    } catch (e) {
      print('Error saving image URL to database: $e');
    }
  }

  Future<void> uploadImage() async {
    if (selectedPayment == null ||
        selectedVehicle == null ||
        selectedService == null ||
        vehiclePlate == null ||
        vehiclePlate!.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Harap isi semua data terlebih dahulu.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else if (selectedImage != null) {
      try {
        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(
          'catatan/${DateTime.now().millisecondsSinceEpoch}.png',
        );

        await ref.putFile(selectedImage!);

        String imageUrl = await ref.getDownloadURL();
        await saveImageUrlToDatabase(imageUrl);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sukses'),
              content: Text('Gambar berhasil diunggah.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Text('OK'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error uploading image: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Terjadi kesalahan saat mengunggah gambar.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Harap pilih gambar terlebih dahulu.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeHelper = ThemeHelper();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).primaryColor,
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/5.png',
              fit: BoxFit.cover,
              width: 180,
              height: 50,
            ),
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).highlightColor,
        height: 800,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedPayment,
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value;
                  });
                },
                items: paymentOptions.map((String paymentOption) {
                  return DropdownMenuItem<String>(
                    value: paymentOption,
                    child: Text(
                      paymentOption,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: themeHelper.textInputDecoration('Jenis Pembayaran'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedVehicle,
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value;
                  });
                },
                items: vehicleOptions.map((String vehicleOption) {
                  return DropdownMenuItem<String>(
                    value: vehicleOption,
                    child: Text(
                      vehicleOption,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: themeHelper.textInputDecoration('Jenis Kendaraan'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedService,
                onChanged: (value) {
                  setState(() {
                    selectedService = value;
                  });
                },
                items: serviceOptions.map((String serviceOption) {
                  return DropdownMenuItem<String>(
                    value: serviceOption,
                    child: Text(
                      serviceOption,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: themeHelper.textInputDecoration('Jenis Pelayanan'),
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    vehiclePlate = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Harap isi plat kendaraan.';
                  }
                  return null;
                },
                decoration: themeHelper.textInputDecoration('Plat Kendaraan'),
              ),
              SizedBox(height: 16),
              Center(
                child: selectedService != null
                    ? Text(
                  'Harga Total: Rp ${servicePrices[selectedService]}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : Container(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => pickImage(ImageSource.camera),
                    child: Text('Ambil Gambar', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => pickImage(ImageSource.gallery),
                    child: Text('Pilih dari Galeri', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              selectedImage != null
                  ? Image.file(
                selectedImage!,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Container(),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: uploadImage,
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
