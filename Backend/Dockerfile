# ===== BUILD STAGE =====
FROM openjdk:25-ea-21-jdk-slim AS build
WORKDIR /app

COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline

COPY src src
RUN ./mvnw clean package -DskipTests

# ===== RUN STAGE =====
FROM openjdk:25-ea-21-jre-slim
WORKDIR /usr/app
EXPOSE 8080

COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
