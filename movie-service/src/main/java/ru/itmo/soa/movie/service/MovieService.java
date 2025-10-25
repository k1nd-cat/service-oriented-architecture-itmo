package ru.itmo.soa.movie.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.entity.PersonEntity;
import ru.itmo.soa.movie.entity.enums.Country;
import ru.itmo.soa.movie.entity.enums.MovieGenre;
import ru.itmo.soa.movie.exception.BadRequestException;
import ru.itmo.soa.movie.exception.ResourceNotFoundException;
import ru.itmo.soa.movie.repository.MovieRepository;
import ru.itmo.soa.movie.repository.PersonRepository;
import ru.itmo.soa.movie.specification.MovieSpecification;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class MovieService {

    private final MovieRepository movieRepository;
    private final PersonRepository personRepository;

    @Transactional(readOnly = true)
    public Page<MovieEntity> getAllMovies(
            Map<String, Object> filters,
            String sortString,
            int page,
            int size
    ) {
        log.info("Getting movies with filters: {}, sort: {}, page: {}, size: {}", filters, sortString, page, size);
        
        Specification<MovieEntity> spec = buildSpecification(filters);
        Pageable pageable = buildPageable(sortString, page, size);
        
        return movieRepository.findAll(spec, pageable);
    }

    @Transactional(readOnly = true)
    public List<MovieEntity> getAllMovies() {
        log.info("Getting all movies without pagination");
        return movieRepository.findAll();
    }

    @Transactional(readOnly = true)
    public MovieEntity getMovieById(Long id) {
        log.info("Getting movie by id: {}", id);
        return movieRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Фильм с ID " + id + " не найден"));
    }

    @Transactional
    public MovieEntity createMovie(MovieEntity movie) {
        log.info("Creating movie: {}", movie.getName());
        validateMovie(movie);
        
                if (movie.getDirector() != null) {
            movie.setDirector(processOrCreatePerson(movie.getDirector()));
        }
        
                if (movie.getOperator() != null) {
            movie.setOperator(processOrCreatePerson(movie.getOperator()));
        }
        
        return movieRepository.save(movie);
    }

    @Transactional
    public MovieEntity updateMovie(Long id, MovieEntity updatedMovie) {
        log.info("Updating movie with id: {}", id);
        
        MovieEntity existingMovie = getMovieById(id);
        validateMovie(updatedMovie);
        
                existingMovie.setName(updatedMovie.getName());
        existingMovie.setCoordinates(updatedMovie.getCoordinates());
        existingMovie.setOscarsCount(updatedMovie.getOscarsCount());
        existingMovie.setTotalBoxOffice(updatedMovie.getTotalBoxOffice());
        existingMovie.setLength(updatedMovie.getLength());
        existingMovie.setGenre(updatedMovie.getGenre());
        
                if (updatedMovie.getDirector() != null) {
            existingMovie.setDirector(processOrCreatePerson(updatedMovie.getDirector()));
        }
        
                if (updatedMovie.getOperator() != null) {
            existingMovie.setOperator(processOrCreatePerson(updatedMovie.getOperator()));
        }
        
        return movieRepository.save(existingMovie);
    }

    @Transactional
    public void deleteMovie(Long id) {
        log.info("Deleting movie with id: {}", id);
        MovieEntity movie = getMovieById(id);
        movieRepository.delete(movie);
    }

    @Transactional(readOnly = true)
    public Long calculateTotalLength() {
        log.info("Calculating total length of all movies");
        return movieRepository.calculateTotalLength();
    }

    @Transactional(readOnly = true)
    public long countByGenre(MovieGenre genre) {
        log.info("Counting movies by genre: {}", genre);
        return movieRepository.countByGenre(genre);
    }

    @Transactional(readOnly = true)
    public List<MovieEntity> searchByNamePrefix(String namePrefix) {
        log.info("Searching movies by name prefix: {}", namePrefix);
        if (namePrefix == null || namePrefix.isEmpty()) {
            throw new BadRequestException("Name prefix canпnot be empty");
        }
        return movieRepository.findByNameStartingWithIgnoreCase(namePrefix);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getDirectorsWithoutOscars() {
        log.info("Getting directors without oscars");
        
                Map<String, PersonEntity> allDirectors = new HashMap<>();
        List<MovieEntity> allMovies = movieRepository.findAll();
        
        for (MovieEntity movie : allMovies) {
            String passportId = movie.getDirector().getPassportID();
            allDirectors.putIfAbsent(passportId, movie.getDirector());
        }
        
                Set<String> directorsWithOscars = allMovies.stream()
                .filter(m -> m.getOscarsCount() != null && m.getOscarsCount() > 0)
                .map(m -> m.getDirector().getPassportID())
                .collect(Collectors.toSet());
        
                List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, PersonEntity> entry : allDirectors.entrySet()) {
            if (!directorsWithOscars.contains(entry.getKey())) {
                PersonEntity director = entry.getValue();
                long filmsCount = allMovies.stream()
                        .filter(m -> m.getDirector().getPassportID().equals(entry.getKey()))
                        .count();
                
                Map<String, Object> directorInfo = new HashMap<>();
                directorInfo.put("name", director.getName());
                directorInfo.put("passportID", director.getPassportID());
                directorInfo.put("filmsCount", filmsCount);
                result.add(directorInfo);
            }
        }
        
        return result;
    }

    @Transactional
    public Map<String, Object> humiliateDirectorsByGenre(MovieGenre genre) {
        log.info("Humiliating directors by genre: {}", genre);
        
                List<String> directorPassportIds = movieRepository.findDirectorPassportIDsByGenre(genre);
        
        if (directorPassportIds.isEmpty()) {
            return Map.of(
                    "affectedDirectors", 0,
                    "affectedMovies", 0,
                    "removedOscars", 0
            );
        }
        
                List<MovieEntity> affectedMovies = movieRepository.findByDirectorPassportIDIn(directorPassportIds);
        
                long removedOscars = affectedMovies.stream()
                .filter(m -> m.getOscarsCount() != null && m.getOscarsCount() > 0)
                .mapToLong(MovieEntity::getOscarsCount)
                .sum();
        
                affectedMovies.forEach(movie -> movie.setOscarsCount(0));
        movieRepository.saveAll(affectedMovies);
        
        return Map.of(
                "affectedDirectors", directorPassportIds.size(),
                "affectedMovies", affectedMovies.size(),
                "removedOscars", removedOscars
        );
    }

    private Specification<MovieEntity> buildSpecification(Map<String, Object> filters) {
        Specification<MovieEntity> spec = Specification.where(null);
        
        if (filters == null || filters.isEmpty()) {
            return spec;
        }
        
                if (filters.containsKey("name")) {
            spec = spec.and(MovieSpecification.filterByName((String) filters.get("name")));
        }
        
                if (filters.containsKey("genre")) {
            spec = spec.and(MovieSpecification.filterByGenre((MovieGenre) filters.get("genre")));
        }
        
                if (filters.containsKey("oscarsCountMin") || filters.containsKey("oscarsCountMax")) {
            spec = spec.and(MovieSpecification.filterByOscarsCount(
                    (Integer) filters.get("oscarsCountMin"),
                    (Integer) filters.get("oscarsCountMax")
            ));
        }
        
                if (filters.containsKey("totalBoxOfficeMin") || filters.containsKey("totalBoxOfficeMax")) {
            spec = spec.and(MovieSpecification.filterByTotalBoxOffice(
                    (Double) filters.get("totalBoxOfficeMin"),
                    (Double) filters.get("totalBoxOfficeMax")
            ));
        }
        
                if (filters.containsKey("lengthMin") || filters.containsKey("lengthMax")) {
            spec = spec.and(MovieSpecification.filterByLength(
                    (Long) filters.get("lengthMin"),
                    (Long) filters.get("lengthMax")
            ));
        }
        
                if (filters.containsKey("coordinatesXMin") || filters.containsKey("coordinatesXMax")) {
            spec = spec.and(MovieSpecification.filterByCoordinatesX(
                    (Integer) filters.get("coordinatesXMin"),
                    (Integer) filters.get("coordinatesXMax")
            ));
        }
        
                if (filters.containsKey("coordinatesYMin") || filters.containsKey("coordinatesYMax")) {
            spec = spec.and(MovieSpecification.filterByCoordinatesY(
                    (Float) filters.get("coordinatesYMin"),
                    (Float) filters.get("coordinatesYMax")
            ));
        }
        
                if (filters.containsKey("operatorName")) {
            spec = spec.and(MovieSpecification.filterByOperatorName((String) filters.get("operatorName")));
        }
        
                if (filters.containsKey("operatorNationality")) {
            spec = spec.and(MovieSpecification.filterByOperatorNationality((Country) filters.get("operatorNationality")));
        }
        
        return spec;
    }

    private Pageable buildPageable(String sortString, int page, int size) {
        if (sortString == null || sortString.isEmpty()) {
            return PageRequest.of(page - 1, size);
        }
        
        List<Sort.Order> orders = new ArrayList<>();
        String[] sortPairs = sortString.split(";");
        
        for (String sortPair : sortPairs) {
            String[] parts = sortPair.split(",");
            if (parts.length == 2) {
                String field = parts[0].trim();
                String direction = parts[1].trim();
                
                Sort.Direction sortDirection = direction.equalsIgnoreCase("desc") 
                        ? Sort.Direction.DESC 
                        : Sort.Direction.ASC;
                
                orders.add(new Sort.Order(sortDirection, field));
            }
        }
        
        return PageRequest.of(page - 1, size, Sort.by(orders));
    }

    private PersonEntity processOrCreatePerson(PersonEntity person) {
        if (person.getPassportID() != null) {
            Optional<PersonEntity> existingPerson = personRepository.findByPassportID(person.getPassportID());
            if (existingPerson.isPresent()) {
                return existingPerson.get();
            }
        }
        return personRepository.save(person);
    }

    private void validateMovie(MovieEntity movie) {
        if (movie.getName() == null || movie.getName().isEmpty()) {
            throw new BadRequestException("Movie name cannot be empty");
        }
        
        if (movie.getLength() == null || movie.getLength() < 1) {
            throw new BadRequestException("Movie length must be greater than 0");
        }
        
        if (movie.getCoordinates() == null) {
            throw new BadRequestException("Movie coordinates cannot be null");
        }
        
        if (movie.getCoordinates().getX() == null || movie.getCoordinates().getX() < -650) {
            throw new BadRequestException("Coordinate X must be greater than or equal to -650");
        }
        
        if (movie.getCoordinates().getY() == null || movie.getCoordinates().getY() < -612) {
            throw new BadRequestException("Coordinate Y must be greater than or equal to -612");
        }
        
        if (movie.getDirector() == null) {
            throw new BadRequestException("Movie director cannot be null");
        }
        
        validatePerson(movie.getDirector(), "Director");
        
        if (movie.getOperator() != null) {
            validatePerson(movie.getOperator(), "Operator");
        }
        
        if (movie.getOscarsCount() != null && movie.getOscarsCount() < 1) {
            throw new BadRequestException("Oscars count must be greater than 0 or null");
        }
        
        if (movie.getTotalBoxOffice() != null && movie.getTotalBoxOffice() < 0) {
            throw new BadRequestException("Total box office must be greater than or equal to 0");
        }
    }

    private void validatePerson(PersonEntity person, String role) {
        if (person.getName() == null || person.getName().isEmpty()) {
            throw new BadRequestException(role + " name cannot be empty");
        }
        
        if (person.getPassportID() == null || person.getPassportID().length() < 8) {
            throw new BadRequestException(role + " passportID must be at least 8 characters");
        }
        
        if (person.getHairColor() == null) {
            throw new BadRequestException(role + " hair color cannot be null");
        }
        
        if (person.getLocation() == null) {
            throw new BadRequestException(role + " location cannot be null");
        }
        
        if (person.getLocation().getX() == null || person.getLocation().getY() == null || person.getLocation().getZ() == null) {
            throw new BadRequestException(role + " location coordinates cannot be null");
        }
    }
}

