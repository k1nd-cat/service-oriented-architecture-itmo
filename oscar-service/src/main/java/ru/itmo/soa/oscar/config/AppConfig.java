package ru.itmo.soa.oscar.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Application configuration loader
 */
public class AppConfig {
    
    private static final Logger logger = Logger.getLogger(AppConfig.class.getName());
    private static final Properties properties = new Properties();
    private static boolean initialized = false;
    
    static {
        loadProperties();
    }
    
    private static void loadProperties() {
        if (initialized) {
            return;
        }
        
        try (InputStream input = AppConfig.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            
            if (input == null) {
                logger.warning("Unable to find application.properties, using defaults");
                setDefaults();
                return;
            }
            
            properties.load(input);
            resolveProperties();
            initialized = true;
            
            logger.info("Application properties loaded successfully");
            logger.info("Movie Service URL: " + getMovieServiceBaseUrl());
            
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error loading application.properties", e);
            setDefaults();
        }
    }
    
    /**
     * Resolve property placeholders like ${server.host}
     */
    private static void resolveProperties() {
        Properties resolved = new Properties();
        
        for (String key : properties.stringPropertyNames()) {
            String value = properties.getProperty(key);
            resolved.setProperty(key, resolvePlaceholders(value));
        }
        
        properties.clear();
        properties.putAll(resolved);
    }
    
    /**
     * Resolve placeholders in a value string
     */
    private static String resolvePlaceholders(String value) {
        if (value == null) {
            return null;
        }
        
        String result = value;
        int maxIterations = 10; // Prevent infinite loops
        int iteration = 0;
        
        while (result.contains("${") && iteration < maxIterations) {
            int start = result.indexOf("${");
            int end = result.indexOf("}", start);
            
            if (end == -1) {
                break;
            }
            
            String placeholder = result.substring(start + 2, end);
            String replacement = properties.getProperty(placeholder, "");
            result = result.substring(0, start) + replacement + result.substring(end + 1);
            
            iteration++;
        }
        
        return result;
    }
    
    private static void setDefaults() {
        properties.setProperty("server.host", "localhost");
        properties.setProperty("server.port", "9001");
        properties.setProperty("server.context.service1", "service1");
        properties.setProperty("server.context.service2", "service2");
        properties.setProperty("movie.service.base.url", 
            "http://localhost:9001/service1/api/v1");
        initialized = true;
    }
    
    public static String getProperty(String key) {
        return properties.getProperty(key);
    }
    
    public static String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }
    
    public static String getMovieServiceBaseUrl() {
        return getProperty("movie.service.base.url", "http://localhost:9001/service1/api/v1");
    }
    
    public static String getServerHost() {
        return getProperty("server.host", "localhost");
    }
    
    public static String getServerPort() {
        return getProperty("server.port", "9001");
    }
    
    public static String getServerUrl() {
        return "http://" + getServerHost() + ":" + getServerPort() + "/" 
            + getProperty("server.context.service2", "service2");
    }
    
    public static void reload() {
        initialized = false;
        properties.clear();
        loadProperties();
    }
}

