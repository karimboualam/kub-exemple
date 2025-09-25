# Étape 1 : image de base Java
FROM openjdk:21-jdk-slim

# Étape 2 : Copier le jar généré
COPY target/k8sapp-0.0.1-SNAPSHOT.jar app.jar

# Étape 3 : Démarrer l'application
ENTRYPOINT ["java", "-jar", "/app.jar"]
