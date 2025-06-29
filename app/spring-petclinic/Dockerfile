# Multi-stage Dockerfile for Spring PetClinic with security best practices
# Stage 1: Build stage
FROM openjdk:17-jdk-slim AS builder

# Set working directory
WORKDIR /app

# Copy Maven wrapper and pom.xml first for better layer caching
COPY mvnw ./
COPY mvnw.cmd ./
COPY .mvn ./.mvn/
COPY pom.xml ./

# Make Maven wrapper executable
RUN chmod +x ./mvnw

# Download dependencies (better layer caching)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src/

# Build the application (skip tests for build stage)
RUN ./mvnw clean package -DskipTests -B

# Stage 2: Runtime stage using distroless image for security
FROM gcr.io/distroless/java17-debian12:nonroot

# Add metadata labels
LABEL org.opencontainers.image.title="Spring PetClinic"
LABEL org.opencontainers.image.description="Sample Spring Boot application"
LABEL org.opencontainers.image.version="3.5.0-SNAPSHOT"
LABEL org.opencontainers.image.source="https://github.com/spring-projects/spring-petclinic"

# Create non-root user for security (distroless already has nonroot user)
USER nonroot:nonroot

# Set working directory
WORKDIR /app

# Copy the built jar from builder stage
COPY --from=builder --chown=nonroot:nonroot /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"] 