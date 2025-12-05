package ru.itmo.soa.oscar.dto;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum MovieGenre {
    COMEDY,
    ADVENTURE,
    TRAGEDY,
    SCIENCE_FICTION;

    @JsonValue
    public String toValue() {
        return name();
    }

    @JsonCreator
    public static MovieGenre fromValue(String value) {
        for (MovieGenre genre : MovieGenre.values()) {
            if (genre.name().equalsIgnoreCase(value)) {
                return genre;
            }
        }
        throw new IllegalArgumentException("Unknown MovieGenre: " + value);
    }
}

