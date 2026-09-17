import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';

void main() {
  test('StatsNotifier berjalan dari state loading menuju data atau error', () async {
    // ProviderContainer digunakan untuk menyimpan dan membaca provider di dalam testing
    final container = ProviderContainer();
    
    // Pastikan container dihancurkan setelah test selesai untuk menghindari memory leak
    addTearDown(container.dispose);

    // 1. Verifikasi state awal
    // Saat provider pertama kali dibaca, state asinkronus harus dalam keadaan loading
    expect(container.read(statsProvider).isLoading, true);

    // 2. Eksekusi alur asinkronus
    // Kita menunggu future-nya selesai. Jika gagal (karena probabilitas 30%), 
    // catchError digunakan agar test tidak crash dan bisa melanjutkan pengecekan.
    await container.read(statsProvider.future).catchError((_) => <String>[]);

    // Mengambil state terbaru setelah delay selesai
    final finalState = container.read(statsProvider);

    // 3. Verifikasi kondisi akhir
    // State sudah tidak boleh loading lagi
    expect(finalState.isLoading, false);

    // Karena fungsi disimulasikan secara acak, kita harus menguji 2 kemungkinan output
    if (finalState.hasValue) {
      // Jika masuk probabilitas sukses (70%), list harus memiliki tepat 3 item
      expect(finalState.value, isA<List<String>>());
      expect(finalState.value!.length, 3);
    } else {
      // Jika masuk probabilitas gagal (30%), state harus memiliki error
      expect(finalState.hasError, true);
    }
  });
}