package ru.itmo.soa.oscar.client;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.extern.java.Log;
import ru.itmo.soa.oscar.config.AppConfig;
import ru.itmo.soa.oscar.dto.DirectorInfo;
import ru.itmo.soa.oscar.dto.HumiliateResponse;
import ru.itmo.soa.oscar.dto.MovieGenre;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;

@Log
public class MovieServiceClient {
    
    private final String movieServiceBaseUrl;
    private final ObjectMapper objectMapper;
    
    public MovieServiceClient() {
        this.movieServiceBaseUrl = AppConfig.getMovieServiceBaseUrl();
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        log.info("MovieServiceClient initialized with base URL: " + movieServiceBaseUrl);
    }
    
    /**
     * Получить список режиссеров без Оскаров
     */
    public List<DirectorInfo> getLoosers() throws Exception {
        String url = movieServiceBaseUrl + "/oscar/directors/get-loosers";
        log.info("Calling movie-service: POST " + url);
        
        HttpURLConnection connection = null;
        try {
            URL urlObj = new URL(url);
            connection = (HttpURLConnection) urlObj.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");
            connection.setDoOutput(true);
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            
            // POST запрос с пустым телом
            try (OutputStream os = connection.getOutputStream()) {
                os.write("".getBytes(StandardCharsets.UTF_8));
                os.flush();
            }
            
            int responseCode = connection.getResponseCode();
            log.info("Response code from movie-service: " + responseCode);
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line.trim());
                    }
                    
                    String responseBody = response.toString();
                    log.info("Response from movie-service: " + responseBody);
                    
                    DirectorInfo[] directors = objectMapper.readValue(responseBody, DirectorInfo[].class);
                    return Arrays.asList(directors);
                }
            } else {
                String errorMessage = readErrorStream(connection);
                log.severe("Error from movie-service: " + errorMessage);
                throw new RuntimeException("Failed to get loosers from movie-service: " + responseCode + " - " + errorMessage);
            }
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error calling movie-service", e);
            throw new RuntimeException("Failed to call movie-service: " + e.getMessage(), e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
    
    /**
     * Отобрать Оскары у режиссеров по жанру
     */
    public HumiliateResponse humiliateByGenre(MovieGenre genre) throws Exception {
        String url = movieServiceBaseUrl + "/oscar/directors/humiliate-by-genre/" + genre.name();
        log.info("Calling movie-service: POST " + url);
        
        HttpURLConnection connection = null;
        try {
            URL urlObj = new URL(url);
            connection = (HttpURLConnection) urlObj.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");
            connection.setDoOutput(true);
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            
            // POST запрос с пустым телом
            try (OutputStream os = connection.getOutputStream()) {
                os.write("".getBytes(StandardCharsets.UTF_8));
                os.flush();
            }
            
            int responseCode = connection.getResponseCode();
            log.info("Response code from movie-service: " + responseCode);
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line.trim());
                    }
                    
                    String responseBody = response.toString();
                    log.info("Response from movie-service: " + responseBody);
                    
                    return objectMapper.readValue(responseBody, HumiliateResponse.class);
                }
            } else {
                String errorMessage = readErrorStream(connection);
                log.severe("Error from movie-service: " + errorMessage);
                
                if (responseCode == HttpURLConnection.HTTP_BAD_REQUEST) {
                    throw new IllegalArgumentException("Bad request: " + errorMessage);
                }
                
                throw new RuntimeException("Failed to humiliate by genre from movie-service: " + responseCode + " - " + errorMessage);
            }
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error calling movie-service", e);
            throw new RuntimeException("Failed to call movie-service: " + e.getMessage(), e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
    
    private String readErrorStream(HttpURLConnection connection) {
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }
            return response.toString();
        } catch (Exception e) {
            return "Unable to read error stream";
        }
    }
}

