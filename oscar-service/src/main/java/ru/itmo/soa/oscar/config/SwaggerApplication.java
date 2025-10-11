package ru.itmo.soa.oscar.config;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import java.util.HashSet;
import java.util.Set;

@ApplicationPath("")
public class SwaggerApplication extends Application {
    
    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> resources = new HashSet<>();
        
        // Только Swagger UI ресурс
        resources.add(SwaggerUIResource.class);
        
        return resources;
    }
}

