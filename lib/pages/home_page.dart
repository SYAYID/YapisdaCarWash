import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tes/pages/about_page.dart';
import 'package:tes/pages/detail_page.dart';
import 'package:tes/pages/edit_page.dart';
import 'package:tes/pages/expense_income.dart';
import 'package:tes/pages/setting_page.dart';
import 'package:tes/pages/statistik.dart';
import 'login.dart';
import 'input_data.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SortingOption {
  sortByPlatKendaraan,
  sortByDateAscending,
  sortByDateDescending,
  sortByMonthAscending,
  sortByMonthDescending,
}


class _HomePageState extends State<HomePage> {
  SortingOption _sortingOption = SortingOption.sortByPlatKendaraan;
  TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _stream;
  Timer? _idleTimer;
  int _idleTimeInMinutes = 5;
  int _idleTimeout = 0;



  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  String? _getUserDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  void _updateStream() {
    setState(() {
      Query collectionRef = FirebaseFirestore.instance.collection('catatan');

      switch (_sortingOption) {
        case SortingOption.sortByPlatKendaraan:
          _stream = collectionRef.orderBy('plat_kendaraan').snapshots();
          break;
        case SortingOption.sortByDateAscending:
          _stream =
              collectionRef.orderBy('timestamp', descending: false).snapshots();
          break;
        case SortingOption.sortByDateDescending:
          _stream =
              collectionRef.orderBy('timestamp', descending: true).snapshots();
          break;
        case SortingOption.sortByMonthAscending:
          _stream =
              collectionRef.orderBy('timestamp', descending: false).snapshots();
          break;
        case SortingOption.sortByMonthDescending:
          _stream =
              collectionRef.orderBy('timestamp', descending: true).snapshots();
          break;
        default:
          _stream = collectionRef.orderBy('plat_kendaraan').snapshots();
          break;
      }
    });
  }




  void _sortData(SortingOption option) {
    setState(() {
      _sortingOption = option;
      _updateStream();
    });
  }

  void _searchData(String keyword) {
    setState(() {
      _stream = FirebaseFirestore.instance
          .collection('catatan')
          .where('plat_kendaraan', isEqualTo: keyword)
          .snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateStream();
    _startIdleTimer();
  }

  @override
  void dispose() {
    _stopIdleTimer();
    super.dispose();
  }

  void _startIdleTimer() {
    _idleTimeout = _idleTimeInMinutes * 500;
    _idleTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _idleTimeout--;
        if (_idleTimeout <= 0) {
          _logout();
        }
      });
    });
  }

  void _resetIdleTimer() {
    _idleTimeout = _idleTimeInMinutes * 60;
  }

  void _stopIdleTimer() {
    _idleTimer?.cancel();
  }





  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.4;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(headerHeight),
            child: AppBar(
              title: Text(
                'Yapisda Car Wash',
                style: TextStyle(
                  fontWeight: FontWeight.bold ,
                  fontSize: 23,
                  fontFamily: 'JosefinSansReg',
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
                child: Column(
                  children: [
                    SizedBox(height: headerHeight * 0.3),
                    CarouselSlider(
                      items: [
                        // List gambar untuk slideshow
                        Image.asset('assets/images/1.png'),
                        Image.asset('assets/images/2.png'),
                        Image.asset('assets/images/3.png'),
                        Image.asset('assets/images/4.png'),
                        Image.asset('assets/images/6.png'),
                      ],
                      options: CarouselOptions(
                        height: headerHeight * 0.6, // Tinggi slideshow sesuai dengan tinggi header
                        viewportFraction: 1.0, // Menampilkan satu gambar sekaligus
                        autoPlay: true, // Otomatis memutar slideshow
                        autoPlayInterval: Duration(seconds: 3), // Durasi tiap gambar
                        autoPlayCurve: Curves.easeIn, // Efek transisi gambar
                        enableInfiniteScroll: true, // Memutar slideshow secara tak terbatas
                        pauseAutoPlayOnTouch: true, // Jeda slideshow ketika disentuh
                        enlargeCenterPage: true, // Memperbesar gambar yang ditampilkan di tengah
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Text(
                      'Your Vehicle Cleanliness Is Our Pride!',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'JosefinSansReg',
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _resetIdleTimer();
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
                        items: [
                          PopupMenuItem(
                            value: SortingOption.sortByPlatKendaraan,
                            child: Text('Sort by Plat Kendaraan'),
                          ),
                          PopupMenuItem(
                            value: SortingOption.sortByDateAscending,
                            child: Text('Sort by Date (Oldest)'),
                          ),
                          PopupMenuItem(
                            value: SortingOption.sortByDateDescending,
                            child: Text('Sort by Date (Latest)'),
                          ),
                          PopupMenuItem(
                            value: SortingOption.sortByMonthAscending,
                            child: Text('Sort by Month (Oldest)'),
                          ),
                          PopupMenuItem(
                            value: SortingOption.sortByMonthDescending,
                            child: Text('Sort by Month (Latest)'),
                          ),
                        ],
                        elevation: 8.0,
                      ).then((value) {
                        if (value != null) {
                          _sortData(value as SortingOption);
                        }
                      });
                    },
                    child: Icon(Icons.sort),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      _resetIdleTimer();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Search"),
                            content: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Masukan plat kendaraan",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  String keyword = _searchController.text.trim();
                                  _searchData(keyword);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Search"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/5.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Login Sebagai',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'JosefinSansReg',
                        ),
                      ),
                      Text(
                        _getUserDisplayName() ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'JosefinSansReg',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    "Home Page",
                    style: TextStyle(
                      fontFamily: 'JosefinSansReg',
                      fontSize: 20,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                SizedBox(height: 15.0),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    "Pengaturan",
                    style: TextStyle(
                      fontFamily: 'JosefinSansReg',
                      fontSize: 20,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
                SizedBox(height: 15.0),
                ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text(
                    "Statistik",
                    style: TextStyle(
                      fontFamily: 'JosefinSansReg',
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatisticPage()),
                    );
                  },
                ),
                SizedBox(height: 15.0),
                ListTile(
                  leading: Icon(Icons.money_off_csred_outlined),
                  title: Text(
                    "Pengeluaran",
                    style: TextStyle(
                      fontFamily: 'JosefinSansReg',
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExpenseFormPage()),
                    );
                  },
                ),
                SizedBox(height: 15.0),
                ListTile(
                  leading: Icon(Icons.business_sharp),
                  title: Text(
                    "About",
                    style: TextStyle(
                      fontFamily: 'JosefinSansReg',
                      fontSize: 20,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutYapisdaCarWash())
                    );
                  },
                ),
                SizedBox(height: 15.0),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: 'JosefinSansReg',
                      fontSize: 20,
                    ),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Tab(
                child: Container(
                  color: Colors.red,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final documents = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final document = documents[index];
                            final data = document.data() as Map<String, dynamic>;
                            final timestamp = data['timestamp'] as Timestamp;
                            final creationDate = timestamp.toDate();
                            final formattedDate =
                            DateFormat('dd-MM-yyyy').format(creationDate);

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 10.0,
                              ),
                              child: Card(
                                elevation: 40,
                                color: Colors.black45,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 5.0,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(data: data),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(data['url']),
                                  ),
                                  title: Text(
                                    data['plat_kendaraan'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'JosefinSansReg',
                                    ),
                                  ),
                                  subtitle: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JosefinSansReg',
                                      fontSize: 10,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => EditPage(documentId: document.id))
                                          );

                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Hapus Data"),
                                                content: Text("Anda yakin ingin menghapus data ini?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Batal"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('catatan')
                                                          .doc(document.id)
                                                          .delete()
                                                          .then((value) {
                                                        Navigator.of(context).pop();
                                                      }).catchError((error) {
                                                        Navigator.of(context).pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Error"),
                                                              content: Text("Gagal menghapus data. Silakan coba lagi."),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text("OK"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      });
                                                    },
                                                    child: Text("Hapus"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 15, right: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  _resetIdleTimer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentFormScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Tambah Data',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}