import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class StatsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {

    await Future.delayed(const Duration(seconds: 2));


    final shouldFail = Random().nextDouble() < 0.30;
    if (shouldFail) {
      throw Exception('Server timeout while fetching statistics.');
    }


    return [
      'Active Users: 1,204',
      'Revenue: \$4,392',
      'Uptime: 99.9%',
    ];
  }
}


final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<String>>(StatsNotifier.new);