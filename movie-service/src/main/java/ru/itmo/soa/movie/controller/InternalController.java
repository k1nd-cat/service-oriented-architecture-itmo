package ru.itmo.soa.movie.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.mapper.DtoMapper;
import ru.itmo.soa.movie.service.MovieService;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class InternalController {

    private final MovieService movieService;
    private final DtoMapper dtoMapper;

    @GetMapping("/internal/movies")
    public ResponseEntity<List<ru.itmo.soa.movie.dto.internal.Movie>> getAllMoviesInternal() {
        List<MovieEntity> movies = movieService.getAllMovies();
        return ResponseEntity.ok(dtoMapper.fromMovieEntityListInternal(movies));
    }
}

