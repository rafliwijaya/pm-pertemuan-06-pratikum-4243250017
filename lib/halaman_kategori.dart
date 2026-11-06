// ┌──────────────────────────────────────────────────────────────┐
// │  TANTANGAN 2: File BARU — halaman daftar produk per kategori │
// └──────────────────────────────────────────────────────────────┘

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'data.dart';

class HalamanKategori extends StatelessWidget {
  const HalamanKategori({super.key, required this.kategori});

  final String kategori;

  @override
  Widget build(BuildContext context) {
    // Filter produk berdasarkan kategori (case-insensitive)
    final produkKategori = daftarProduk
        .where((p) => p.kategori.toLowerCase() == kategori.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Kategori: $kategori')),
      body: produkKategori.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off, size: 64),
                  const SizedBox(height: 16),
                  Text('Tidak ada produk dalam kategori "$kategori"'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Kembali ke katalog'),
                  ),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final kolom = switch (constraints.maxWidth) {
                  < 600 => 2,
                  < 900 => 3,
                  _ => 4,
                };
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kolom,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: produkKategori.length,
                  itemBuilder: (context, i) {
                    final produk = produkKategori[i];
                    final teks = Theme.of(context).textTheme;
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.go('/produk/${produk.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                color: produk.warna.withValues(alpha: 0.15),
                                child: Icon(produk.ikon, size: 56,
                                    color: produk.warna),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(produk.nama, style: teks.titleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(produk.harga.rupiah,
                                      style: teks.bodyMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}