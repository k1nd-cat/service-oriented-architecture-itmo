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
@Schema(description = "Информация о режиссере")
@XmlRootElement(name = "DirectorInfo", namespace = "http://soa.itmo.ru/oscar")
@XmlType(name = "DirectorInfo", namespace = "http://soa.itmo.ru/oscar")
@XmlAccessorType(XmlAccessType.FIELD)
public class DirectorInfo {
    
    @Schema(description = "Имя режиссера", example = "Квентин Тарантино")
    @JsonProperty("name")
    @XmlElement(name = "name", namespace = "http://soa.itmo.ru/oscar")
    private String name;
    
    @Schema(description = "ID паспорта режиссера", example = "AB1234567")
    @JsonProperty("passportID")
    @XmlElement(name = "passportID", namespace = "http://soa.itmo.ru/oscar")
    private String passportID;
    
    @Schema(description = "Количество фильмов режиссера без Оскаров", example = "5")
    @JsonProperty("filmsCount")
    @XmlElement(name = "filmsCount", namespace = "http://soa.itmo.ru/oscar")
    private Integer filmsCount;
}

