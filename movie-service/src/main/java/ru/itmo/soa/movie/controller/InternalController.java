package ru.itmo.soa.movie.controller;

import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.itmo.soa.movie.annotation.DeprecatedEndpoint;
import ru.itmo.soa.movie.api.internal.InternalApiApi;
import ru.itmo.soa.movie.dto.internal.MovieGenre;
import ru.itmo.soa.movie.dto.internal.GetDirectorsWithoutOscars200ResponseInner;
import ru.itmo.soa.movie.dto.internal.HumiliateDirectorsByGenre200Response;
import ru.itmo.soa.movie.service.MovieService;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class InternalController implements InternalApiApi {

    private final MovieService movieService;
    private final ModelMapper modelMapper;

    @Override
    public ResponseEntity<List<GetDirectorsWithoutOscars200ResponseInner>> getDirectorsWithoutOscars() {
        List<Map<String, Object>> directors = movieService.getDirectorsWithoutOscars();

        List<GetDirectorsWithoutOscars200ResponseInner> response = directors.stream()
                .map(director -> {
                    GetDirectorsWithoutOscars200ResponseInner dto = 
                            new GetDirectorsWithoutOscars200ResponseInner();
                    dto.setName((String) director.get("name"));
                    dto.setPassportID((String) director.get("passportID"));
                    dto.setFilmsCount(((Long) director.get("filmsCount")).intValue());
                    return dto;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<HumiliateDirectorsByGenre200Response> humiliateDirectorsByGenre(
            MovieGenre genre) {
        Map<String, Object> result = movieService.humiliateDirectorsByGenre(
                modelMapper.map(genre, ru.itmo.soa.movie.entity.enums.MovieGenre.class));

        HumiliateDirectorsByGenre200Response response = 
                new HumiliateDirectorsByGenre200Response();
        response.setAffectedDirectors((Integer) result.get("affectedDirectors"));
        response.setAffectedMovies((Integer) result.get("affectedMovies"));
        response.setRemovedOscars(((Long) result.get("removedOscars")).intValue());

        return ResponseEntity.ok(response);
    }
}

