import 'package:flutter_test/flutter_test.dart';
import 'package:ag12_sqlite/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const AG12App());

    expect(find.text('Gestión de Usuarios'), findsOneWidget);
    expect(find.text('AG12 - Bases de datos con SQLite'), findsOneWidget);
  });
}