import 'package:flutter/material.dart';
import 'screens/login_ekrani.dart';

void main() {
  runApp(const DuaUygulamasi());
}

class DuaUygulamasi extends StatelessWidget {
  const DuaUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dua Paylaşım',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginEkrani(), // Başlangıç ekranı
    );
  }
}