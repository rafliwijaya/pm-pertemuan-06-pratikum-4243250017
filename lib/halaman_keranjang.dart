import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import 'data.dart';
import 'keranjang_cubit.dart';

class HalamanKeranjang extends StatelessWidget {
  const HalamanKeranjang({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KeranjangCubit, KeranjangState>(
      listenWhen: (previous, current) =>
          previous.jumlahItem > 0 && current.jumlahItem == 0,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan dibuat (simulasi)')),
        );
      },
      builder: (context, state) {
        final isi = state.isi.entries.toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Keranjang Belanja (Cubit)')),
          body: isi.isEmpty
              ? const Center(child: Text('Keranjang masih kosong'))
              : ListView.separated(
                  itemCount: isi.length,
                  separatorBuilder: (context, i) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final e = isi[i];
                    final p = cariProduk(e.key)!;
                    final subtotal = p.harga * e.value;

                    return ListTile(
                      leading: Icon(p.ikon, color: p.warna),
                      title: Text(p.nama),
                      subtitle: Text(subtotal.rupiah),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () =>
                                context.read<KeranjangCubit>().kurangi(p),
                          ),
                          Text('${e.value}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () =>
                                context.read<KeranjangCubit>().tambah(p),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          bottomNavigationBar: isi.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total: ${state.total.rupiah}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            context.read<KeranjangCubit>().kosongkan();
                          },
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}