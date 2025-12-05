package ru.itmo.soa.oscar.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

public class AppConfig {
    
    private static final Logger log = Logger.getLogger(AppConfig.class.getName());
    private static final Properties properties = new Properties();
    
    static {
        try (InputStream input = AppConfig.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (input == null) {
                log.warning("Unable to find application.properties, using defaults");
            } else {
                properties.load(input);
                log.info("Application properties loaded successfully");
                log.info("Movie Service URL: " + getMovieServiceBaseUrl());
            }
        } catch (IOException ex) {
            log.severe("Error loading application.properties: " + ex.getMessage());
        }
    }
    
    public static String getMovieServiceBaseUrl() {
        return properties.getProperty("movie.service.base.url", "http://localhost:9000/service1/api/v1/internal");
    }
}

