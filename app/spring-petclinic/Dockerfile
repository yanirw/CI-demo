FROM openjdk:17-jdk-slim AS builder

WORKDIR /app

COPY mvnw ./
COPY mvnw.cmd ./
COPY .mvn ./.mvn/
COPY pom.xml ./

RUN chmod +x ./mvnw

RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw dependency:go-offline -B

COPY src ./src/

RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw clean package -DskipTests -B

FROM gcr.io/distroless/java17-debian12:nonroot

LABEL org.opencontainers.image.title="Spring PetClinic"
LABEL org.opencontainers.image.description="Sample Spring Boot application"
LABEL org.opencontainers.image.version="3.5.0-SNAPSHOT"
LABEL org.opencontainers.image.source="https://github.com/spring-projects/spring-petclinic"

USER nonroot:nonroot

WORKDIR /app

COPY --from=builder --chown=nonroot:nonroot /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"] 