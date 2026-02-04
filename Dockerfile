# 1. Use a lightweight JDK runtime for the container
FROM eclipse-temurin:17-jdk-alpine

# 2. Set the working directory inside the container
WORKDIR /app

# 3. Copy the .jar file created by 'mvn package' into the container
# Note: 'mvn package' usually puts the jar in the 'target' folder
COPY target/*.jar app.jar

# 4. Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]