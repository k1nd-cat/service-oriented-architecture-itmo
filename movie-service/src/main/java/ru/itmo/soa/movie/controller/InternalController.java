package ru.itmo.soa.movie.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.itmo.soa.movie.api.internal.InternalApi;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.mapper.DtoMapper;
import ru.itmo.soa.movie.service.MovieService;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class InternalController implements InternalApi {

    private final MovieService movieService;
    private final DtoMapper dtoMapper;

    @Override
    public ResponseEntity<List<ru.itmo.soa.movie.dto.internal.Movie>> _internalMoviesGet() {
        List<MovieEntity> movies = movieService.getAllMovies();
        return ResponseEntity.ok(dtoMapper.fromMovieEntityListInternal(movies));
    }
}

