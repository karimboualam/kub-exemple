# 🚀 Spring Boot + Docker + Kubernetes (Minikube)

Ce projet est une application **Spring Boot** simple (API calculatrice) containerisée avec **Docker** et déployée sur **Kubernetes** via **Minikube**.  
Il s’agit d’un exemple pédagogique pour apprendre à déployer une application Java dans un cluster Kubernetes.

---

## ⚙️ Fonctionnalités

- Endpoint `/add?a=2&b=3` → retourne `5`
- Endpoint `/multiply?a=4&b=6` → retourne `24`

---

## 📦 1. Build de l'application

Compiler et packager l’application en **JAR** avec Maven :

```bash
mvn clean package -DskipTests

👉 Le JAR généré se trouve dans target/k8sapp-0.0.1-SNAPSHOT.jar.

🐳 2. Docker

Dockerfile

FROM openjdk:21-jdk-slim
COPY target/k8sapp-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

Construire l’image

docker build -t kub-exemple:1.0 .

Tester en local

docker run -p 9090:8081 kub-exemple:1.0

docker run -p 9090:8081 kub-exemple:1.0

👉 Tester :

http://localhost:9090/add?a=2&b=3

http://localhost:9090/multiply?a=4&b=6

☸️ 3. Kubernetes (Minikube)
a) Lancer Minikube

minikube start --driver=docker

b) Déployer les manifests
deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: kub-exemple-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: kub-exemple
  template:
    metadata:
      labels:
        app: kub-exemple
    spec:
      containers:
      - name: kub-exemple
        image: kub-exemple:1.0
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8081

service.yaml

apiVersion: v1
kind: Service
metadata:
  name: kub-exemple-service
spec:
  type: NodePort
  selector:
    app: kub-exemple
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8081
      nodePort: 30080

c) Charger l’image Docker dans Minikube

minikube image load kub-exemple:1.0

d) Appliquer les fichiers

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

e) Vérifier le déploiement


kubectl get pods
kubectl get svc

f) Accéder au service

minikube service kub-exemple-service


👉 Exemple d’URL générée :

http://127.0.0.1:59689

Tester :

http://127.0.0.1:59689/add?a=2&b=9 → 11

http://127.0.0.1:59689/multiply?a=3&b=5 → 15


📂 Structure du projet

k8sapp/
 ├── src/
 │   └── main/java/com/kuber/k8sapp/
 │       └── CalculatorController.java
 ├── target/
 ├── Dockerfile
 ├── deployment.yaml
 ├── service.yaml
 ├── pom.xml
 └── README.md


✅ Résumé

Spring Boot app → build JAR avec Maven

Docker → création d’image kub-exemple:1.0

Kubernetes → déploiement via Minikube (Deployment + Service)

Test API REST → accessible via tunnel Minikube

