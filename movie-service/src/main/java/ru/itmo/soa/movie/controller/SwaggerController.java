package ru.itmo.soa.movie.controller;

import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.io.InputStream;

@Controller
public class SwaggerController {

    @GetMapping(value = "/v3/api-docs/public", produces = "application/yaml")
    @ResponseBody
    public byte[] getPublicApiDocs() throws IOException {
        ClassPathResource resource = new ClassPathResource("openapi/public-api.yaml");
        try (InputStream inputStream = resource.getInputStream()) {
            return StreamUtils.copyToByteArray(inputStream);
        }
    }

    @GetMapping(value = "/v3/api-docs/internal", produces = "application/yaml")
    @ResponseBody
    public byte[] getInternalApiDocs() throws IOException {
        ClassPathResource resource = new ClassPathResource("openapi/internal-api.yaml");
        try (InputStream inputStream = resource.getInputStream()) {
            return StreamUtils.copyToByteArray(inputStream);
        }
    }

    @GetMapping(value = "/api-docs", produces = "text/plain")
    @ResponseBody
    public byte[] getApiDocs() throws IOException {
        return getPublicApiDocs();
    }

    @GetMapping(value = "/swagger-ui.html", produces = MediaType.TEXT_HTML_VALUE)
    @ResponseBody
    public byte[] getSwaggerUi() throws IOException {
        ClassPathResource resource = new ClassPathResource("META-INF/resources/swagger-ui.html");
        try (InputStream inputStream = resource.getInputStream()) {
            return StreamUtils.copyToByteArray(inputStream);
        }
    }
}

