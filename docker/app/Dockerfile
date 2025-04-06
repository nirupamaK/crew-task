FROM maven:3.8.7-openjdk-18-slim AS builder

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/crewmeister/devops-coding-challenge.git .

#COPY ../../app/ .

RUN mvn clean install -DskipTests

FROM openjdk:17-slim

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
