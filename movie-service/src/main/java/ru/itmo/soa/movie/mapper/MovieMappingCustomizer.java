package ru.itmo.soa.movie.mapper;

import org.modelmapper.Converter;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.stereotype.Component;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.entity.PersonEntity;

@Component
public class MovieMappingCustomizer implements ModelMapperCustomizer {

    @Override
    public void apply(ModelMapper modelMapper) {
        // Используем STRICT matching strategy, чтобы избежать неправильного маппинга полей
        modelMapper.getConfiguration()
            .setMatchingStrategy(MatchingStrategies.STRICT)
            .setAmbiguityIgnored(true);
        
        // Маппинг из MovieEntity в Movie (Public API) с конвертацией Long id -> Integer id
        modelMapper.createTypeMap(MovieEntity.class, ru.itmo.soa.movie.dto.publicapi.Movie.class)
                .addMappings(mapper -> {
                    mapper.using((Converter<Long, Integer>) context -> 
                        context.getSource() != null ? context.getSource().intValue() : null
                    ).map(MovieEntity::getId, ru.itmo.soa.movie.dto.publicapi.Movie::setId);
                });

        // Маппинг из MovieEntity в Movie (Internal API) с конвертацией Long id -> Integer id
        modelMapper.createTypeMap(MovieEntity.class, ru.itmo.soa.movie.dto.internal.Movie.class)
                .addMappings(mapper -> {
                    mapper.using((Converter<Long, Integer>) context -> 
                        context.getSource() != null ? context.getSource().intValue() : null
                    ).map(MovieEntity::getId, ru.itmo.soa.movie.dto.internal.Movie::setId);
                });

        // Маппинг из MovieRequest в MovieEntity - игнорируем id и creationDate
        modelMapper.createTypeMap(ru.itmo.soa.movie.dto.publicapi.MovieRequest.class, MovieEntity.class)
                .addMappings(mapper -> {
                    mapper.skip(MovieEntity::setId);
                    mapper.skip(MovieEntity::setCreationDate);
                });

        // Маппинг из Person (Public API DTO) в PersonEntity - игнорируем id
        modelMapper.createTypeMap(ru.itmo.soa.movie.dto.publicapi.Person.class, PersonEntity.class)
                .addMappings(mapper -> {
                    mapper.skip(PersonEntity::setId);
                });

        // Маппинг из Person (Internal API DTO) в PersonEntity - игнорируем id
        modelMapper.createTypeMap(ru.itmo.soa.movie.dto.internal.Person.class, PersonEntity.class)
                .addMappings(mapper -> {
                    mapper.skip(PersonEntity::setId);
                });
    }
}

