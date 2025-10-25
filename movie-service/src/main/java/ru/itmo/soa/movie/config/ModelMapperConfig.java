package ru.itmo.soa.movie.config;

import java.util.List;

import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import ru.itmo.soa.movie.mapper.ModelMapperCustomizer;

@Configuration
public class ModelMapperConfig {
    @Bean
    public ModelMapper modelMapper(
            List<ModelMapperCustomizer> customizers
    ) {
        final ModelMapper modelMapper = new ModelMapper() {
            @Override
            public <D> D map(Object source, Class<D> destinationType) {
                return source == null ? null : super.map(source, destinationType);
            }
        };

        for (var customizer : customizers) {
            customizer.apply(modelMapper);
        }

        return modelMapper;
    }
}
