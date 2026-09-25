import 'package:flutter_test/flutter_test.dart';

import 'package:distributor/main.dart';
import 'package:distributor/providers/auth_provider.dart';

void main() {
  testWidgets('App renders login screen when not authenticated',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authProvider: AuthProvider()));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}