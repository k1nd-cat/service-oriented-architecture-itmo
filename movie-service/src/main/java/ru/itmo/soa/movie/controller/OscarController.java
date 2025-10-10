package ru.itmo.soa.movie.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.itmo.soa.movie.api.publicapi.OscarOperationsApi;
import ru.itmo.soa.movie.dto.publicapi.MovieGenre;
import ru.itmo.soa.movie.dto.publicapi.OscarDirectorsGetLoosersPost200ResponseInner;
import ru.itmo.soa.movie.dto.publicapi.OscarDirectorsHumiliateByGenreGenrePost200Response;
import ru.itmo.soa.movie.mapper.DtoMapper;
import ru.itmo.soa.movie.service.MovieService;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class OscarController implements OscarOperationsApi {

    private final MovieService movieService;
    private final DtoMapper dtoMapper;

    @Override
    public ResponseEntity<List<OscarDirectorsGetLoosersPost200ResponseInner>> _oscarDirectorsGetLoosersPost() {
        List<Map<String, Object>> directors = movieService.getDirectorsWithoutOscars();
        
        List<OscarDirectorsGetLoosersPost200ResponseInner> response = directors.stream()
                .map(director -> {
                    OscarDirectorsGetLoosersPost200ResponseInner dto = 
                            new OscarDirectorsGetLoosersPost200ResponseInner();
                    dto.setName((String) director.get("name"));
                    dto.setPassportID((String) director.get("passportID"));
                    dto.setFilmsCount(((Long) director.get("filmsCount")).intValue());
                    return dto;
                })
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<OscarDirectorsHumiliateByGenreGenrePost200Response> _oscarDirectorsHumiliateByGenreGenrePost(
            MovieGenre genre) {
        Map<String, Object> result = movieService.humiliateDirectorsByGenre(
                dtoMapper.toMovieGenreEntity(genre));
        
        OscarDirectorsHumiliateByGenreGenrePost200Response response = 
                new OscarDirectorsHumiliateByGenreGenrePost200Response();
        response.setAffectedDirectors((Integer) result.get("affectedDirectors"));
        response.setAffectedMovies((Integer) result.get("affectedMovies"));
        response.setRemovedOscars(((Long) result.get("removedOscars")).intValue());
        
        return ResponseEntity.ok(response);
    }
}
