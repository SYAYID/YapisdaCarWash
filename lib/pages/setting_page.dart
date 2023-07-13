import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isEmailSelected = false;
  bool _isPasswordSelected = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateEmailAndPassword() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        if (_isEmailSelected) {
          await currentUser.updateEmail(_emailController.text);
        }
        if (_isPasswordSelected) {
          await currentUser.updatePassword(_passwordController.text);
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Berhasil'),
              content: Text('Email dan password berhasil diperbarui.'),
              actions: [
                TextButton(
                  child: Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Gagal'),
              content: Text('Terjadi kesalahan saat memperbarui email dan password.'),
              actions: [
                TextButton(
                  child: Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  'Email: ${currentUser?.email ?? ''}',
                  style: TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: 'JosefinSansReg',),
                ),
              ),
              CheckboxListTile(
                title: Text(
                  'Ubah Email',
                  style: TextStyle(color: Colors.black, fontFamily: 'JosefinSansReg',),
                ),
                value: _isEmailSelected,
                onChanged: (value) {
                  setState(() {
                    _isEmailSelected = value ?? false;
                  });
                },
              ),
              if (_isEmailSelected)
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Baru',
                    labelStyle: TextStyle(color: Colors.black, fontFamily: 'JosefinSansReg',),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan masukkan email baru';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black, fontFamily: 'JosefinSansReg',),
                ),
              CheckboxListTile(
                title: Text(
                  'Ubah Password',
                  style: TextStyle(color: Colors.black, fontFamily: 'JosefinSansReg',),
                ),
                value: _isPasswordSelected,
                onChanged: (value) {
                  setState(() {
                    _isPasswordSelected = value ?? false;
                  });
                },
              ),
              if (_isPasswordSelected)
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    labelStyle: TextStyle(color: Colors.black, fontFamily: 'JosefinSansReg', ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan masukkan password baru';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    _updateEmailAndPassword();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.indigo,
                  textStyle: TextStyle(fontSize: 16.0, fontFamily: 'JosefinSansReg',),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text('Perbarui Email dan Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
