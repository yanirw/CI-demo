FROM winnik.jfrog.io/demo-docker/amazoncorretto:17-alpine AS builder

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

FROM winnik.jfrog.io/demo-docker/amazoncorretto:17-alpine

USER nobody:nobody

WORKDIR /app

COPY --from=builder --chown=nobody:nobody /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"] 