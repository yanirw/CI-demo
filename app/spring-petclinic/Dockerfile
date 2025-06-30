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

USER nonroot:nonroot

WORKDIR /app

COPY --from=builder --chown=nonroot:nonroot /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"] 