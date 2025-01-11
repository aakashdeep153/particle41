# particle41
Web-service hosted on EKS Cluster

To complete the task of developing the "SimpleTimeService" microservice, Dockerizing it, creating a Kubernetes manifest, and pushing the code to a public repository, follow these steps:

Step 1: Create the SimpleTimeService Application
Here’s an example of how to create a simple web server in Python using Flask:

Create a new directory for your project:
  mkdir SimpleTimeService
  cd SimpleTimeService
Create a Python virtual environment (optional but recommended):
  python3 -m venv venv
  source venv/bin/activate
Install Flask:
  pip install Flask
Create the application file app.py:
from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def get_time():
    return jsonify({
        "timestamp": datetime.now().isoformat(),
        "ip": request.remote_addr
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
Step 2: Create the Dockerfile
Create a Dockerfile in the same directory:
# Use a lightweight base image
FROM python:3.9-slim

# Create a non-root user
RUN useradd -m appuser

# Set the working directory
WORKDIR /app

# Copy the requirements and application code
COPY requirements.txt requirements.txt
COPY app.py app.py

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Change to the non-root user
USER appuser

# Expose the port
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
Create a requirements.txt file:
Flask==2.0.1
Step 3: Build and Push the Docker Image
Build the Docker image:
docker build -t yourusername/simpletimeservice:latest .
Log in to Docker Hub:
docker login
Push the image to Docker Hub:
docker push yourusername/simpletimeservice:latest

Step 4: Create Kubernetes Manifest

Create a file named microservice.yml:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: simpletimeservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: simpletimeservice
  template:
    metadata:
      labels:
        app: simpletimeservice
    spec:
      containers:
      - name: simpletimeservice
        image: yourusername/simpletimeservice:latest
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: simpletimeservice
spec:
  type: ClusterIP
  ports:
  - port: 5000
    targetPort: 5000
  selector:
    app: simpletimeservice

Step 5: Push Code to a Public Git Repository

Initialize a git repository:

git init
git add .
git commit -m "Initial commit of SimpleTimeService"
Push to a public repository (e.g., GitHub):
git remote add origin https://github.com/yourusername/SimpleTimeService.git
git push -u origin master

Step 6: Documentation
Create a README.md file with deployment instructions:
# SimpleTimeService

A simple microservice that returns the current timestamp and the visitor's IP address.

## Deployment Instructions

1. Build and push the Docker image:
   ```bash
   docker build -t yourusername/simpletimeservice:latest .
   docker push yourusername/simpletimeservice:latest
Apply the Kubernetes manifest:
kubectl apply -f microservice.yml
Access the service:
kubectl port-forward service/simpletimeservice 5000:5000
Then, visit http://localhost:5000 to see the JSON response.
Final Notes
Ensure that you replace yourusername with your actual Docker Hub username in the Dockerfile and Kubernetes manifest.
Make sure to test the deployment in a Kubernetes cluster to verify that everything works as expected.
Follow best practices for containerization and documentation to ensure code quality and maintainability.
