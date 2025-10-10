package ru.itmo.soa.movie.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
public class CoordinatesEntity {

    @Column(name = "coordinate_x", nullable = false)
    private Integer x;

    @Column(name = "coordinate_y", nullable = false)
    private Float y;
}

