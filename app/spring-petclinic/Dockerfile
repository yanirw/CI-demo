FROM winnik.jfrog.io/demo-docker/amazoncorretto:17-alpine

USER nobody:nobody

WORKDIR /app

COPY --chown=nobody:nobody target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"] 