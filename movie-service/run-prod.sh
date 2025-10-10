#!/bin/bash

# Script to run the application in production mode

echo "Building the application..."
mvn clean package -DskipTests

echo "Starting services with Docker Compose..."
docker-compose up -d

echo "Application is starting..."
echo "It will be available at http://localhost:8080"
echo "Check logs with: docker-compose logs -f movie-service"

