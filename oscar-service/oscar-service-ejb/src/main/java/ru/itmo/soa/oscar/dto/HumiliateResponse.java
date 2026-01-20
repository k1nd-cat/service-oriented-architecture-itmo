package ru.itmo.soa.oscar.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlElement;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Результат операции отобрания Оскаров")
@XmlRootElement(name = "HumiliateResponse", namespace = "http://soa.itmo.ru/oscar")
@XmlType(name = "HumiliateResponse", namespace = "http://soa.itmo.ru/oscar")
@XmlAccessorType(XmlAccessType.FIELD)
public class HumiliateResponse {
    
    @Schema(description = "Количество затронутых режиссеров", example = "3")
    @JsonProperty("affectedDirectors")
    @XmlElement(name = "affectedDirectors", namespace = "http://soa.itmo.ru/oscar")
    private Integer affectedDirectors;
    
    @Schema(description = "Количество затронутых фильмов", example = "10")
    @JsonProperty("affectedMovies")
    @XmlElement(name = "affectedMovies", namespace = "http://soa.itmo.ru/oscar")
    private Integer affectedMovies;
    
    @Schema(description = "Общее количество отобранных Оскаров", example = "15")
    @JsonProperty("removedOscars")
    @XmlElement(name = "removedOscars", namespace = "http://soa.itmo.ru/oscar")
    private Integer removedOscars;
}

