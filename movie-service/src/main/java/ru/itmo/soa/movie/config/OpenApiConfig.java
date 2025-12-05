package ru.itmo.soa.movie.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Movie Collection Management API")
                        .version("1.0.0")
                        .description("""
                                API для управления коллекцией фильмов.
                                
                                Endpoints сгруппированы по тегам:
                                - Movies - публичные операции для управления фильмами (используются фронтендом)
                                - Internal API - внутренние операции для межсервисного взаимодействия
                                """)
                        .contact(new Contact()
                                .name("API Support")
                                .email("ae.troshkin@gmail.com")));
    }
}
