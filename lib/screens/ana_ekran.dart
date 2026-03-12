import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/dua.dart';
import '../services/token_servisi.dart';
import '../widgets/dua_karti.dart';
import 'yeni_dua_ekle_ekrani.dart';
import 'login_ekrani.dart';

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  late Future<List<Dua>> _dualarFuture;

  @override
  void initState() {
    super.initState();
    _dualarFuture = _dualariGetir();
  }

  Future<List<Dua>> _dualariGetir() async {
    final token = await TokenServisi().tokenGetir();
    final url = Uri.parse('http://127.0.0.1:8000/api/dualar/');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((d) => Dua.fromJson(d)).toList();
    } else {
      throw Exception('Veri çekilemedi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dualar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await TokenServisi().tokenSil();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginEkrani())
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<Dua>>(
        future: _dualarFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final dualar = snapshot.data!;
            return ListView.builder(
              itemCount: dualar.length,
              itemBuilder: (context, index) {
                final dua = dualar[index];
                return DuaKarti(
                  duaId: dua.id,
                  kullaniciAdi: dua.kullaniciAdi,
                  icerik: dua.icerik,
                  baslangicBegeniSayisi: dua.begeniSayisi,
                  baslangicKullaniciBegendiMi: dua.kullaniciBegendiMi,
                );
              },
            );
          }
          return const Center(child: Text('Veri yok.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final sonuc = await Navigator.push(
            context, MaterialPageRoute(builder: (_) => YeniDuaEkleEkrani())
          );
          if (sonuc == true) {
            setState(() { _dualarFuture = _dualariGetir(); });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
