# ===== BUILD =====
FROM amazoncorretto:25 AS build
WORKDIR /app

# Instalar herramientas necesarias
RUN yum install -y tar gzip

COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline

COPY src src
RUN ./mvnw clean package -DskipTests

# ===== RUN =====
FROM amazoncorretto:21-alpine
WORKDIR /usr/app
EXPOSE 8080

COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
