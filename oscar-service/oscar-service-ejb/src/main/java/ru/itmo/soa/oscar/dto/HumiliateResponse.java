package ru.itmo.soa.oscar.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Результат операции отобрания Оскаров")
public class HumiliateResponse {
    
    @Schema(description = "Количество затронутых режиссеров", example = "3")
    @JsonProperty("affectedDirectors")
    private Integer affectedDirectors;
    
    @Schema(description = "Количество затронутых фильмов", example = "10")
    @JsonProperty("affectedMovies")
    private Integer affectedMovies;
    
    @Schema(description = "Общее количество отобранных Оскаров", example = "15")
    @JsonProperty("removedOscars")
    private Integer removedOscars;
}

