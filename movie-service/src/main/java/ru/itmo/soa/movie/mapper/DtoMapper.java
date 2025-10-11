package ru.itmo.soa.movie.mapper;

import org.mapstruct.*;
import ru.itmo.soa.movie.entity.*;

import java.util.List;

/**
 * MapStruct mapper for converting between generated DTOs and Entity classes
 */
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface DtoMapper {

    // ============= Public API Mappings =============
    
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "creationDate", ignore = true)
    MovieEntity toMovieEntity(ru.itmo.soa.movie.dto.publicapi.MovieRequest movieRequest);

    @Mapping(target = "id", expression = "java(entity.getId() != null ? entity.getId().intValue() : null)")
    ru.itmo.soa.movie.dto.publicapi.Movie fromMovieEntity(MovieEntity entity);

    List<ru.itmo.soa.movie.dto.publicapi.Movie> fromMovieEntityList(List<MovieEntity> entities);

    // ============= Internal API Mappings =============
    
    @Mapping(target = "id", expression = "java(entity.getId() != null ? entity.getId().intValue() : null)")
    ru.itmo.soa.movie.dto.internal.Movie fromMovieEntityInternal(MovieEntity entity);

    List<ru.itmo.soa.movie.dto.internal.Movie> fromMovieEntityListInternal(List<MovieEntity> entities);

    // ============= Nested Objects - Public API =============
    
    CoordinatesEntity toCoordinatesEntity(ru.itmo.soa.movie.dto.publicapi.Coordinates dto);
    
    ru.itmo.soa.movie.dto.publicapi.Coordinates fromCoordinatesEntity(CoordinatesEntity entity);

    PersonEntity toPersonEntity(ru.itmo.soa.movie.dto.publicapi.Person dto);
    
    ru.itmo.soa.movie.dto.publicapi.Person fromPersonEntity(PersonEntity entity);

    LocationEntity toLocationEntity(ru.itmo.soa.movie.dto.publicapi.Location dto);
    
    ru.itmo.soa.movie.dto.publicapi.Location fromLocationEntity(LocationEntity entity);

    // ============= Nested Objects - Internal API =============
    
    ru.itmo.soa.movie.dto.internal.Coordinates fromCoordinatesEntityInternal(CoordinatesEntity entity);

    ru.itmo.soa.movie.dto.internal.Person fromPersonEntityInternal(PersonEntity entity);

    ru.itmo.soa.movie.dto.internal.Location fromLocationEntityInternal(LocationEntity entity);

    // ============= Enum Mappings =============
    
    // MovieGenre
    default ru.itmo.soa.movie.entity.enums.MovieGenre toMovieGenreEntity(ru.itmo.soa.movie.dto.publicapi.MovieGenre dto) {
        return dto == null ? null : ru.itmo.soa.movie.entity.enums.MovieGenre.valueOf(dto.name());
    }

    default ru.itmo.soa.movie.entity.enums.MovieGenre toMovieGenreEntity(ru.itmo.soa.movie.dto.internal.MovieGenre dto) {
        return dto == null ? null : ru.itmo.soa.movie.entity.enums.MovieGenre.valueOf(dto.name());
    }

    default ru.itmo.soa.movie.dto.publicapi.MovieGenre fromMovieGenreEntity(ru.itmo.soa.movie.entity.enums.MovieGenre entity) {
        return entity == null ? null : ru.itmo.soa.movie.dto.publicapi.MovieGenre.valueOf(entity.name());
    }

    default ru.itmo.soa.movie.dto.internal.MovieGenre fromMovieGenreEntityInternal(ru.itmo.soa.movie.entity.enums.MovieGenre entity) {
        return entity == null ? null : ru.itmo.soa.movie.dto.internal.MovieGenre.valueOf(entity.name());
    }

    // EyeColor
    default ru.itmo.soa.movie.entity.enums.EyeColor toEyeColorEntity(ru.itmo.soa.movie.dto.publicapi.EyeColor dto) {
        return dto == null ? null : ru.itmo.soa.movie.entity.enums.EyeColor.valueOf(dto.name());
    }

    default ru.itmo.soa.movie.dto.publicapi.EyeColor fromEyeColorEntity(ru.itmo.soa.movie.entity.enums.EyeColor entity) {
        return entity == null ? null : ru.itmo.soa.movie.dto.publicapi.EyeColor.valueOf(entity.name());
    }

    default ru.itmo.soa.movie.dto.internal.EyeColor fromEyeColorEntityInternal(ru.itmo.soa.movie.entity.enums.EyeColor entity) {
        return entity == null ? null : ru.itmo.soa.movie.dto.internal.EyeColor.valueOf(entity.name());
    }

    // HairColor
    default ru.itmo.soa.movie.entity.enums.HairColor toHairColorEntity(ru.itmo.soa.movie.dto.publicapi.HairColor dto) {
        return dto == null ? null : ru.itmo.soa.movie.entity.enums.HairColor.valueOf(dto.name());
    }

    default ru.itmo.soa.movie.dto.publicapi.HairColor fromHairColorEntity(ru.itmo.soa.movie.entity.enums.HairColor entity) {
        return entity == null ? null : ru.itmo.soa.movie.dto.publicapi.HairColor.valueOf(entity.name());
    }

    default ru.itmo.soa.movie.dto.internal.HairColor fromHairColorEntityInternal(ru.itmo.soa.movie.entity.enums.HairColor entity) {
        return entity == null ? null : ru.itmo.soa.movie.dto.internal.HairColor.valueOf(entity.name());
    }

    // Country
    default ru.itmo.soa.movie.entity.enums.Country toCountryEntity(ru.itmo.soa.movie.dto.publicapi.Country dto) {
        return dto == null ? null : ru.itmo.soa.movie.entity.enums.Country.valueOf(dto.name());
    }

    default ru.itmo.soa.movie.dto.publicapi.Country fromCountryEntity(ru.itmo.soa.movie.entity.enums.Country entity) {
        return entity == null ? null : ru.itmo.soa.movie.dto.publicapi.Country.valueOf(entity.name());
    }

    default ru.itmo.soa.movie.dto.internal.Country fromCountryEntityInternal(ru.itmo.soa.movie.entity.enums.Country entity) {
        return entity == null ? null : ru.itmo.soa.movie.dto.internal.Country.valueOf(entity.name());
    }
}
