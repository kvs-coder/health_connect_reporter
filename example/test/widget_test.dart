import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/model/availability.dart';
import 'package:health_connect_reporter_example/main.dart';

void main() {
  testWidgets('shows_the_availability', (tester) async {
    await tester.pumpWidget(
      DemoApp(availability: () async => Availability.updateRequired),
    );
    await tester.pumpAndSettle();

    expect(find.text('Health Connect: updateRequired'), findsOneWidget);
  });

  testWidgets('shows_an_error', (tester) async {
    await tester.pumpWidget(
      DemoApp(availability: () async => throw StateError('boom')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Error: Bad state: boom'), findsOneWidget);
  });
}
