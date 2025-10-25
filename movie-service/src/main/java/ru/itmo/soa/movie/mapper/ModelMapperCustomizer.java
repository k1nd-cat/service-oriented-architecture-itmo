package ru.itmo.soa.movie.mapper;

import org.modelmapper.ModelMapper;

public interface ModelMapperCustomizer {

    void apply(ModelMapper modelMapper);

}
