import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/presentation/screens/credits/credits_screen.dart';
import 'package:movie_search/presentation/screens/widgets/back_button_widget.dart';
import 'package:movie_search/presentation/screens/widgets/custom_app_bar.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreditsScreen()));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the app bar correctly', (tester) async {
    await pumpScreen(tester);

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.text('Sobre'), findsOneWidget);
    expect(find.byType(BackButtonWidget), findsOneWidget);
  });

  testWidgets('renders the credits', (tester) async {
    await pumpScreen(tester);

    expect(
      find.text('Aplicação desenvolvida por: \nLindsey Oliva Fontana Schmitz'),
      findsOneWidget,
    );

    expect(
      find.text(
        'Este produto usa a API do TMDB, mas não é endossado nem certificado pelo TMDB.',
      ),
      findsOneWidget,
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
