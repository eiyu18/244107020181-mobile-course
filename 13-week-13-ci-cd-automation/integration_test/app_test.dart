import 'package:campus_notify/features/announcements/domain/usecases/search_announcements.dart';
import 'package:campus_notify/features/announcements/presentation/pages/announcement_page.dart';
import 'package:campus_notify/features/announcements/presentation/pages/home_page.dart';
import 'package:campus_notify/features/announcements/presentation/providers/announcement_search_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

const _testAnnouncements = <AnnouncementSummary>[
  (id: '1', title: 'Welcome to Campus Notify'),
  (id: '2', title: 'Campus Events'),
  (id: '3', title: 'Library Hours'),
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('search, clear, and open announcement details', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomePage()),
        GoRoute(
          path: '/announcement/:id',
          builder: (_, state) =>
              AnnouncementPage(id: state.pathParameters['id'] ?? ''),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          announcementSummariesProvider.overrideWithValue(_testAnnouncements),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('announcement-search-field')),
      'Library',
    );
    await tester.pumpAndSettle();
    expect(find.text('Library Hours'), findsOneWidget);
    expect(find.text('Campus Events'), findsNothing);

    await tester.tap(find.byKey(const Key('clear-search-button')));
    await tester.pumpAndSettle();
    expect(find.text('Campus Events'), findsOneWidget);

    await tester.tap(find.text('Welcome to Campus Notify'));
    await tester.pumpAndSettle();
    expect(find.text('Details for announcement 1'), findsOneWidget);
  });
}
