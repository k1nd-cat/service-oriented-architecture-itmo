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
public class LocationEntity {

    @Column(name = "location_x", nullable = false)
    private Double x;

    @Column(name = "location_y", nullable = false)
    private Long y;

    @Column(name = "location_z", nullable = false)
    private Integer z;
}

