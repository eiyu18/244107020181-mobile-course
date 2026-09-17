import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Class ini mengatur state asinkronus (AsyncValue) yang berisi List of String.
class StatsNotifier extends AsyncNotifier<List<String>> {
  
  /// build() otomatis dipanggil saat provider pertama kali dibaca.
  /// Fungsi ini digunakan untuk menginisialisasi state.
  @override
  Future<List<String>> build() async {
    return _fetchStats();
  }

  /// Fungsi privat untuk mensimulasikan pengambilan data.
  Future<List<String>> _fetchStats() async {
    // Simulasi delay jaringan selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi kemungkinan gagal sebesar 30%
    final isSuccess = Random().nextDouble() > 0.3;
    
    if (!isSuccess) {
      // Melemparkan exception jika masuk ke probabilitas 30% gagal
      throw Exception('Gagal memuat data statistik. Periksa koneksi Anda.');
    }

    // Mengembalikan 3 item jika sukses (probabilitas 70%)
    return [
      'Total Pengguna: 1,502',
      'Pendapatan: Rp 45.000.000',
      'Kunjungan Hari Ini: 8,300',
    ];
  }

  /// Fungsi publik yang bisa dipanggil dari UI untuk mengulang pengambilan data.
  Future<void> retry() async {
    // Set state kembali ke loading agar UI menampilkan spinner
    state = const AsyncValue.loading();
    
    // AsyncValue.guard secara otomatis akan menangkap (catch) error 
    // jika _fetchStats() gagal, dan mengubah state menjadi AsyncError.
    // Jika sukses, state menjadi AsyncData.
    state = await AsyncValue.guard(() => _fetchStats());
  }
}

/// Provider global yang akan digunakan oleh ConsumerWidget di UI.
final statsProvider = AsyncNotifierProvider<StatsNotifier, List<String>>(() {
  return StatsNotifier();
});