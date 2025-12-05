package ru.itmo.soa.oscar.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Информация о режиссере")
public class DirectorInfo {
    
    @Schema(description = "Имя режиссера", example = "Квентин Тарантино")
    @JsonProperty("name")
    private String name;
    
    @Schema(description = "ID паспорта режиссера", example = "AB1234567")
    @JsonProperty("passportID")
    private String passportID;
    
    @Schema(description = "Количество фильмов режиссера без Оскаров", example = "5")
    @JsonProperty("filmsCount")
    private Integer filmsCount;
}

