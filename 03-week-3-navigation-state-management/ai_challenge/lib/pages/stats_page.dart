import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';

/// Menggunakan ConsumerWidget agar bisa membaca state dari Riverpod
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membaca state saat ini dari statsProvider secara reaktif
    final statsState = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Statistik'),
      ),
      body: Center(
        // .when() adalah fitur dari AsyncValue untuk menangani ke-3 state secara aman
        child: statsState.when(
          // 1. State Loading: Tampilkan spinner
          loading: () => const CircularProgressIndicator(),
          
          // 2. State Error: Tampilkan pesan error dan tombol retry
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  error.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  // Memanggil fungsi retry() dari notifier
                  onPressed: () => ref.read(statsProvider.notifier).retry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
          
          // 3. State Data (Success): Tampilkan ListView berisi 3 item
          data: (stats) => ListView.builder(
            itemCount: stats.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.analytics, color: Colors.blue),
                  title: Text(
                    stats[index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}