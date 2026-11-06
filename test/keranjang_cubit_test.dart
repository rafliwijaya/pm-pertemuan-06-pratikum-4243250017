import 'package:flutter_test/flutter_test.dart';
import 'package:pm_p6_pratikum_4243250017/data.dart';
import 'package:pm_p6_pratikum_4243250017/keranjang_cubit.dart';

void main() {
  test('Cubit: tambah dan kurangi memperbarui state dengan benar', () {
    final cubit = KeranjangCubit();

    cubit.tambah(daftarProduk[0]);
    cubit.tambah(daftarProduk[0]);
    cubit.tambah(daftarProduk[1]);

    expect(cubit.state.jumlahItem, 3);
    expect(cubit.state.total, 45000 * 2 + 80000);

    cubit.kurangi(daftarProduk[0]);
    expect(cubit.state.jumlahDari(1), 1);
    expect(cubit.state.jumlahItem, 2);

    cubit.close();
  });
}