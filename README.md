
# 🤲 Dua Paylaşım Uygulaması (Flutter Frontend)

Bu proje, kullanıcıların birbirlerine dua edebildiği, paylaşılan duaları beğenebildiği ve toplulukla etkileşime girebildiği bir mobil platformun ön yüz (frontend) uygulamasıdır. **Django REST Framework** ile hazırlanan bir backend ile tam entegre çalışacak şekilde tasarlanmıştır.

## 🚀 Özellikler

* **JWT Kimlik Doğrulaması:** Kullanıcı girişi ve güvenli token yönetimi.
* **Dinamik Akış:** Paylaşılan duaların gerçek zamanlı listelenmesi.
* **Beğeni Sistemi:** İyimser arayüz (Optimistic UI) güncellemeleri ile hızlı etkileşim.
* **Güvenli Depolama:** `flutter_secure_storage` ile hassas verilerin saklanması.
* **Platform Uyumluluğu:** Android (10.0.2.2) ve iOS (127.0.0.1) için otomatik API URL yapılandırması.

---

## 📂 Klasör Yapısı

```plaintext
lib/
├── main.dart             # Uygulama giriş noktası ve tema ayarları
├── models/               # Veri modelleri (Dua nesnesi)
├── services/             # Token yönetimi ve API servisleri
├── screens/              # Uygulama sayfaları (Giriş, Ana Sayfa, Ekleme)
├── widgets/              # Tekrar kullanılabilir arayüz bileşenleri (Dua Kartı)
└── pubspec.yaml          # Paket bağımlılıkları ve varlıklar

```

---

## 🛠️ Kurulum ve Çalıştırma

### 1. Ön Gereksinimler

* Flutter SDK (v3.0.0+)
* Dart SDK
* Çalışan bir backend (Django REST Framework önerilir)

### 2. Bağımlılıkları Yükleyin

Proje dizininde terminali açın ve şu komutu çalıştırın:

```bash
flutter pub get

```

### 3. API Ayarları

`lib/screens/yeni_dua_ekle_ekrani.dart` dosyasındaki `ApiConfig` sınıfı, simülatör/emülatör tipine göre otomatik IP seçimi yapar. Eğer gerçek bir cihazda test edecekseniz, bilgisayarınızın yerel IP adresini buraya eklemeyi unutmayın.

### 4. Uygulamayı Başlatın

```bash
flutter run

```

---

## 📦 Temel Bağımlılıklar (Dependencies)

| Paket | Kullanım Amacı |
| --- | --- |
| `http` | Backend API ile iletişim kurmak için. |
| `flutter_secure_storage` | JWT token'larını cihazda şifreli saklamak için. |
| `dart:convert` | JSON verilerini işlemek (encode/decode) için. |

---

## 🖥️ Ekran Görüntüleri ve İş Akışı

1. **Giriş Ekranı:** Kullanıcı adı ve şifre ile JWT token alınır.
2. **Ana Akış:** Tüm dualar listelenir, beğeni sayıları anlık güncellenir.
3. **Dua Paylaş:** Yeni içerik girilir ve otomatik olarak liste yenilenir.
4. **Güvenli Çıkış:** Token silinerek kullanıcı giriş ekranına yönlendirilir.

---

## 🛡️ Güvenlik Notları

* Uygulama, **Secure Storage** kullanarak token'ları düz metin olarak saklamaz.
* Asenkron işlemlerde `mounted` kontrolü yapılarak bellek sızıntıları ve çökme hataları (BuildContext hataları) engellenmiştir.

---

## 🤝 Katkıda Bulunma

1. Bu depoyu çatallayın (Fork).
2. Yeni bir özellik dalı oluşturun (`git checkout -b feature/yeniOzellik`).
3. Değişikliklerinizi kaydedin (`git commit -m 'Yeni özellik eklendi'`).
4. Dalınızı itin (`git push origin feature/yeniOzellik`).
5. Bir Çekme İsteği (Pull Request) oluşturun.

---
