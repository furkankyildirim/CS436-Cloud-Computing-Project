!#/bin/bash

# Default values for db user and password
DEFAULT_DB_USER="user"
DEFAULT_DB_PASSWORD="123456"
DEFAULT_DB_HOSTNAME="server-db"
DEFAULT_DB_PORT="27017"

DEFAULT_VM_ZONE="europe-west4-a"
DEFAULT_VM_TYPE="e2"
DEFAULT_VM_CPU="medium"
DEFAULT_VM_MEMORY="4"

DEFAULT_FIREWALL_RULE="allow-mongo"

DEFAULT_REPOSITORY_NAME="server-repository"
DEFAULT_REPOSITORY_ZONE="europe-west4"

DEFAULT_CLOUD_RUN_SERVICE_NAME="server-backend"
DEFAULT_CLOUD_RUN_SERVICE_ZONE="europe-west4"
DEFAULT_CLOUD_RUN_SERVICE_SECRET="secret"

DEFAULT_CLOUD_FUNCTION_NAME="trigger-service"
DEFAULT_CLOUD_FUNCTION_ZONE="europe-west3"

DEFAULT_CLOUD_BUCKET_ZONE="europe-west4"
DEFAULT_CLOUD_BUCKET_NAME="picture-bucket"


# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    --db-hostname)
        DB_HOSTNAME="$2"
        shift # past argument
        shift # past value
        ;;
    --db-port)
        DB_PORT="$2"
        shift # past argument
        shift # past value
        ;;
    --db-user)
        DB_USER="$2"
        shift # past argument
        shift # past value
        ;;
    --db-password)
        DB_PASSWORD="$2"
        shift # past argument
        shift # past value
        ;;
    --vm-zone)
        VM_ZONE="$2"
        shift # past argument
        shift # past value
        ;;
    --vm-type)
        VM_TYPE="$2"
        shift # past argument
        shift # past value
        ;;
    --vm-cpu)
        VM_CPU="$2"
        shift # past argument
        shift # past value
        ;;
    --vm-memory)
        VM_MEMORY="$2"
        shift # past argument
        shift # past value
        ;;
    --firewall-rule)
        DEFAULT_FIREWALL="$2"
        shift # past argument
        shift # past value
        ;;
    --repo-name)
        REPOSITORY_NAME="$2"
        shift # past argument
        shift # past value
        ;;
    --repo-zone)
        REPOSITORY_ZONE="$2"
        shift # past argument
        shift # past value
        ;;
    --service-name)
        CLOUD_RUN_SERVICE_NAME="$2"
        shift # past argument
        shift # past value
        ;;
    --service-zone)
        CLOUD_RUN_SERVICE_ZONE="$2"
        shift # past argument
        shift # past value
        ;;
    --service-secret)
        CLOUD_RUN_SERVICE_SECRET="$2"
        shift # past argument
        shift # past value
        ;;
    --cloud-function-name)
        CLOUD_FUNCTION_NAME="$2"
        shift # past argument
        shift # past value
        ;;
    --cloud-function-zone)
        CLOUD_FUNCTION_ZONE="$2"
        shift # past argument
        shift # past value
        ;;
    --cloud-bucket-name)
        CLOUD_BUCKET_NAME="$2"
        shift # past argument
        shift # past value
        ;;
    --cloud-bucket-zone)
        CLOUD_BUCKET_ZONE="$2"
        shift # past argument
        shift # past value
        ;;
    -h | --help)
        echo "Usage: gcp-start.sh [OPTIONS]"
        echo "Options:"
        echo "  --db-hostname          Hostname of the MongoDB VM instance. Default: server-db"
        echo "  --db-port              Port number of the MongoDB VM instance. Default: 27017"
        echo "  --db-user              Username of the MongoDB VM instance. Default: user"
        echo "  --db-password          Password of the MongoDB VM instance. Default: 123456"
        echo "  --vm-zone              Zone of the VM instance. Default: europe-west4-a"
        echo "  --vm-type              Type of the VM instance. Default: e2"
        echo "  --vm-cpu               Number of CPUs of the VM instance. Default: medium"
        echo "  --vm-memory            Memory size of the VM instance. Default: 4"
        echo "  --firewall-rule        Name of the firewall rule to allow incoming traffic. Default: allow-mongo"
        echo "  --repo-name            Name of the Artifact Registry repository. Default: server-repository"
        echo "  --repo-zone            Zone of the Artifact Registry repository. Default: europe-west4"
        echo "  --service-name         Name of the Cloud Run service. Default: server-backend"
        echo "  --service-zone         Zone of the Cloud Run service. Default: europe-west4"
        echo "  --service-secret       Secret key for the Cloud Run service. Default: secret"
        echo "  --cloud-function-name  Name of the Cloud Function. Default: trigger-service"
        echo "  --cloud-function-zone  Zone of the Cloud Function. Default: europe-west3"
        echo "  --cloud-bucket-name    Name of the Cloud Storage bucket. Default: picture-bucket"
        echo "  --cloud-bucket-zone    Zone of the Cloud Storage bucket. Default: europe-west4"
        echo "  -h, --help             Display help"
        exit 0
        ;;
    *)  # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ -z "$DB_HOSTNAME" ]; then
    echo "Warning: --db-hostname is not provided. Using the default value 'server-db'."
    DB_HOSTNAME="${DB_HOSTNAME:-$DEFAULT_DB_HOSTNAME}"
fi

if [ -z "$DB_PORT" ]; then
    echo "Warning: --db-port is not provided. Using the default value '27017'."
    DB_PORT="${DB_PORT:-$DEFAULT_DB_PORT}"
fi

if [ -z "$DB_USER" ]; then
    echo "Warning: --db-user is not provided. Using the default value 'user'."
    DB_USER="${DB_USER:-$DEFAULT_DB_USER}"
fi

if [ -z "$DB_PASSWORD" ]; then
    echo "Warning: --db-password is not provided. Using the default value '123456'."
    DB_PASSWORD="${DB_PASSWORD:-$DEFAULT_DB_PASSWORD}"
fi

if [ -z "$VM_ZONE" ]; then
    echo "Warning: --vm-zone is not provided. Using the default value 'europe-west4-a'."
    VM_ZONE="${VM_ZONE:-$DEFAULT_VM_ZONE}"
fi

if [ -z "$VM_TYPE" ]; then
    echo "Warning: --vm-type is not provided. Using the default value 'e2'."
    VM_TYPE="${VM_TYPE:-$DEFAULT_VM_TYPE}"
fi

if [ -z "$VM_CPU" ]; then
    echo "Warning: --vm-cpu is not provided. Using the default value 'medium'."
    VM_CPU="${VM_CPU:-$DEFAULT_VM_CPU}"
fi

if [ -z "$VM_MEMORY" ]; then
    echo "Warning: --vm-memory is not provided. Using the default value '4'."
    VM_MEMORY="${VM_MEMORY:-$DEFAULT_VM_MEMORY}"
fi

if [ -z "$FIREWALL_RULE" ]; then
    echo "Warning: --firewall-rule is not provided. Using the default value 'allow-mongo'."
    FIREWALL_RULE="${FIREWALL_RULE:-$DEFAULT_FIREWALL_RULE}"
fi

if [ -z "$REPOSITORY_NAME" ]; then
    echo "Warning: --repo-name is not provided. Using the default value 'server-repository'."
    REPOSITORY_NAME="${REPOSITORY_NAME:-$DEFAULT_REPOSITORY_NAME}"
fi

if [ -z "$REPOSITORY_ZONE" ]; then
    echo "Warning: --repo-zone is not provided. Using the default value 'europe-west4'."
    REPOSITORY_ZONE="${REPOSITORY_ZONE:-$DEFAULT_REPOSITORY_ZONE}"
fi

if [ -z "$CLOUD_RUN_SERVICE_NAME" ]; then
    echo "Warning: --service-name is not provided. Using the default value 'server-backend'."
    CLOUD_RUN_SERVICE_NAME="${CLOUD_RUN_SERVICE_NAME:-$DEFAULT_CLOUD_RUN_SERVICE_NAME}"
fi

if [ -z "$CLOUD_RUN_SERVICE_ZONE" ]; then
    echo "Warning: --service-zone is not provided. Using the default value 'europe-west4'."
    CLOUD_RUN_SERVICE_ZONE="${CLOUD_RUN_SERVICE_ZONE:-$DEFAULT_CLOUD_RUN_SERVICE_ZONE}"
fi

if [ -z "$CLOUD_RUN_SERVICE_SECRET" ]; then
    echo "Warning: --service-secret is not provided. Using the default value 'secret'."
    CLOUD_RUN_SERVICE_SECRET="${CLOUD_RUN_SERVICE_SECRET:-$DEFAULT_CLOUD_RUN_SERVICE_SECRET}"
fi

if [ -z "$CLOUD_FUNCTION_NAME" ]; then
    echo "Warning: --cloud-function-name is not provided. Using the default value 'trigger-service'."
    CLOUD_FUNCTION_NAME="${CLOUD_FUNCTION_NAME:-$DEFAULT_CLOUD_FUNCTION_NAME}"
fi

if [ -z "$CLOUD_FUNCTION_ZONE" ]; then
    echo "Warning: --cloud-function-zone is not provided. Using the default value 'europe-west4'."
    CLOUD_FUNCTION_ZONE="${CLOUD_FUNCTION_ZONE:-$DEFAULT_CLOUD_FUNCTION_ZONE}"
fi

if [ -z "$CLOUD_BUCKET_NAME" ]; then
    echo "Warning: --cloud-bucket-name is not provided. Using the default value 'picture-bucket'."
    CLOUD_BUCKET_NAME="${CLOUD_BUCKET_NAME:-$DEFAULT_CLOUD_BUCKET_NAME}"
fi

if [ -z "$CLOUD_BUCKET_ZONE" ]; then
    echo "Warning: --cloud-bucket-zone is not provided. Using the default value 'europe-west4'."
    CLOUD_BUCKET_ZONE="${CLOUD_BUCKET_ZONE:-$DEFAULT_CLOUD_BUCKET_ZONE}"
fi

# Check if gcloud command is installed
if ! command -v gcloud &> /dev/null; then
    echo "Error: gcloud command not found. Please make sure Google Cloud SDK is installed and configured."
    exit 1
fi

PROJECT_ID=$(gcloud config get-value project)

# STEP 1: Mongo DB Installation
# Use gcloud to list VM instances and check if the specified VM exists
if gcloud compute instances list --format="value(name)" | grep -q "^$DB_HOSTNAME$"; then
    echo "DB '$DB_HOSTNAME' exists."
    
    # Get the IP address of the VM
    DB_IP=$(gcloud compute instances describe $DB_HOSTNAME --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
    
    # Display the IP address with port 27017, user, and password
    echo "IP Address of DB '$DB_IP' with port 27017: $DP_IP:27017"
    echo "DB User: $DB_USER"
    echo "DB Password: $DB_PASSWORD"
else
    echo "DB '$DB_HOSTNAME' does not exist. Creating a new VM instance with MongoDB."
    gcloud compute instances create-with-container $DB_HOSTNAME \
        --container-image=mongo:latest \
        --tags=server-db \
        --container-env MONGO_INITDB_ROOT_USERNAME=$DB_USER,MONGO_INITDB_ROOT_PASSWORD=$DB_PASSWORD \
        --zone $VM_ZONE \
        --custom-cpu $VM_CPU \
        --custom-memory $VM_MEMORY \
        --custom-vm-type $VM_TYPE

    # Check if the VM is created successfully. If the error code exists, print the raised error.
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create the VM instance."
        exit 1
    fi

    # Get the IP address of the VM
    DB_IP=$(gcloud compute instances describe $DB_HOSTNAME --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
    echo "IP Address of DB '$DB_IP' created with port 27017: $DB_IP:27017"
    echo "DB User: $DB_USER"
    echo "DB Password: $DB_PASSWORD"
fi

# Check if the firewall rule exists
if gcloud compute firewall-rules list --format="value(name)" | grep -q "^$FIREWALL_RULE$"; then
    echo "Firewall rule '$FIREWALL_RULE' exists."
else
    echo "Firewall rule '$FIREWALL_RULE' does not exist. Creating a new firewall rule to allow incoming traffic."
    # Allow incoming traffic on port 27017
    gcloud compute firewall-rules create $FIREWALL_RULE \
        --allow tcp:$DB_PORT \
        --target-tags server-db
    echo "Incoming traffic on port $DB_PORT is allowed."
fi

# Check if the VM is running
if gcloud compute instances list --format="value(name)" | grep -q "^$DB_HOSTNAME$"; then
    echo "DB '$DB_HOSTNAME' is running."
    # Give mongo uri
    echo "Mongo URI: mongodb://$DB_USER:$DB_PASSWORD@$DB_IP:$DB_PORT"
else
    echo "Error: DB '$DB_HOSTNAME' is not running."
    exit 1
fi

# STEP 2: Application Deployment

# Enable the Artifact Registry API
echo "Enabling the Artifact Registry API."
gcloud services enable artifactregistry.googleapis.com cloudbuild.googleapis.com

# Create a Artifact Registry repository with the zone
if gcloud artifacts repositories list --format="value(name)" | grep -q "^$REPOSITORY_NAME$"; then
    echo "Artifact Registry repository '$REPOSITORY_NAME' exists."
else
    echo "Artifact Registry repository '$REPOSITORY_NAME' does not exist. Creating a new repository."
    gcloud artifacts repositories create $REPOSITORY_NAME \
        --project=$PROJECT_ID \
        --repository-format=docker \
        --location=$REPOSITORY_ZONE \
        --description="Server Container Repository"
    echo "Artifact Registry repository '$REPOSITORY_NAME' is created."
fi

# Authenticate to the Artifact Registry repository and docker login
cd ./server && gcloud auth configure-docker "$REPOSITORY_ZONE-docker.pkg.dev" --quiet && cd ..

# Build and push the server image to the Artifact Registry repository if it does not exist
gcloud builds submit --tag $REPOSITORY_ZONE-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/server-image:latest ./server

# Check if the image is built and pushed successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to build and push the image to the Artifact Registry repository."
    exit 1
else
    echo "Image is built and pushed to the Artifact Registry repository."
    echo "Image URI: $REPOSITORY_ZONE-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/server-image:latest"
fi


# STEP 3: Cloud Storage Bucket
# Enable the Cloud Storage API
echo "Enabling the Cloud Storage API."
gcloud services enable storage-component.googleapis.com --quiet

# Create a Cloud Storage bucket if it does not exist
if gsutil ls | grep -q "gs://$PROJECT_ID-$CLOUD_BUCKET_NAME"; then
    echo "Cloud Storage bucket 'gs://$PROJECT_ID-$CLOUD_BUCKET_NAME' exists."
else
    echo "Cloud Storage bucket 'gs://$PROJECT_ID-$CLOUD_BUCKET_NAME' does not exist. Creating a new bucket."
    gsutil mb -l $CLOUD_BUCKET_ZONE gs://$PROJECT_ID-$CLOUD_BUCKET_NAME/
    echo "Cloud Storage bucket 'gs://$PROJECT_ID-$CLOUD_BUCKET_NAME' is created."
fi

# Check if the bucket is created successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to create the Cloud Storage bucket."
    exit 1
else
    echo "Cloud Storage bucket 'gs://$PROJECT_ID-$CLOUD_BUCKET_NAME' is created."
fi


# STEP 4: Trigger Deployment
# Enable cloud functions API
echo "Enabling the Cloud Functions API."
gcloud services enable cloudfunctions.googleapis.com --quiet

# Deploy the trigger function to the Cloud Functions using Python FastaAPI
gcloud functions deploy $CLOUD_FUNCTION_NAME \
    --entry-point handler \
    --runtime python39 \
    --trigger-http \
    --allow-unauthenticated \
    --region $CLOUD_FUNCTION_ZONE \
    --source ./trigger \
    --set-env-vars BUCKET_NAME=$PROJECT_ID-$CLOUD_BUCKET_NAME

# Check if the function is deployed successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to deploy the Cloud Function."
    exit 1
else
    echo "Cloud Function '$CLOUD_FUNCTION_NAME' is deployed."
fi

# Get the trigger URL of the Cloud Function
TRIGGER_URL=$(gcloud functions describe $CLOUD_FUNCTION_NAME --region=$CLOUD_FUNCTION_ZONE --format="value(httpsTrigger.url)")

# STEP 4: Deploy the application to the Cloud Run
# Enable the Cloud Run API
echo "Enabling the Cloud Run API."
gcloud services enable run.googleapis.com --quiet

# Deploy the application to the Cloud Run
gcloud run deploy $CLOUD_RUN_SERVICE_NAME \
    --image $REPOSITORY_ZONE-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/server-image:latest \
    --platform managed \
    --region $CLOUD_RUN_SERVICE_ZONE \
    --allow-unauthenticated \
    --set-env-vars MONGO_URL="mongodb://$DB_USER:$DB_PASSWORD@$DB_IP:$DB_PORT",JWT_SECRET=$CLOUD_RUN_SERVICE_SECRET,TRIGGER_URL=$TRIGGER_URL
