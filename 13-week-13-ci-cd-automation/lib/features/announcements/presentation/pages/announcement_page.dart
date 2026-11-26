import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to home',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text('Announcement $id'),
      ),
      body: Center(child: Text('Details for announcement $id')),
    );
  }
}
