package ru.itmo.soa.movie.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.itmo.soa.movie.entity.MovieEntity;
import ru.itmo.soa.movie.entity.enums.MovieGenre;

import java.util.List;

@Repository
public interface MovieRepository extends JpaRepository<MovieEntity, Long>, JpaSpecificationExecutor<MovieEntity> {

        List<MovieEntity> findByNameStartingWithIgnoreCase(String namePrefix);

        long countByGenre(MovieGenre genre);

        @Query("SELECT COALESCE(SUM(m.length), 0) FROM MovieEntity m")
    Long calculateTotalLength();

        @Query("SELECT m FROM MovieEntity m WHERE m.director.passportID = :passportID")
    List<MovieEntity> findByDirectorPassportID(@Param("passportID") String passportID);

        @Query("SELECT DISTINCT m.director.passportID FROM MovieEntity m WHERE m.genre = :genre")
    List<String> findDirectorPassportIDsByGenre(@Param("genre") MovieGenre genre);

        @Query("SELECT m FROM MovieEntity m WHERE m.director.passportID IN :passportIDs")
    List<MovieEntity> findByDirectorPassportIDIn(@Param("passportIDs") List<String> passportIDs);

        @Query("SELECT DISTINCT m.director FROM MovieEntity m " +
           "WHERE m.director.passportID NOT IN " +
           "(SELECT m2.director.passportID FROM MovieEntity m2 WHERE m2.oscarsCount > 0 OR m2.oscarsCount IS NULL)")
    List<Object[]> findDirectorsWithZeroOscars();
}

