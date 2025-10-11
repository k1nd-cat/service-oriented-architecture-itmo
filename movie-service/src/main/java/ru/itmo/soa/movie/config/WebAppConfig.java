package ru.itmo.soa.movie.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@ComponentScan(basePackages = {
    "ru.itmo.soa.movie.controller",
    "ru.itmo.soa.movie.exception"
})
@Import({WebMvcConfig.class, OpenApiConfig.class})
public class WebAppConfig {
}

