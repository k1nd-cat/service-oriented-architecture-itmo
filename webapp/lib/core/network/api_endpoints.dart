class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://158.160.85.230:8443';

  static String moviesFilters = '/movies/filters';
  static const String createMovie = '/movies';
  static String updateMovieById(String id) => '/movies/$id';
  static String getMovieById(String id) => '/movies/$id';
  static String deleteMovieById(String id) => '/movies/$id';
  static const String calculateTotalMoviesLength = '/movies/calculate-total-length';
  static const String calculateMoviesCountByGenre = '/movies/count-by-genre';
  static const String searchMovieByName = '/movies/search-by-name';

  static const String getLosersDirectorsList = '/oscar/directors/get-loosers';
  static String humiliateOscarsByGenre(String genre) => '/oscar/directors/humiliate-by-genre/$genre';
}