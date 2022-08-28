# https://stackoverflow.com/questions/65456814/docker-apple-silicon-m1-preview-mysql-no-matching-manifest-for-linux-arm64-v8
# https://stackoverflow.com/questions/64221861/an-error-failed-to-solve-with-frontend-dockerfile-v0
# https://docs.docker.com/language/java/run-tests/
FROM --platform=linux/x86_64 gradle:7.5.1-jdk17-alpine AS base
COPY --chown=gradle:gradle . /app
WORKDIR /app

FROM base as test
CMD ["./gradlew", "test"]

FROM base as build
RUN ./gradlew build -x test

# create-image -> DOCKER_BUILDKIT=0 docker build --tag sb-web-image --target web .
# run -> docker run -it --rm --name sb-web-container -p 8085:8080 sb-web-image
FROM --platform=linux/x86_64 openjdk:17-alpine as web
COPY --from=build /app/web/build/libs/*.jar /web.jar
CMD ["java", "-Dspring-boot.run.profiles=default", "-jar", "/web.jar"]

# create-image -> DOCKER_BUILDKIT=0 docker build --tag sb-worker-image --target worker .
# run -> docker run -it --rm --name sb-worker-container -p 8086:8080 sb-worker-image
FROM --platform=linux/x86_64 openjdk:17-alpine as worker
COPY --from=build /app/worker/build/libs/*.jar /worker.jar
CMD ["java", "-Dspring-boot.run.profiles=default", "-jar", "/worker.jar"]

# create-image -> DOCKER_BUILDKIT=0 docker build --tag sb-web-image --build-arg JAR_FILE=web/build/libs/\*.jar --target generic .
# run -> docker run -it --rm --name sb-web-container -p 8086:8080 sb-web-image
FROM --platform=linux/x86_64 openjdk:17-alpine as generic
ARG JAR_FILE
COPY --from=build /app/${JAR_FILE} /app.jar
CMD ["java", "-Dspring-boot.run.profiles=default", "-jar", "/app.jar"]
