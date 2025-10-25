package ru.itmo.soa.movie.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.itmo.soa.movie.entity.PersonEntity;

import java.util.Optional;

@Repository
public interface PersonRepository extends JpaRepository<PersonEntity, Long> {

        Optional<PersonEntity> findByPassportID(String passportID);

        boolean existsByPassportID(String passportID);
}

