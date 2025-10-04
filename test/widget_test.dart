import 'package:flutter_test/flutter_test.dart';

import 'package:badminton_profiles/player_app_manager.dart';

void main() {
  testWidgets('renders player list header', (WidgetTester tester) async {
    await tester.pumpWidget(const PlayerAppManager());

    expect(find.text('All Players'), findsOneWidget);
  });
}
