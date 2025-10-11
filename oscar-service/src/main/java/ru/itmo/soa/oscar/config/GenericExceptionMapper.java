package ru.itmo.soa.oscar.config;

import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import ru.itmo.soa.oscar.dto.ErrorResponse;

import java.time.OffsetDateTime;

@Provider
public class GenericExceptionMapper implements ExceptionMapper<Exception> {

    @Override
    public Response toResponse(Exception exception) {
        ErrorResponse errorResponse = ErrorResponse.builder()
                .error("INTERNAL_SERVER_ERROR")
                .message(exception.getMessage() != null ? exception.getMessage() : "Внутренняя ошибка сервера")
                .timestamp(OffsetDateTime.now())
                .path("")
                .build();

        return Response
                .status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(errorResponse)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}

