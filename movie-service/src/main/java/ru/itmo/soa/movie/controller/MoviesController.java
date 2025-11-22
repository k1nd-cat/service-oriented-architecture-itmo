package ru.itmo.soa.movie.controller;

import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.itmo.soa.movie.annotation.DeprecatedEndpoint;
import ru.itmo.soa.movie.dto.publicapi.*;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.service.MovieService;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class MoviesController {

    private final MovieService movieService;
    private final ModelMapper modelMapper;

    @PostMapping("/movies/filters")
    public ResponseEntity<MoviesFiltersPost200Response> getMoviesWithFilters(
            @RequestParam(value = "page", required = false, defaultValue = "1") Integer page,
            @RequestParam(value = "size", required = false, defaultValue = "20") Integer size,
            @RequestBody(required = false) MovieSearchRequest movieSearchRequest) {
        
        Map<String, Object> filters = new HashMap<>();
        String sortString = null;
        
        if (movieSearchRequest != null) {
            sortString = movieSearchRequest.getSort();
            
            if (movieSearchRequest.getName() != null) {
                filters.put("name", movieSearchRequest.getName());
            }
            
            if (movieSearchRequest.getGenre() != null) {
                filters.put("genre", modelMapper.map(movieSearchRequest.getGenre(), 
                    ru.itmo.soa.movie.entity.enums.MovieGenre.class));
            }
            
            if (movieSearchRequest.getOscarsCount() != null) {
                MovieSearchRequestOscarsCount oscarsCount = movieSearchRequest.getOscarsCount();
                if (oscarsCount.getMin() != null) {
                    filters.put("oscarsCountMin", oscarsCount.getMin());
                }
                if (oscarsCount.getMax() != null) {
                    filters.put("oscarsCountMax", oscarsCount.getMax());
                }
            }
            
            if (movieSearchRequest.getTotalBoxOffice() != null) {
                MovieSearchRequestTotalBoxOffice boxOffice = movieSearchRequest.getTotalBoxOffice();
                if (boxOffice.getMin() != null) {
                    filters.put("totalBoxOfficeMin", boxOffice.getMin());
                }
                if (boxOffice.getMax() != null) {
                    filters.put("totalBoxOfficeMax", boxOffice.getMax());
                }
            }
            
            if (movieSearchRequest.getLength() != null) {
                MovieSearchRequestLength length = movieSearchRequest.getLength();
                if (length.getMin() != null) {
                    filters.put("lengthMin", length.getMin());
                }
                if (length.getMax() != null) {
                    filters.put("lengthMax", length.getMax());
                }
            }
            
            if (movieSearchRequest.getCoordinates() != null) {
                MovieSearchRequestCoordinates coordinates = movieSearchRequest.getCoordinates();
                if (coordinates.getX() != null) {
                    MovieSearchRequestCoordinatesX x = coordinates.getX();
                    if (x.getMin() != null) {
                        filters.put("coordinatesXMin", x.getMin());
                    }
                    if (x.getMax() != null) {
                        filters.put("coordinatesXMax", x.getMax());
                    }
                }
                if (coordinates.getY() != null) {
                    MovieSearchRequestCoordinatesY y = coordinates.getY();
                    if (y.getMin() != null) {
                        filters.put("coordinatesYMin", y.getMin());
                    }
                    if (y.getMax() != null) {
                        filters.put("coordinatesYMax", y.getMax());
                    }
                }
            }
            
            if (movieSearchRequest.getOperator() != null) {
                MovieSearchRequestOperator operator = movieSearchRequest.getOperator();
                if (operator.getName() != null) {
                    filters.put("operatorName", operator.getName());
                }
                if (operator.getNationality() != null) {
                    filters.put("operatorNationality", modelMapper.map(operator.getNationality(), 
                        ru.itmo.soa.movie.entity.enums.Country.class));
                }
            }
        }
        
        Page<MovieEntity> moviesPage = movieService.getAllMovies(filters, sortString, page, size);
        
        MoviesFiltersPost200Response response = new MoviesFiltersPost200Response();
        response.setContent(moviesPage.getContent().stream()
                .map(entity -> modelMapper.map(entity, Movie.class))
                .collect(Collectors.toList()));
        response.setPage(moviesPage.getNumber() + 1);
        response.setSize(moviesPage.getSize());
        response.setTotalElements((int) moviesPage.getTotalElements());
        response.setTotalPages(moviesPage.getTotalPages());
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/movies")
    public ResponseEntity<Movie> createMovie(@RequestBody MovieRequest movieRequest) {
        MovieEntity entity = modelMapper.map(movieRequest, MovieEntity.class);
        MovieEntity created = movieService.createMovie(entity);
        return ResponseEntity.status(HttpStatus.CREATED).body(modelMapper.map(created, Movie.class));
    }

    @GetMapping("/movies/{id}")
    public ResponseEntity<Movie> getMovieById(@PathVariable("id") Integer id) {
        MovieEntity movie = movieService.getMovieById(id.longValue());
        return ResponseEntity.ok(modelMapper.map(movie, Movie.class));
    }

    @PutMapping("/movies/{id}")
    public ResponseEntity<Movie> updateMovie(@PathVariable("id") Integer id, @RequestBody MovieRequest movieRequest) {
        MovieEntity entity = modelMapper.map(movieRequest, MovieEntity.class);
        MovieEntity updated = movieService.updateMovie(id.longValue(), entity);
        return ResponseEntity.ok(modelMapper.map(updated, Movie.class));
    }

    @DeleteMapping("/movies/{id}")
    public ResponseEntity<Void> deleteMovie(@PathVariable("id") Integer id) {
        movieService.deleteMovie(id.longValue());
        return ResponseEntity.noContent().build();
    }

    @DeprecatedEndpoint(see = "/api/v2/movies/calculate-total-length")
    @PostMapping("/movies/calculate-total-length")
    public ResponseEntity<MoviesCalculateTotalLengthPost200Response> calculateTotalLength() {
        Long totalLength = movieService.calculateTotalLength();
        
        MoviesCalculateTotalLengthPost200Response response = new MoviesCalculateTotalLengthPost200Response();
        response.setTotalLength(totalLength);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/movies/count-by-genre")
    public ResponseEntity<MoviesCountByGenrePost200Response> countMoviesByGenre(
            @RequestBody MoviesCountByGenrePostRequest request) {
        long count = movieService.countByGenre(
                modelMapper.map(request.getGenre(), ru.itmo.soa.movie.entity.enums.MovieGenre.class));
        
        MoviesCountByGenrePost200Response response = new MoviesCountByGenrePost200Response();
        response.setGenre(request.getGenre());
        response.setCount((int) count);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/movies/search-by-name")
    public ResponseEntity<List<Movie>> searchMoviesByName(
            @RequestBody MoviesSearchByNamePostRequest request) {
        List<MovieEntity> movies = movieService.searchByNamePrefix(
                request.getNamePrefix());
        
        return ResponseEntity.ok(movies.stream()
                .map(entity -> modelMapper.map(entity, Movie.class))
                .collect(Collectors.toList()));
    }

    @GetMapping("/movies")
    public ResponseEntity<List<Movie>> getAllMovies() {
        List<MovieEntity> movies = movieService.getAllMovies();
        return ResponseEntity.ok(movies.stream()
                .map(entity -> modelMapper.map(entity, Movie.class))
                .collect(Collectors.toList()));
    }
}
