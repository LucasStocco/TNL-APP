import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crud_flutter/app.dart';

void main() {
  testWidgets('App inicia e mostra a HomePage', (WidgetTester tester) async {
    // Build do app
    await tester.pumpWidget(const App());

    // Aguarda renderização
    await tester.pumpAndSettle();

    // Verifica se o título da HomePage aparece
    expect(find.text('Minhas Listas'), findsOneWidget);

    // Verifica se existe um FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
