import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'data.dart';

class HalamanKatalog extends StatefulWidget {
  const HalamanKatalog({super.key});

  @override
  State<HalamanKatalog> createState() => _HalamanKatalogState();
}

class _HalamanKatalogState extends State<HalamanKatalog> {
  String? _kategoriTerpilih;
  List<String> get _semuaKategori {
    final set = <String>{};
    for (final p in daftarProduk) {
      set.add(p.kategori);
    }
    return set.toList()..sort();
  }

  List<Produk> get _produkTerfilter {
    if (_kategoriTerpilih == null) return daftarProduk;
    return daftarProduk.where((p) => p.kategori == _kategoriTerpilih).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oleh-Oleh Medan')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Semua'),
                    selected: _kategoriTerpilih == null,
                    onSelected: (selected) {
                      setState(() => _kategoriTerpilih = null);
                    },
                  ),
                ),
                // Chip per kategori
                for (final kategori in _semuaKategori)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(kategori),
                      selected: _kategoriTerpilih == kategori,
                      onSelected: (selected) {
                        setState(() {
                          _kategoriTerpilih = selected ? kategori : null;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final kolom = switch (constraints.maxWidth) {
                  < 600 => 2,
                  < 900 => 3,
                  _ => 4,
                };
                final produk = _produkTerfilter;
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kolom,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: produk.length,
                  itemBuilder: (context, i) => KartuProduk(produk: produk[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// KartuProduk TIDAK BERUBAH dari template
class KartuProduk extends StatelessWidget {
  const KartuProduk({super.key, required this.produk});

  final Produk produk;

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/produk/${produk.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: produk.warna.withValues(alpha: 0.15),
                child: Hero(
                  tag: 'produk-ikon-${produk.id}',
                  child: Icon(produk.ikon, size: 56, color: produk.warna),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    style: teks.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(produk.harga.rupiah, style: teks.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
