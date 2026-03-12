import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/token_servisi.dart';
import 'ana_ekran.dart';

class LoginEkrani extends StatefulWidget {
  const LoginEkrani({super.key});

  @override
  _LoginEkraniState createState() => _LoginEkraniState();
}

class _LoginEkraniState extends State<LoginEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _kullaniciAdiController = TextEditingController();
  final _sifreController = TextEditingController();
  bool _yukleniyor = false;

  Future<void> _girisYap() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _yukleniyor = true);

    final url = Uri.parse('http://127.0.0.1:8000/api/token/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _kullaniciAdiController.text,
          'password': _sifreController.text,
        }),
      );

      if (response.statusCode == 200) {
        final veriler = jsonDecode(response.body);
        await TokenServisi().tokenKaydet(veriler['access']);
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AnaEkran())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hatalı giriş!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bağlantı hatası: $e')),
      );
    } finally {
      setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _kullaniciAdiController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                validator: (v) => v!.isEmpty ? 'Boş olamaz' : null,
              ),
              TextFormField(
                controller: _sifreController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Şifre'),
                validator: (v) => v!.isEmpty ? 'Boş olamaz' : null,
              ),
              const SizedBox(height: 32),
              _yukleniyor
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _girisYap, child: const Text('Giriş')),
            ],
          ),
        ),
      ),
    );
  }
}