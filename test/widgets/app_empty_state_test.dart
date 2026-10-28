import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sertech/core/widgets/app_empty_state.dart';

void main() {
  testWidgets('renders title and description', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppEmptyState(title: 'Titre', description: 'Description'),
        ),
      ),
    );
    expect(find.text('Titre'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
  });
}
