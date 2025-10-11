package ru.itmo.soa.movie.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

@Controller
public class SwaggerController {

    @Value("${api.server.host}")
    private String serverHost;

    @Value("${api.server.port}")
    private String serverPort;

    @GetMapping(value = "/v3/api-docs/public", produces = "application/yaml; charset=UTF-8")
    @ResponseBody
    public String getPublicApiDocs() throws IOException {
        return loadApiDocsWithReplacedHost("openapi/public-api.yaml");
    }

    @GetMapping(value = "/v3/api-docs/internal", produces = "application/yaml; charset=UTF-8")
    @ResponseBody
    public String getInternalApiDocs() throws IOException {
        return loadApiDocsWithReplacedHost("openapi/internal-api.yaml");
    }

    private String loadApiDocsWithReplacedHost(String resourcePath) throws IOException {
        ClassPathResource resource = new ClassPathResource(resourcePath);
        try (InputStream inputStream = resource.getInputStream()) {
            String content = new String(StreamUtils.copyToByteArray(inputStream), StandardCharsets.UTF_8);
            return content.replace("localhost:9001", serverHost + ":" + serverPort);
        }
    }

    @GetMapping(value = "/api-docs", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public String getApiDocs() throws IOException {
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

