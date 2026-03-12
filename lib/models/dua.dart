class Dua {
  final int id;
  final String kullaniciAdi;
  final String icerik;
  final int begeniSayisi;
  final bool kullaniciBegendiMi;

  Dua({
    required this.id,
    required this.kullaniciAdi,
    required this.icerik,
    required this.begeniSayisi,
    required this.kullaniciBegendiMi,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'],
      kullaniciAdi: json['kullanici']['username'],
      icerik: json['icerik'],
      begeniSayisi: json['begeni_sayisi'],
      kullaniciBegendiMi: json['kullanici_begendi_mi'],
    );
  }
}