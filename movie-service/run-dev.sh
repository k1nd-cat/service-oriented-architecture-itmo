#!/bin/bash

# Script to run the application in development mode

echo "Starting PostgreSQL..."
docker-compose up -d postgres

echo "Waiting for PostgreSQL to be ready..."
sleep 5

echo "Building and running the application..."
mvn clean spring-boot:run

echo "Application is running on http://localhost:8080"
echo "Swagger UI available at http://localhost:8080/swagger-ui.html"

