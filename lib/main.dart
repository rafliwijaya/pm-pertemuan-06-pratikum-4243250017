import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'data.dart';
import 'halaman_detail.dart';
import 'halaman_katalog.dart';
import 'halaman_keranjang.dart';
import 'halaman_tentang.dart';
import 'keranjang_model.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => KeranjangModel(), // Satu state untuk seluruh aplikasi
        child: const KatalogApp(),
      ),
    );

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => KerangkaNavigasi(shell: shell),
      branches: [
        // Tab 1: Katalog
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HalamanKatalog(),
              routes: [
                GoRoute(
                  path: 'produk/:id',
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    return HalamanDetail(
                      produk: id == null ? null : cariProduk(id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // Tab 2: Keranjang Belanja (BARU)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/keranjang',
              builder: (context, state) => const HalamanKeranjang(),
            ),
          ],
        ),

        // Tab 3: Tentang
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tentang',
              builder: (context, state) => const HalamanTentang(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class KatalogApp extends StatelessWidget {
  const KatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Oleh-Oleh Medan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6D4C41)),
      ),
      routerConfig: _router,
    );
  }
}

class KerangkaNavigasi extends StatelessWidget {
  const KerangkaNavigasi({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _pilih(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.sizeOf(context).width;

    // Badge Keranjang: rebuild HANYA saat jumlahItem berubah
    final jumlah = context.select((KeranjangModel k) => k.jumlahItem);
    final ikonKeranjang = Badge.count(
      count: jumlah,
      isLabelVisible: jumlah > 0,
      child: const Icon(Icons.shopping_cart_outlined),
    );

    // Layar Lebar (≥ 840 dp): NavigationRail di Samping
    if (lebar >= 840) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _pilih,
              labelType: NavigationRailLabelType.all,
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront),
                  label: Text('Katalog'),
                ),
                NavigationRailDestination(
                  icon: ikonKeranjang,
                  selectedIcon: Badge.count(
                    count: jumlah,
                    isLabelVisible: jumlah > 0,
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: const Text('Keranjang'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: Text('Tentang'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }

    // Layar Sempit (< 840 dp): NavigationBar di Bawah
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _pilih,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: ikonKeranjang,
            selectedIcon: Badge.count(
              count: jumlah,
              isLabelVisible: jumlah > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
          const NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}