import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter_example/main.dart';

void main() {
  testWidgets('shows_the_catalog', (tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('HealthConnectReporter'), findsOneWidget);
    expect(find.text('availability'), findsOneWidget);
  });
}
