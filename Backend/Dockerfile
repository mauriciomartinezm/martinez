FROM ubuntu:latest AS build
RUN apt-get update
RUN apt-get install openjdk-25-jdk -y
COPY . .
RUN ./gradlew bootJar --no-daemon

FROM openjdk:25-jdk-slim
EXPOSE 8080
COPY --from=build /app/build/libs/Backend-0.0.1-SNAPSHOT.jar /usr/app/Backend-0.0.1-SNAPSHOT.jar

ENTRYPOINT [ "java", "-jar", "/usr/app/Backend-0.0.1-SNAPSHOT.jar" ]