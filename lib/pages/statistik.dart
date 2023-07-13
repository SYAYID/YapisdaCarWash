import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late Stream<QuerySnapshot> _catatanStream;
  late Stream<QuerySnapshot> _pengeluaranStream;
  Map<String, int> dataCount = {};
  Map<String, int> totalHargaPelayanan = {};
  double totalPengeluaran = 0.0;
  Map<String, double> monthlyExpenses = {};

  @override
  void initState() {
    super.initState();
    _catatanStream = FirebaseFirestore.instance.collection('catatan').snapshots();
    _pengeluaranStream = FirebaseFirestore.instance.collection('pengeluaran').snapshots();
    dataCount = {};
    totalHargaPelayanan = {};
  }

  Map<String, dynamic> _calculateDataCountAndTotalHargaPelayanan(List<QueryDocumentSnapshot> documents) {
    final Map<String, int> dataCount = {};
    final Map<String, int> totalHargaPelayanan = {};

    for (var document in documents) {
      final dataMap = document.data() as Map<String, dynamic>;
      final timestamp = dataMap['timestamp'] as Timestamp;
      final creationDate = timestamp.toDate();
      final month = DateFormat('MMMM').format(creationDate);
      final year = DateFormat('yyyy').format(creationDate);
      final hargaPelayanan = dataMap['harga_pelayanan'] as int;

      final key = '$month $year';

      if (dataCount.containsKey(key)) {
        dataCount[key] = dataCount[key]! + 1;
        totalHargaPelayanan[key] = totalHargaPelayanan[key]! + hargaPelayanan;
      } else {
        dataCount[key] = 1;
        totalHargaPelayanan[key] = hargaPelayanan;
      }
    }

    return {'dataCount': dataCount, 'totalHargaPelayanan': totalHargaPelayanan};
  }

  double _calculateTotalPengeluaran(List<QueryDocumentSnapshot> documents) {
    double total = 0.0;
    monthlyExpenses = {};

    for (var document in documents) {
      final dataMap = document.data() as Map<String, dynamic>;
      final timestamp = dataMap['timestamp'] as Timestamp;
      final creationDate = timestamp.toDate();
      final documentMonth = creationDate.month;
      final documentYear = creationDate.year;
      final hargaPengeluaran = dataMap['amount'] as double;

      final key = '$documentMonth $documentYear';

      if (monthlyExpenses.containsKey(key)) {
        monthlyExpenses[key] = monthlyExpenses[key]! + hargaPengeluaran;
      } else {
        monthlyExpenses[key] = hargaPengeluaran;
      }
    }

    monthlyExpenses.forEach((key, value) {
      final monthYearParts = key.split(' ');
      final documentMonth = int.tryParse(monthYearParts[0]);
      final documentYear = int.tryParse(monthYearParts[1]);
      if (documentMonth != null && documentYear != null) {
        final currentDate = DateTime.now();
        final currentMonth = currentDate.month;
        final currentYear = currentDate.year;
        if (documentMonth == currentMonth && documentYear == currentYear) {
          total += value;
        }
      }
    });

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistik',
          style: TextStyle(
            fontFamily: 'JosefinSansReg',
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).primaryColor,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot>(
          stream: _catatanStream,
          builder: (context, catatanSnapshot) {
            if (catatanSnapshot.hasData && catatanSnapshot.data != null) {
              final catatanDocuments = catatanSnapshot.data!.docs;
              final data = _calculateDataCountAndTotalHargaPelayanan(catatanDocuments);
              dataCount = data['dataCount'];
              totalHargaPelayanan = data['totalHargaPelayanan'];

              return StreamBuilder<QuerySnapshot>(
                stream: _pengeluaranStream,
                builder: (context, pengeluaranSnapshot) {
                  if (pengeluaranSnapshot.hasData && pengeluaranSnapshot.data != null) {
                    final pengeluaranDocuments = pengeluaranSnapshot.data!.docs;
                    totalPengeluaran = _calculateTotalPengeluaran(pengeluaranDocuments);

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 300,
                            child: PieChart(
                              dataMap: dataCount.map((key, value) => MapEntry(key, value.toDouble())),
                              animationDuration: Duration(milliseconds: 800),
                              chartLegendSpacing: 32,
                              chartRadius: MediaQuery.of(context).size.width / 2.0,
                              initialAngleInDegree: 0,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 35,
                              centerText: "Data",
                              legendOptions: LegendOptions(
                                showLegendsInRow: true,
                                legendPosition: LegendPosition.bottom,
                                showLegends: true,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dataCount.length,
                            itemBuilder: (context, index) {
                              final key = dataCount.keys.elementAt(index);
                              final count = dataCount[key];
                              final totalHarga = totalHargaPelayanan[key];
                              final monthlyExpense = monthlyExpenses[key] ?? 0.0;

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 10.0,
                                ),
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 5.0,
                                    ),
                                    leading: Icon(Icons.calendar_today),
                                    title: Text(
                                      key,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:
                                    [
                                    SizedBox(height: 5.0),
                                    Text('Jumlah Data Masuk: $count'),
                                    Text('Total Pemasukan: $totalHarga'),
                                    ],
                                  ),
                                ),
                              ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
