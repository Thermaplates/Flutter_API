

````markdown
# 📖 Bestiary of Eldritch Horrors

A Flutter app yang menampilkan daftar monster dari [Open5e API](https://api.open5e.com/monsters/), dengan tampilan modern bertema Lovecraftian yang gelap dan misterius.  

---

## ✨ Fitur

- 🔍 Fetch data monster langsung dari **Open5e API**
- 📑 Tampilan **List** dan **Grid** yang dapat diganti
- 📜 Detail monster lengkap:
  - Nama
  - Tipe & ukuran
  - Challenge rating
  - Atribut & stats
  - Deskripsi & aksi
- 🎨 Gambar monster otomatis dengan [DiceBear Avatars](https://www.dicebear.com/)
- 🖤 UI bertema gelap dengan nuansa coklat dan emas khas **Lovecraftian Horror**

---

## 🚀 Instalasi

1. Pastikan **Flutter** sudah terpasang di perangkatmu.
2. Clone repository ini:

   ```bash
   git clone https://github.com/username/bestiary-eldritch.git
   cd bestiary-eldritch
````

3. Jalankan perintah berikut di terminal:

   ```bash
   flutter pub get
   flutter run
   ```

---

## 🗂 Struktur Kode Utama

* **`Monster`** → Model data monster
* **`MonsterListPage`** → Halaman utama, menampilkan daftar monster (List/Grid)
* **`MonsterDetailPage`** → Halaman detail monster
* **`theme.dart`** → Custom UI dengan tema Lovecraftian

---

## 📡 Sumber Data

* [Open5e API](https://api.open5e.com/monsters/)

---

## 📸 Screenshots

| List View                     | Grid View                     | Detail Monster                    |
| ----------------------------- | ----------------------------- | --------------------------------- |
| ![List](screenshots/list.png) | ![Grid](screenshots/grid.png) | ![Detail](screenshots/detail.png) |

---

## ⚖️ Lisensi

Proyek ini menggunakan lisensi **MIT**.
Silakan gunakan, modifikasi, dan sebarkan dengan bebas.

```


