import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'data.dart';

class HalamanDetail extends StatelessWidget {
  const HalamanDetail({super.key, required this.produk});

  final Produk? produk;

  @override
  Widget build(BuildContext context) {
    final p = produk;
    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Produk tidak ditemukan')),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Kembali ke katalog'),
          ),
        ),
      );
    }

    final skema = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;
    final gambar = AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        color: p.warna.withValues(alpha: 0.15),
        child: Hero(
          tag: 'produk-ikon-${p.id}',
          child: Icon(p.ikon, size: 120, color: p.warna),
        ),
      ),
    );
    final info = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.nama, style: teks.headlineSmall),
          const SizedBox(height: 8),
          ActionChip(
            label: Text(p.kategori),
            avatar: const Icon(Icons.category, size: 18),
            onPressed: () => context.go('/kategori/${p.kategori}'),
          ),
          const SizedBox(height: 8),
          Text(
            p.harga.rupiah,
            style: teks.titleLarge?.copyWith(color: skema.primary),
          ),
          const SizedBox(height: 16),
          Text(p.deskripsi, style: teks.bodyLarge),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(p.nama)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 700) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: gambar),
                Expanded(child: SingleChildScrollView(child: info)),
              ],
            );
          }
          return ListView(children: [gambar, info]);
        },
      ),
    );
  }
}
