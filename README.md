# CS436-Project

# Project Group Members:

Doruk Benli 29182 - Ege Öztaş 28828 - Furkan K. Yıldırım 35145 - Nisa Erdal 28943

# Demo Video Link 

https://drive.google.com/file/d/13c5RRezbQM5gZ-6WDJQkEw_hLXDKWlOp/view

# Backend project and Description:

Our application is a social media platform like Instagram where users can post pictures and share their thoughts.
Users will be able to create accounts, add friends, like posts, comment on posts, and also view statistics about profile views.
In addition, users can also link their social media accounts and display them in their profiles.

# Cloud Architecture:

For our backend, which is developed with Express.js and Node.js, we will opt for Google Compute Engine (GCE). We've chosen Compute Engine for its flexibility and control over the computing environment.
We will manually configure our virtual machines, ensuring they are well-optimized for our application’s performance needs and allowing us to customize the scaling as necessary.

Should we decide to embrace a container-focused strategy down the line, we are aware that Google Kubernetes Engine (GKE) or Cloud Run stand ready as alternatives for orchestrating Docker containers or adopting a serverless architecture.

Our choice for the database is MongoDB Atlas, which will be hosted in its fully managed cloud service. We'll make the integration seamless with GCP and select a region that minimizes latency to ensure prompt responses within our app.

Even though we do not require automated CI/CD pipelines at this stage, we are prepared to implement them using GitHub Actions to automate our deployment processes for the backend when the need arises.

# Cloud Architecture Diagram:

![image](https://github.com/egeoztass/CS436-Project/assets/120418840/6ef6c67a-ef72-407e-a1b4-b0a3afc2fb4e)

# Installation and Running the Project:

## Dependencies

- Git: [Install Git](https://git-scm.com/downloads)
- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)
- Node.js: [Install Node.js](https://nodejs.org/en/download/)
- Yarn: [Install Yarn](https://classic.yarnpkg.com/en/docs/install)
- MongoDB: [Install MongoDB](https://docs.mongodb.com/manual/installation/)

## Clone the Repository

```bash
git clone https://github.com/furkankyildirim/CS436-Cloud-Computing-Project.git
cd CS436-Cloud-Computing-Project/
```

## Server Side

### Running the Project

1. Change directory to the server folder

```bash
cd CS436-Project/server
```

2. Create a `.env` file in the `server` directory and add the following environment variables

```bash
MONGODB_USER=user
MONGODB_PASSWORD=123456
MONGODB_HOST=localhost
MONGODB_PORT=27017
MONGO_URL=mongodb://${MONGODB_USER}:${MONGODB_PASSWORD}@${MONGODB_HOST}:${MONGODB_PORT}/
JWT_SECRET=secret
PORT=8080
```

3. Run the following commands to start the server

```bash
docker-compose up
```

## Upload Trigger Side

### Running the Project

1. Create a Service Account for Cloud Storage. The service account have Storage Admin and Storage Insights Collector Service roles and storage.buckets.get permission on the bucket.

2. Download the service account key json file from Cloud Storage Account/Keys

3. Change directory to the trigger folder

```bash
cd CS436-Project/trigger
```

4. Create a `.env` file in the `trigger` directory and add the following environment variables

```bash
GOOGLE_APPLICATION_CREDENTIALS=/PATH-TO-YOUR-KEY.JSON
BUCKET_NAME=YOUR-BUCKET-NAME
PORT=8081
```

5. Run the following commands to start the trigger

```bash
docker-compose up
```

## Client Side

### Running the Project

1. Change directory to the client folder

```bash
cd CS436-Project/client
```

2. Create a `.env` file in the `client` directory and add the following environment variables

```bash
REACT_APP_API_URL=http://localhost:3001
```

3. Run the following commands to start the client

```bash
yarn start
```

## Run on Google Cloud Platform

1. Install Google Cloud SDK: [Install Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

2. Authenticate and with Google Cloud

```bash
gcloud auth login
gcloud init
```

3. Run the gcp-start.sh script

```bash
chmod +x gcp-start.sh
./gcp-start.sh
```

## Terraform and Bash Scripting

This project utilizes CI/CD tools: bash scripting, GitHub Actions and Terraform to create auto deploying.

1. Create a service account on Google Cloud

2. Give admin privileges to the service account for Compute Engine, Artifact Registry, Cloud Run and Functions

3. Put in the necessary secrets to the project and Github Secrets

4. Download the service key JSON file and place it in the json folder in the root directory.

5. Run the terraform file in the terraform directory:

```bash
terraform init
terraform apply
'yes'
```

After following you can see the changes and deployment on your GCP account.

## Locust Testing

1. Navigate to tests directory
```bash
cd tests
```
2. Install dependencies
```bash
pip install -r requirements.txt
```
3. Start locust to test
```bash
locust
```
