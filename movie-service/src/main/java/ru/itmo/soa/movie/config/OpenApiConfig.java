package ru.itmo.soa.movie.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public GroupedOpenApi publicApi() {
        return GroupedOpenApi.builder()
                .group("public")
                .displayName("Public API")
                .pathsToMatch("/api/v1/movies/**", "/api/v1/oscar/**")
                .pathsToExclude("/api/v1/internal/**")
                .build();
    }

    @Bean
    public GroupedOpenApi internalApi() {
        return GroupedOpenApi.builder()
                .group("internal")
                .displayName("Internal API")
                .pathsToMatch("/api/v1/internal/**")
                .build();
    }

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Movie Collection Management API")
                        .version("1.0.0")
                        .description("""
                                API для управления коллекцией фильмов. Включает:
                                1. CRUD операции для управления фильмами
                                2. Поиск и фильтрацию фильмов
                                3. Операции с "Оскарами"
                                """)
                        .contact(new Contact()
                                .name("API Support")
                                .email("ae.troshkin@gmail.com")))
                .servers(List.of(
                        new Server()
                                .url("http://localhost:8080")
                                .description("Development server")
                ));
    }
}

