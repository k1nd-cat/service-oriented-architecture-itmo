package ru.itmo.soa.movie.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ru.itmo.soa.movie.entity.enums.Country;
import ru.itmo.soa.movie.entity.enums.EyeColor;
import ru.itmo.soa.movie.entity.enums.HairColor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "persons", indexes = {
    @Index(name = "idx_person_passport", columnList = "passport_id", unique = true)
})
public class PersonEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(name = "passport_id", nullable = false, unique = true, length = 20)
    private String passportID;

    @Enumerated(EnumType.STRING)
    @Column(name = "eye_color")
    private EyeColor eyeColor;

    @Enumerated(EnumType.STRING)
    @Column(name = "hair_color", nullable = false)
    private HairColor hairColor;

    @Enumerated(EnumType.STRING)
    @Column(name = "nationality")
    private Country nationality;

    @Embedded
    private LocationEntity location;
}

