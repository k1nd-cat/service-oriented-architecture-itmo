package ru.itmo.soa.movie.controller;

import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.itmo.soa.movie.annotation.DeprecatedEndpoint;
import ru.itmo.soa.movie.api.publicapi.MoviesApi;
import ru.itmo.soa.movie.dto.publicapi.*;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.service.MovieService;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class MoviesController implements MoviesApi {

    private final MovieService movieService;
    private final ModelMapper modelMapper;

    @Override
    public ResponseEntity<GetMoviesWithFilters200Response> getMoviesWithFilters(
            Integer page,
            Integer size,
            MovieSearchRequest movieSearchRequest) {
        
        if (page == null) page = 1;
        if (size == null) size = 20;
        
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
        
        GetMoviesWithFilters200Response response = new GetMoviesWithFilters200Response();
        response.setContent(moviesPage.getContent().stream()
                .map(entity -> modelMapper.map(entity, Movie.class))
                .collect(Collectors.toList()));
        response.setPage(moviesPage.getNumber() + 1);
        response.setSize(moviesPage.getSize());
        response.setTotalElements((int) moviesPage.getTotalElements());
        response.setTotalPages(moviesPage.getTotalPages());
        
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<Movie> createMovie(MovieRequest movieRequest) {
        MovieEntity entity = modelMapper.map(movieRequest, MovieEntity.class);
        MovieEntity created = movieService.createMovie(entity);
        return ResponseEntity.status(HttpStatus.CREATED).body(modelMapper.map(created, Movie.class));
    }

    @Override
    public ResponseEntity<Movie> getMovieById(Integer id) {
        MovieEntity movie = movieService.getMovieById(id.longValue());
        return ResponseEntity.ok(modelMapper.map(movie, Movie.class));
    }

    @Override
    public ResponseEntity<Movie> updateMovie(Integer id, MovieRequest movieRequest) {
        MovieEntity entity = modelMapper.map(movieRequest, MovieEntity.class);
        MovieEntity updated = movieService.updateMovie(id.longValue(), entity);
        return ResponseEntity.ok(modelMapper.map(updated, Movie.class));
    }

    @Override
    public ResponseEntity<Void> deleteMovie(Integer id) {
        movieService.deleteMovie(id.longValue());
        return ResponseEntity.noContent().build();
    }

    @Override
    @DeprecatedEndpoint(see = "/api/v2/movies/calculate-total-length")
    public ResponseEntity<CalculateTotalLength200Response> calculateTotalLength() {
        Long totalLength = movieService.calculateTotalLength();
        
        CalculateTotalLength200Response response = new CalculateTotalLength200Response();
        response.setTotalLength(totalLength);
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<CountMoviesByGenre200Response> countMoviesByGenre(
            CountMoviesByGenreRequest request) {
        long count = movieService.countByGenre(
                modelMapper.map(request.getGenre(), ru.itmo.soa.movie.entity.enums.MovieGenre.class));
        
        CountMoviesByGenre200Response response = new CountMoviesByGenre200Response();
        response.setGenre(request.getGenre());
        response.setCount((int) count);
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<List<Movie>> searchMoviesByName(
            SearchMoviesByNameRequest request) {
        List<MovieEntity> movies = movieService.searchByNamePrefix(
                request.getNamePrefix());
        
        return ResponseEntity.ok(movies.stream()
                .map(entity -> modelMapper.map(entity, Movie.class))
                .collect(Collectors.toList()));
    }

    @Override
    public ResponseEntity<List<Movie>> getAllMovies() {
        List<MovieEntity> movies = movieService.getAllMovies();
        return ResponseEntity.ok(movies.stream()
                .map(entity -> modelMapper.map(entity, Movie.class))
                .collect(Collectors.toList()));
    }
}
