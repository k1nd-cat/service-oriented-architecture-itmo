package ru.itmo.soa.movie.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import ru.itmo.soa.movie.entity.enums.MovieGenre;

import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "movies", indexes = {
    @Index(name = "idx_movie_name", columnList = "name"),
    @Index(name = "idx_movie_genre", columnList = "genre"),
    @Index(name = "idx_movie_creation_date", columnList = "creation_date")
})
public class MovieEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    @Embedded
    private CoordinatesEntity coordinates;

    @CreationTimestamp
    @Column(name = "creation_date", nullable = false, updatable = false)
    private OffsetDateTime creationDate;

    @Column(name = "oscars_count")
    private Integer oscarsCount;

    @Column(name = "total_box_office")
    private Double totalBoxOffice;

    @Column(nullable = false)
    private Long length;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.EAGER)
    @JoinColumn(name = "director_id", nullable = false)
    private PersonEntity director;

    @Enumerated(EnumType.STRING)
    @Column(name = "genre")
    private MovieGenre genre;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.EAGER)
    @JoinColumn(name = "operator_id")
    private PersonEntity operator;
}

