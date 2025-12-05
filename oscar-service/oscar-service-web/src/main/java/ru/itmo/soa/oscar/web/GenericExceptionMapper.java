package ru.itmo.soa.oscar.web;

import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import ru.itmo.soa.oscar.dto.ErrorResponse;

import java.time.OffsetDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

@Provider
public class GenericExceptionMapper implements ExceptionMapper<Exception> {
    
    private static final Logger log = Logger.getLogger(GenericExceptionMapper.class.getName());
    
    @Override
    public Response toResponse(Exception exception) {
        log.log(Level.SEVERE, "Unhandled exception", exception);
        
        ErrorResponse error = ErrorResponse.builder()
                .error("INTERNAL_SERVER_ERROR")
                .message("An unexpected error occurred: " + exception.getMessage())
                .timestamp(OffsetDateTime.now())
                .build();
        
        return Response
                .status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(error)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}

