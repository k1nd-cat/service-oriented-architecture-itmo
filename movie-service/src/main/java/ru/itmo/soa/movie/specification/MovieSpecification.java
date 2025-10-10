package ru.itmo.soa.movie.specification;

import jakarta.persistence.criteria.*;
import org.springframework.data.jpa.domain.Specification;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.entity.PersonEntity;
import ru.itmo.soa.movie.entity.enums.Country;
import ru.itmo.soa.movie.entity.enums.MovieGenre;

import java.util.ArrayList;
import java.util.List;

public class MovieSpecification {

    public static Specification<MovieEntity> filterByName(String name) {
        return (root, query, cb) -> {
            if (name == null || name.isEmpty()) {
                return cb.conjunction();
            }
            return cb.like(cb.lower(root.get("name")), "%" + name.toLowerCase() + "%");
        };
    }

    public static Specification<MovieEntity> filterByGenre(MovieGenre genre) {
        return (root, query, cb) -> {
            if (genre == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("genre"), genre);
        };
    }

    public static Specification<MovieEntity> filterByOscarsCount(Integer min, Integer max) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (min != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("oscarsCount"), min));
            }
            if (max != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("oscarsCount"), max));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    public static Specification<MovieEntity> filterByTotalBoxOffice(Double min, Double max) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (min != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("totalBoxOffice"), min));
            }
            if (max != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("totalBoxOffice"), max));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    public static Specification<MovieEntity> filterByLength(Long min, Long max) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (min != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("length"), min));
            }
            if (max != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("length"), max));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    public static Specification<MovieEntity> filterByCoordinatesX(Integer min, Integer max) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (min != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("coordinates").get("x"), min));
            }
            if (max != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("coordinates").get("x"), max));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    public static Specification<MovieEntity> filterByCoordinatesY(Float min, Float max) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (min != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("coordinates").get("y"), min));
            }
            if (max != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("coordinates").get("y"), max));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    public static Specification<MovieEntity> filterByOperatorName(String operatorName) {
        return (root, query, cb) -> {
            if (operatorName == null || operatorName.isEmpty()) {
                return cb.conjunction();
            }
            Join<MovieEntity, PersonEntity> operatorJoin = root.join("operator", JoinType.LEFT);
            return cb.like(cb.lower(operatorJoin.get("name")), "%" + operatorName.toLowerCase() + "%");
        };
    }

    public static Specification<MovieEntity> filterByOperatorNationality(Country nationality) {
        return (root, query, cb) -> {
            if (nationality == null) {
                return cb.conjunction();
            }
            Join<MovieEntity, PersonEntity> operatorJoin = root.join("operator", JoinType.LEFT);
            return cb.equal(operatorJoin.get("nationality"), nationality);
        };
    }
}

