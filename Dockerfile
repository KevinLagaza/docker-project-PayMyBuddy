# Stage 1: Build
FROM maven:3.9-amazoncorretto-17-alpine AS builder

WORKDIR /app

# Copy pom.xml and download dependencies (cached layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests


# Stage 2: Production
FROM amazoncorretto:17-alpine

LABEL maintainer="lagazakevin@gmail.com" \
      description="PayMyBuddy - Transfer money easily between friends"

WORKDIR /app

# Copy the built JAR (name defined in pom.xml: paymybuddy.jar)
COPY --from=builder /app/target/paymybuddy.jar app.jar

EXPOSE 8080

ENV SPRING_DATASOURCE_USERNAME  # Database username                                                                       
ENV SPRING_DATASOURCE_PASSWORD  # Database password                                                                       
ENV SPRING_DATASOURCE_URL       # Database connection URL 

ENTRYPOINT ["java", "-jar", "app.jar"]
