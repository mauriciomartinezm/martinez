# ===== BUILD STAGE =====
FROM maven:3.9.9-eclipse-temurin-25 AS build
WORKDIR /app

COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline

COPY src src
RUN ./mvnw clean package -DskipTests

# ===== RUN STAGE =====
FROM eclipse-temurin:25-jre
WORKDIR /usr/app
EXPOSE 8080

COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
