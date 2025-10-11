package ru.itmo.soa.oscar.config;

import io.swagger.v3.jaxrs2.integration.resources.OpenApiResource;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.integration.SwaggerConfiguration;
import io.swagger.v3.oas.models.OpenAPI;
import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@ApplicationPath("/api/v1")
@OpenAPIDefinition(
    info = @Info(
        title = "Oscar Service API",
        version = "1.0.0",
        description = "Сервис для работы с Оскарами - проксирует запросы к internal API movie-service.",
        contact = @Contact(
            name = "API Support",
            email = "ae.troshkin@gmail.com"
        )
    )
)
public class OscarApplication extends Application {
    
    public OscarApplication() {
        String serverUrl = AppConfig.getServerUrl();

        OpenAPI openAPI = new OpenAPI();
        openAPI.addServersItem(new io.swagger.v3.oas.models.servers.Server()
            .url(serverUrl)
            .description("Production server"));
        
        SwaggerConfiguration swaggerConfig = new SwaggerConfiguration()
            .openAPI(openAPI)
            .prettyPrint(true)
            .resourcePackages(Stream.of("ru.itmo.soa.oscar.resource").collect(Collectors.toSet()));
        
        try {
            new io.swagger.v3.jaxrs2.integration.JaxrsOpenApiContextBuilder()
                .openApiConfiguration(swaggerConfig)
                .buildContext(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> resources = new HashSet<>();

        resources.add(ru.itmo.soa.oscar.resource.OscarResource.class);
        
        resources.add(OpenApiResource.class);
        
        resources.add(ru.itmo.soa.oscar.config.SwaggerUIResource.class);
        
        resources.add(com.fasterxml.jackson.jakarta.rs.json.JacksonJsonProvider.class);
        
        resources.add(ru.itmo.soa.oscar.config.GenericExceptionMapper.class);
        
        return resources;
    }
}

