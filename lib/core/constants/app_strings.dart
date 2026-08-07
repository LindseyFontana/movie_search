class AppStrings {
  static const title = 'Filmes';

  static const errors = _AppErrors();
  static const imageSizes = _ImageSizes();
  static const movieSearch = _MovieSearchScreen();
}

class _AppErrors {
  const _AppErrors();

  final connectionTitle = 'Erro de conexão!';
  final connectionSubtitle = 'Confira sua conexão e tente novamente.';

  final apiTitle = 'Ocorreu um erro!';
  final apiSubtitle = 'Tente novamente.';

  final genericTitle = 'Ocorreu um erro!';
}

class _MovieSearchScreen {
  const _MovieSearchScreen();

  final labelText = 'Pesquisar';
  final hintText = 'Digite o título do filme';

  final emptyList = 'Filmes não encontrados';
}

class _ImageSizes {
  const _ImageSizes();

  final posterLarge = "w154";
  final posterSmall = "w92";
  final backDrop = "w780";
}
