package ru.itmo.soa.oscar.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "Информация об ошибке")
public class ErrorResponse {
    
    @Schema(description = "Краткое описание ошибки", example = "BAD_REQUEST")
    @JsonProperty("error")
    private String error;
    
    @Schema(description = "Подробное сообщение об ошибке", example = "Некорректный запрос")
    @JsonProperty("message")
    private String message;
    
    @Schema(description = "Время возникновения ошибки", example = "2024-01-15T10:30:00Z")
    @JsonProperty("timestamp")
    private OffsetDateTime timestamp;
    
    @Schema(description = "Путь запроса, где произошла ошибка", example = "/oscar/directors/get-loosers")
    @JsonProperty("path")
    private String path;
}

