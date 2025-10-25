class ApiEndpoints {
  ApiEndpoints._();

  static const String moviesFilters = '/movies/filters';
  static const String movies = '/movies';
  static const String createMovie = '/movies';
  static String movieById(String id) => '/movies/$id';
  static String updateMovieById(String id) => '/movies/$id';
  static String getMovieById(String id) => '/movies/$id';
  static String deleteMovieById(String id) => '/movies/$id';
  static const String calculateTotalMoviesLength = '/movies/calculate-total-length';
  static const String calculateMoviesCountByGenre = '/movies/count-by-genre';
  static const String searchMovieByName = '/movies/search-by-name';

  static const String getLosersDirectorsList = '/oscar/directors/get-loosers';
  static String humiliateOscarsByGenre(String genre) => '/oscar/directors/humiliate-by-genre/$genre';
}