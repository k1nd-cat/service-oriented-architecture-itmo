package ru.itmo.soa.movie.mapper;

import org.modelmapper.Converter;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@Component
public class EnumMappingCustomizer implements ModelMapperCustomizer {

    @Override
    public void apply(ModelMapper modelMapper) {
        // MovieGenre mappings
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.dto.publicapi.MovieGenre.class, 
            ru.itmo.soa.movie.entity.enums.MovieGenre.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.entity.enums.MovieGenre.class, 
            ru.itmo.soa.movie.dto.publicapi.MovieGenre.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.dto.internal.MovieGenre.class, 
            ru.itmo.soa.movie.entity.enums.MovieGenre.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.entity.enums.MovieGenre.class, 
            ru.itmo.soa.movie.dto.internal.MovieGenre.class);

        // EyeColor mappings
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.dto.publicapi.EyeColor.class, 
            ru.itmo.soa.movie.entity.enums.EyeColor.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.entity.enums.EyeColor.class, 
            ru.itmo.soa.movie.dto.publicapi.EyeColor.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.dto.internal.EyeColor.class, 
            ru.itmo.soa.movie.entity.enums.EyeColor.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.entity.enums.EyeColor.class, 
            ru.itmo.soa.movie.dto.internal.EyeColor.class);

        // HairColor mappings
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.dto.publicapi.HairColor.class, 
            ru.itmo.soa.movie.entity.enums.HairColor.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.entity.enums.HairColor.class, 
            ru.itmo.soa.movie.dto.publicapi.HairColor.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.dto.internal.HairColor.class, 
            ru.itmo.soa.movie.entity.enums.HairColor.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.entity.enums.HairColor.class, 
            ru.itmo.soa.movie.dto.internal.HairColor.class);

        // Country mappings
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.dto.publicapi.Country.class, 
            ru.itmo.soa.movie.entity.enums.Country.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.entity.enums.Country.class, 
            ru.itmo.soa.movie.dto.publicapi.Country.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.dto.internal.Country.class, 
            ru.itmo.soa.movie.entity.enums.Country.class);
        addEnumMapping(modelMapper, 
            ru.itmo.soa.movie.entity.enums.Country.class, 
            ru.itmo.soa.movie.dto.internal.Country.class);
    }

    private <S extends Enum<S>, D extends Enum<D>> void addEnumMapping(
            ModelMapper modelMapper, 
            Class<S> sourceType, 
            Class<D> destType) {
        Converter<S, D> converter = context -> {
            S source = context.getSource();
            return source == null ? null : Enum.valueOf(destType, source.name());
        };
        modelMapper.addConverter(converter, sourceType, destType);
    }
}

