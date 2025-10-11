package ru.itmo.soa.oscar.resource;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lombok.extern.java.Log;
import ru.itmo.soa.oscar.client.MovieServiceClient;
import ru.itmo.soa.oscar.dto.DirectorInfo;
import ru.itmo.soa.oscar.dto.ErrorResponse;
import ru.itmo.soa.oscar.dto.HumiliateResponse;
import ru.itmo.soa.oscar.dto.MovieGenre;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.logging.Level;

@Path("/oscar/directors")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "Oscar Operations", description = "Операции с \"Оскарами\"")
@Log
public class OscarResource {
    
    private final MovieServiceClient movieServiceClient;
    
    public OscarResource() {
        this.movieServiceClient = new MovieServiceClient();
    }
    
    @POST
    @Path("/get-loosers")
    @Operation(
        summary = "Получить список режиссеров-неудачников",
        description = "Получает список режиссеров, ни один фильм которых не получил ни одного \"Оскара\". Проксирует запрос к internal API movie-service."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Список режиссеров успешно получен",
            content = @Content(
                mediaType = MediaType.APPLICATION_JSON,
                schema = @Schema(implementation = DirectorInfo.class)
            )
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Внутренняя ошибка сервера",
            content = @Content(
                mediaType = MediaType.APPLICATION_JSON,
                schema = @Schema(implementation = ErrorResponse.class)
            )
        )
    })
    public Response getLoosers() {
        try {
            log.info("GET /oscar/directors/get-loosers - getting directors without oscars");
            List<DirectorInfo> directors = movieServiceClient.getLoosers();
            log.info("Successfully retrieved " + directors.size() + " directors");
            return Response.ok(directors).build();
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error getting loosers", e);
            ErrorResponse error = ErrorResponse.builder()
                    .error("INTERNAL_SERVER_ERROR")
                    .message("Failed to get directors: " + e.getMessage())
                    .timestamp(OffsetDateTime.now())
                    .path("/oscar/directors/get-loosers")
                    .build();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(error)
                    .build();
        }
    }
    
    @POST
    @Path("/humiliate-by-genre/{genre}")
    @Operation(
        summary = "Отобрать Оскары у режиссеров по жанру",
        description = "Отбирает все \"Оскары\" у всех фильмов режиссеров, снявших хоть один фильм в указанном жанре. Устанавливает oscarsCount = 0 для всех фильмов таких режиссеров. Проксирует запрос к internal API movie-service."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Операция успешно выполнена",
            content = @Content(
                mediaType = MediaType.APPLICATION_JSON,
                schema = @Schema(implementation = HumiliateResponse.class)
            )
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Некорректный запрос",
            content = @Content(
                mediaType = MediaType.APPLICATION_JSON,
                schema = @Schema(implementation = ErrorResponse.class)
            )
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Внутренняя ошибка сервера",
            content = @Content(
                mediaType = MediaType.APPLICATION_JSON,
                schema = @Schema(implementation = ErrorResponse.class)
            )
        )
    })
    public Response humiliateByGenre(
            @Parameter(
                description = "Жанр фильма для определения режиссеров",
                required = true,
                schema = @Schema(implementation = MovieGenre.class)
            )
            @PathParam("genre") String genreStr) {
        try {
            log.info("POST /oscar/directors/humiliate-by-genre/" + genreStr);
            
            // Парсим жанр
            MovieGenre genre;
            try {
                genre = MovieGenre.fromValue(genreStr);
            } catch (IllegalArgumentException e) {
                log.warning("Invalid genre: " + genreStr);
                ErrorResponse error = ErrorResponse.builder()
                        .error("BAD_REQUEST")
                        .message("Invalid genre: " + genreStr + ". Valid values: COMEDY, ADVENTURE, TRAGEDY, SCIENCE_FICTION")
                        .timestamp(OffsetDateTime.now())
                        .path("/oscar/directors/humiliate-by-genre/" + genreStr)
                        .build();
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(error)
                        .build();
            }
            
            HumiliateResponse response = movieServiceClient.humiliateByGenre(genre);
            log.info("Successfully humiliated directors by genre " + genreStr);
            return Response.ok(response).build();
        } catch (IllegalArgumentException e) {
            log.log(Level.WARNING, "Bad request for humiliate-by-genre", e);
            ErrorResponse error = ErrorResponse.builder()
                    .error("BAD_REQUEST")
                    .message(e.getMessage())
                    .timestamp(OffsetDateTime.now())
                    .path("/oscar/directors/humiliate-by-genre/" + genreStr)
                    .build();
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(error)
                    .build();
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error humiliating by genre", e);
            ErrorResponse error = ErrorResponse.builder()
                    .error("INTERNAL_SERVER_ERROR")
                    .message("Failed to humiliate directors: " + e.getMessage())
                    .timestamp(OffsetDateTime.now())
                    .path("/oscar/directors/humiliate-by-genre/" + genreStr)
                    .build();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(error)
                    .build();
        }
    }
}

