class AppStrings {
  static const title = 'Filmes';

  static const errors = _AppErrors();
  static const imageSizes = _ImageSizes();
  static const routes = _RouteNames();
  static const movieSearch = _MovieSearchScreen();
  static const credits = _CreditsScreen();
}

class _AppErrors {
  const _AppErrors();

  final connectionTitle = 'Erro de conexão!';
  final connectionSubtitle = 'Confira sua conexão e tente novamente.';

  final apiTitle = 'Ocorreu um erro!';
  final apiSubtitle = 'Tente novamente.';

  final genericTitle = 'Ocorreu um erro!';

  final retryButton = 'Tentar novamente';
}

class _MovieSearchScreen {
  const _MovieSearchScreen();

  final trendingTitle = "Filmes populares:";
  final searchTitle = "Filmes pesquisados:";

  final labelText = 'Pesquisar';
  final hintText = 'Digite o título do filme';

  final emptyList = 'Filmes não encontrados';
  final ellipsis = "...";
}

class _ImageSizes {
  const _ImageSizes();

  final posterLarge = "w154";
  final posterSmall = "w92";
  final backDrop = "w780";
}

class _RouteNames {
  const _RouteNames();

  final home = "/";
  final credits = "/credits";
  final movieDetails = "/movie_details";
}

class _CreditsScreen {
  const _CreditsScreen();

  final title = "Sobre";
  final author = "Aplicação desenvolvida por: \nLindsey Oliva Fontana Schmitz";
  final tmdbCredits =
      "Este produto usa a API do TMDB, mas não é endossado nem certificado pelo TMDB.";
}
