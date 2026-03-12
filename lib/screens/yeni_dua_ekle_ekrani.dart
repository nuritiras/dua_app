import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Platform kontrolü için eklendi
import '../services/token_servisi.dart';

// Eğer ApiConfig sınıfını ayrı bir dosyaya (örn: constants.dart) koyduysanız,
// o dosyayı import edip bu tanımlamayı silebilirsiniz.
class ApiConfig {
  static String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:8000/api/';
    if (Platform.isIOS) return 'http://127.0.0.1:8000/api/';
    return 'http://127.0.0.1:8000/api/';
  }
}

class YeniDuaEkleEkrani extends StatefulWidget {
  // 1. DÜZELTME: Linter uyarısı için (Constructors for public widgets should have a named 'key' parameter)
  const YeniDuaEkleEkrani({super.key});

  @override
  State<YeniDuaEkleEkrani> createState() => _YeniDuaEkleEkraniState();
}

class _YeniDuaEkleEkraniState extends State<YeniDuaEkleEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _icerikController = TextEditingController();
  bool _yukleniyor = false;

  // Bellek yönetimi: Controller ile işimiz bitince hafızadan siliyoruz
  @override
  void dispose() {
    _icerikController.dispose();
    super.dispose();
  }

  Future<void> _duaPaylas() async {
    // Form doğrulamasından geçemezse fonksiyonu durdur
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _yukleniyor = true);

    try {
      final token = await TokenServisi().tokenGetir();
      // 2. DÜZELTME: Sabit IP yerine iOS/Android uyumlu dinamik URL kullanımı
      final url = Uri.parse('${ApiConfig.baseUrl}dualar/');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'icerik': _icerikController.text}),
      );

      // 3. DÜZELTME: "Don't use BuildContexts across async gaps" uyarısı için.
      // Await sonrasında widget'ın hala ekranda olup olmadığını kontrol ediyoruz.
      if (!mounted) return;

      if (response.statusCode == 201) {
        // İşlem başarılıysa önceki ekrana dön ve sayfayı yenilemesi için 'true' gönder
        Navigator.pop(context, true); 
      } else {
        // Django'dan 401 (Yetkisiz) veya 400 (Kötü İstek) gibi bir hata gelirse kullanıcıya göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt başarısız! Hata Kodu: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Catch bloğu içindeki ScaffoldMessenger için de mounted kontrolü şart
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bağlantı Hatası: $e')),
      );
    } finally {
      // Yüklenme animasyonunu durdurmadan önce yine ekranda mıyız diye bakıyoruz
      if (mounted) {
        setState(() => _yukleniyor = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Dua'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _icerikController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'İçeriği buraya yazın...',
                ),
                validator: (v) {
                  // Sadece boşluk girilmesini engellemek için trim() ekledik
                  if (v == null || v.trim().isEmpty) {
                    return 'Boş bırakılamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _yukleniyor
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _duaPaylas, 
                      child: const Text('Paylaş'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}