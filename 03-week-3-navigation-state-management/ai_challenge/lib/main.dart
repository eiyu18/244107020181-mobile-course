import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';


void main() {
  test('StatsProvider transitions from loading to either data or error', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final initialState = container.read(statsProvider);
    expect(initialState, isA<AsyncLoading<List<String>>>());


    try {
      final data = await container.read(statsProvider.future);
      
      expect(data, isA<List<String>>());
      expect(data.length, 3);
      expect(data.first, 'Active Users: 1,204');
    } catch (e) {

      final errorState = container.read(statsProvider);
      expect(errorState, isA<AsyncError<List<String>>>());
    }
  });
}