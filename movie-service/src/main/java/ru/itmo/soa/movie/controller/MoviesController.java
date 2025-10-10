package ru.itmo.soa.movie.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.itmo.soa.movie.api.publicapi.MoviesApi;
import ru.itmo.soa.movie.dto.publicapi.*;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.mapper.DtoMapper;
import ru.itmo.soa.movie.service.MovieService;

import java.util.*;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class MoviesController implements MoviesApi {

    private final MovieService movieService;
    private final DtoMapper dtoMapper;

    @Override
    public ResponseEntity<MoviesFiltersPost200Response> _moviesFiltersPost(
            Integer page,
            Integer size,
            MovieSearchRequest movieSearchRequest) {
        
        Map<String, Object> filters = new HashMap<>();
        String sortString = null;
        
        if (movieSearchRequest != null) {
            sortString = movieSearchRequest.getSort();
            
            // Extract filters from search request
            if (movieSearchRequest.getName() != null) {
                filters.put("name", movieSearchRequest.getName());
            }
            
            if (movieSearchRequest.getGenre() != null) {
                filters.put("genre", dtoMapper.toMovieGenreEntity(movieSearchRequest.getGenre()));
            }
            
            // Oscars count filter
            if (movieSearchRequest.getOscarsCount() != null) {
                MovieSearchRequestOscarsCount oscarsCount = movieSearchRequest.getOscarsCount();
                if (oscarsCount.getMin() != null) {
                    filters.put("oscarsCountMin", oscarsCount.getMin());
                }
                if (oscarsCount.getMax() != null) {
                    filters.put("oscarsCountMax", oscarsCount.getMax());
                }
            }
            
            // Total box office filter
            if (movieSearchRequest.getTotalBoxOffice() != null) {
                MovieSearchRequestTotalBoxOffice boxOffice = movieSearchRequest.getTotalBoxOffice();
                if (boxOffice.getMin() != null) {
                    filters.put("totalBoxOfficeMin", boxOffice.getMin());
                }
                if (boxOffice.getMax() != null) {
                    filters.put("totalBoxOfficeMax", boxOffice.getMax());
                }
            }
            
            // Length filter
            if (movieSearchRequest.getLength() != null) {
                MovieSearchRequestLength length = movieSearchRequest.getLength();
                if (length.getMin() != null) {
                    filters.put("lengthMin", length.getMin());
                }
                if (length.getMax() != null) {
                    filters.put("lengthMax", length.getMax());
                }
            }
            
            // Coordinates filter
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
            
            // Operator filter
            if (movieSearchRequest.getOperator() != null) {
                MovieSearchRequestOperator operator = movieSearchRequest.getOperator();
                if (operator.getName() != null) {
                    filters.put("operatorName", operator.getName());
                }
                if (operator.getNationality() != null) {
                    filters.put("operatorNationality", dtoMapper.toCountryEntity(operator.getNationality()));
                }
            }
        }
        
        Page<MovieEntity> moviesPage = movieService.getAllMovies(filters, sortString, page, size);
        
        MoviesFiltersPost200Response response = new MoviesFiltersPost200Response();
        response.setContent(dtoMapper.fromMovieEntityList(moviesPage.getContent()));
        response.setPage(moviesPage.getNumber() + 1);
        response.setSize(moviesPage.getSize());
        response.setTotalElements((int) moviesPage.getTotalElements());
        response.setTotalPages(moviesPage.getTotalPages());
        
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<Movie> _moviesPost(MovieRequest movieRequest) {
        MovieEntity entity = dtoMapper.toMovieEntity(movieRequest);
        MovieEntity created = movieService.createMovie(entity);
        return ResponseEntity.status(HttpStatus.CREATED).body(dtoMapper.fromMovieEntity(created));
    }

    @Override
    public ResponseEntity<Movie> _moviesIdGet(Integer id) {
        MovieEntity movie = movieService.getMovieById(id.longValue());
        return ResponseEntity.ok(dtoMapper.fromMovieEntity(movie));
    }

    @Override
    public ResponseEntity<Movie> _moviesIdPut(Integer id, MovieRequest movieRequest) {
        MovieEntity entity = dtoMapper.toMovieEntity(movieRequest);
        MovieEntity updated = movieService.updateMovie(id.longValue(), entity);
        return ResponseEntity.ok(dtoMapper.fromMovieEntity(updated));
    }

    @Override
    public ResponseEntity<Void> _moviesIdDelete(Integer id) {
        movieService.deleteMovie(id.longValue());
        return ResponseEntity.noContent().build();
    }

    @Override
    public ResponseEntity<MoviesCalculateTotalLengthPost200Response> _moviesCalculateTotalLengthPost() {
        Long totalLength = movieService.calculateTotalLength();
        
        MoviesCalculateTotalLengthPost200Response response = new MoviesCalculateTotalLengthPost200Response();
        response.setTotalLength(totalLength);
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<MoviesCountByGenrePost200Response> _moviesCountByGenrePost(
            MoviesCountByGenrePostRequest moviesCountByGenrePostRequest) {
        long count = movieService.countByGenre(
                dtoMapper.toMovieGenreEntity(moviesCountByGenrePostRequest.getGenre()));
        
        MoviesCountByGenrePost200Response response = new MoviesCountByGenrePost200Response();
        response.setGenre(moviesCountByGenrePostRequest.getGenre());
        response.setCount((int) count);
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<List<Movie>> _moviesSearchByNamePost(
            MoviesSearchByNamePostRequest moviesSearchByNamePostRequest) {
        List<MovieEntity> movies = movieService.searchByNamePrefix(
                moviesSearchByNamePostRequest.getNamePrefix());
        
        return ResponseEntity.ok(dtoMapper.fromMovieEntityList(movies));
    }
}
