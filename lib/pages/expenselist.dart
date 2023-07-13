import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Tambahkan impor ini

class ExpenseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Total Pengeluaran Bulanan',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pengeluaran').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load expenses'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final expenses = snapshot.data!.docs;

          if (expenses.isEmpty) {
            return Center(
              child: Text('No expenses available'),
            );
          }

          Map<int, int> monthlyExpenses = {}; // Mengubah tipe data menjadi int

          for (var expense in expenses) {
            final amount = expense['amount'] as double;
            final timestamp = expense['timestamp'] as Timestamp;
            final month = DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch).month;

            if (monthlyExpenses.containsKey(month)) {
              monthlyExpenses[month] = (monthlyExpenses[month]! + amount).toInt(); // Mengubah menjadi int
            } else {
              monthlyExpenses[month] = amount.toInt(); // Mengubah menjadi int
            }
          }

          return ListView.builder(
            itemCount: monthlyExpenses.length,
            itemBuilder: (BuildContext context, int index) {
              final month = monthlyExpenses.keys.toList()[index];
              final totalExpense = monthlyExpenses.values.toList()[index];

              // Menggunakan DateFormat untuk memformat bulan dan tahun
              final formattedMonth = DateFormat.MMMM().format(DateTime(DateTime.now().year, month));
              final formattedYear = DateFormat.y().format(DateTime(DateTime.now().year, month));

              return ListTile(
                title: Text(
                  '$formattedMonth $formattedYear',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Total Pengeluaran: $totalExpense',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
