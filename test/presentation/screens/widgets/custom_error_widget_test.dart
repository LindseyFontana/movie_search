import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/constants/app_keys.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/presentation/screens/widgets/custom_error_widget.dart';

void main() {
  const tryAgainMessage = 'Tente novamente.';
  const errorMessage = 'Ocorreu um erro!';
  const retryButtonMessage = 'Tentar novamente';

  Future<void> pumpWidget(
    WidgetTester tester,
    Failure error, {
    VoidCallback? onTryAgain,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomErrorWidget(error: error, onTryAgain: onTryAgain),
        ),
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

  testWidgets('does not render try again button when no callback is provided', (
    tester,
  ) async {
    await pumpWidget(tester, const HttpError());

    expect(find.byKey(AppKeys.errorRetryButton), findsNothing);
  });

  testWidgets('renders try again button and calls callback when pressed', (
    tester,
  ) async {
    var pressed = false;

    await pumpWidget(
      tester,
      const HttpError(),
      onTryAgain: () => pressed = true,
    );

    expect(find.byKey(AppKeys.errorRetryButton), findsOneWidget);
    expect(find.text(retryButtonMessage), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.errorRetryButton));

    expect(pressed, isTrue);
  });
}
