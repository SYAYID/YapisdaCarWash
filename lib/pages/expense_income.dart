import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'expenselist.dart'; // Impor ExpenseListPage


class ExpenseFormPage extends StatefulWidget {
  const ExpenseFormPage({Key? key}) : super(key: key);

  @override
  _ExpenseFormPageState createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final double amount = double.parse(_amountController.text);
      final String description = _descriptionController.text;

      FirebaseFirestore.instance.collection('pengeluaran').add({
        'amount': amount,
        'description': description,
        'timestamp': DateTime.now(),
      }).then((value) {
        _amountController.clear();
        _descriptionController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense added successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add expense. Please try again.')),
        );
      });
    }
  }

  void _navigateToExpenseList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpenseListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengeluaran',
          style: TextStyle(
            fontFamily: 'JosefinSansReg',
            color: Colors.white,
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
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _navigateToExpenseList,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambahkan Pengeluaran',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'JosefinSansReg',

              ),
            ),
            SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nominal',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        fontFamily: 'JosefinSansReg',
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'JosefinSansReg',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap isi form nominal';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        fontFamily: 'JosefinSansReg',
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'JosefinSansReg',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap isi form deskripsi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Tambahkan',
                        style: TextStyle(
                          fontFamily: 'JosefinSansReg',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
