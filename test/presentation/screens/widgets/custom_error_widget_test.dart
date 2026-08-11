import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/presentation/screens/widgets/custom_error_widget.dart';

void main() {
  const tryAgainMessage = 'Tente novamente.';
  const errorMessage = 'Ocorreu um erro!';

  Future<void> pumpWidget(WidgetTester tester, Failure error) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CustomErrorWidget(error: error)),
      ),
    );
  }

  testWidgets('renders correctly when error type is connection', (
    tester,
  ) async {
    await pumpWidget(tester, const ConnectionError());

    expect(find.byIcon(Icons.signal_wifi_off), findsOneWidget);
    expect(find.text('Erro de conexão!'), findsOneWidget);
    expect(find.text('Confira sua conexão e tente novamente.'), findsOneWidget);
  });

  testWidgets('renders correctly when error type is api', (tester) async {
    await pumpWidget(tester, const HttpError());

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.text(tryAgainMessage), findsOneWidget);
  });

  testWidgets('renders correctly when error type is unknown', (tester) async {
    await pumpWidget(tester, const GenericError());

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.text(tryAgainMessage), findsNothing);
  });
}
