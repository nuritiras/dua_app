import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/token_servisi.dart';

class DuaKarti extends StatefulWidget {
  final int duaId;
  final String kullaniciAdi;
  final String icerik;
  final int baslangicBegeniSayisi;
  final bool baslangicKullaniciBegendiMi;

  const DuaKarti({
    super.key,
    required this.duaId,
    required this.kullaniciAdi,
    required this.icerik,
    required this.baslangicBegeniSayisi,
    required this.baslangicKullaniciBegendiMi,
  });

  @override
  _DuaKartiState createState() => _DuaKartiState();
}

class _DuaKartiState extends State<DuaKarti> {
  late int _begeniSayisi;
  late bool _kullaniciBegendiMi;
  bool _islemDevamEdiyor = false;

  @override
  void initState() {
    super.initState();
    _begeniSayisi = widget.baslangicBegeniSayisi;
    _kullaniciBegendiMi = widget.baslangicKullaniciBegendiMi;
  }

  Future<void> _begeniGuncelle() async {
    if (_islemDevamEdiyor) return;

    setState(() {
      _islemDevamEdiyor = true;
      _kullaniciBegendiMi ? _begeniSayisi-- : _begeniSayisi++;
      _kullaniciBegendiMi = !_kullaniciBegendiMi;
    });

    try {
      final token = await TokenServisi().tokenGetir();
      final url = Uri.parse('http://127.0.0.1:8000/api/dualar/${widget.duaId}/begen/');
      final response = await http.post(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode != 200 && response.statusCode != 201) _islemGeriAl();
    } catch (e) {
      _islemGeriAl();
    } finally {
      _islemDevamEdiyor = false;
    }
  }

  void _islemGeriAl() {
    setState(() {
      _kullaniciBegendiMi ? _begeniSayisi-- : _begeniSayisi++;
      _kullaniciBegendiMi = !_kullaniciBegendiMi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.icerik),
        subtitle: Text('Paylaşan: ${widget.kullaniciAdi}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$_begeniSayisi'),
            IconButton(
              icon: Icon(
                _kullaniciBegendiMi ? Icons.favorite : Icons.favorite_border,
                color: _kullaniciBegendiMi ? Colors.red : Colors.grey,
              ),
              onPressed: _begeniGuncelle,
            ),
          ],
        ),
      ),
    );
  }
}