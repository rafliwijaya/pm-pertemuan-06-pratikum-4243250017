### pm_p6_pratikum_4243250017
Nama: Muhammad Rafli Wijaya
NIM: 4243250017
Kelas: PSIK 24D

### Perbandingan
| Pertanyaan | Provider | Cubit (flutter_bloc) |
| :--- | :--- | :--- |
| **Berapa berkas/baris yang berubah?** | **3 berkas diubah** (`main.dart`, `halaman_detail.dart`, `pubspec.yaml`), **2 berkas ditambah** (`keranjang_model.dart`, `halaman_keranjang.dart`). Sekitar ~110 baris kode baru. | **3 berkas diubah** (`main.dart`, `halaman_detail.dart`, `pubspec.yaml`), **2 berkas ditambah/diganti** (`keranjang_cubit.dart`, `halaman_keranjang.dart`). Sekitar ~120 baris kode (sedikit lebih panjang karena state immutable). |
| **Di mana logika bisnis berada?** | **Terpusat di dalam class** `KeranjangModel` **yang meng-extends** `ChangeNotifier`. Modifikasi data bersifat mutable (mengubah isi map _isi internal lalu memanggil `notifyListeners()`). | **Terpisah bersih di dalam class** `KeranjangCubit` **yang meng-extends** `Cubit<KeranjangState>`. State bersifat immutable (menghasilkan objek `KeranjangState` baru via `emit()`). |
| **Bagaimana UI mengetahui perubahan?** | Widget mendengarkan lewat `context.watch<T>()` atau `context.select<T, R>()` yang berlangganan langsung ke notifikasi `notifyListeners()`. | Widget mendengarkan aliran stream state baru melalui `BlocBuilder`, `BlocConsumer`, atau `context.select()` yang terpicu saat ada pemanggilan `emit(stateBaru)`. |
| **Mana yang lebih mudah diuji? Mengapa?** | **Mudah. Pengujian** `KeranjangModel` **dapat dilakukan dengan unit test murni** menggunakan `k.addListener()` untuk memantau pemanggilan notifikasi tanpa butuh emulator UI. | **Sangat Mudah & Lebih Stabil. Pengujian Cubit lebih mudah karena state bersifat immutable.** Kita cuman perlu memanggil method dan langsung memeriksa nilai `cubit.state` tanpa perlu callback listener manual. |
| **Mana yang Anda pilih untuk proyek akhir? Mengapa?** | **Cocok jika tim pemula dan aplikasinya berukuran kecil-menengah**, karena kurva belajar rendah dan kode boilerplate sangat minimal. | **Dipilih Cubit/BLoC (Rekomendasi): Untuk proyek akhir skala besar**, Cubit lebih unggul karena pemisahan logika bisnis dari UI sangat tegas, alur state searah mudah ditelusuri (*traceable*), bebas dari efek samping mutasi objek liar (*immutability*), dan standar industri profesional. |
