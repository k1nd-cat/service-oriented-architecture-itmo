package ru.itmo.soa.oscar.web;

import io.swagger.v3.oas.annotations.Hidden;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/swagger-ui")
@Hidden
public class SwaggerUIResource {

    @GET
    @Produces(MediaType.TEXT_HTML)
    public Response getSwaggerUI() {
        String html = """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Oscar Service API - Swagger UI</title>
                <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.10.0/swagger-ui.css">
            </head>
            <body>
                <div id="swagger-ui"></div>
                <script src="https://unpkg.com/swagger-ui-dist@5.10.0/swagger-ui-bundle.js"></script>
                <script src="https://unpkg.com/swagger-ui-dist@5.10.0/swagger-ui-standalone-preset.js"></script>
                <script>
                    window.onload = function() {
                        const ui = SwaggerUIBundle({
                            url: window.location.origin + window.location.pathname.replace('/swagger-ui', '/openapi.json'),
                            dom_id: '#swagger-ui',
                            deepLinking: true,
                            presets: [
                                SwaggerUIBundle.presets.apis,
                                SwaggerUIStandalonePreset
                            ],
                            plugins: [
                                SwaggerUIBundle.plugins.DownloadUrl
                            ],
                            layout: "StandaloneLayout"
                        });
                        window.ui = ui;
                    };
                </script>
            </body>
            </html>
            """;
        return Response.ok(html).build();
    }
}

