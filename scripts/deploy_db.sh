#!/bin/bash

DEFAULT_DB_USER="user"
DEFAULT_DB_PASSWORD="123456"
DEFAULT_DB_HOSTNAME="server-db"
DEFAULT_DB_PORT="27017"

DEFAULT_VM_ZONE="europe-west4-a"
DEFAULT_VM_TYPE="e2-medium"
DEFAULT_VM_MEMORY="4GB"

DEFAULT_FIREWALL_RULE="allow-mongo"

# Begin deployment script
echo "Deploying MongoDB on Google Cloud VM..."

# Check if the MongoDB VM exists
echo "Checking if the MongoDB VM exists..."
VM_EXISTS=$(gcloud compute instances describe $DEFAULT_DB_HOSTNAME --zone $DEFAULT_VM_ZONE --format="get(name)" 2>/dev/null)
if [ "$VM_EXISTS" == "$DEFAULT_DB_HOSTNAME" ]; then
    echo "MongoDB VM already exists."
else
    echo "Creating MongoDB VM..."

    gcloud compute instances create-with-container $DEFAULT_DB_HOSTNAME \
        --machine-type=$DEFAULT_VM_TYPE \
        --zone=$DEFAULT_VM_ZONE \
        --tags=$DEFAULT_FIREWALL_RULE \
        --container-image=mongo:latest \
        --container-env MONGO_INITDB_ROOT_USERNAME=$DEFAULT_DB_USER,MONGO_INITDB_ROOT_PASSWORD=$DEFAULT_DB_PASSWORD \

    if [ $? -ne 0 ]; then
        echo "Failed to create MongoDB VM."
        exit 1
    else
        echo "MongoDB VM created successfully."
    fi

    # Clean up the temporary startup script file
    rm startup-script.sh
fi


# Set up firewall rule for MongoDB
echo "Setting up firewall rule for MongoDB..."
FIREWALL_EXISTS=$(gcloud compute firewall-rules describe $DEFAULT_FIREWALL_RULE --format="get(name)" 2>/dev/null)
if [ "$FIREWALL_EXISTS" == "$DEFAULT_FIREWALL_RULE" ]; then
    echo "Firewall rule already exists."
else
    echo "Creating firewall rule to allow MongoDB traffic on port $DEFAULT_DB_PORT..."
    gcloud compute firewall-rules create $DEFAULT_FIREWALL_RULE \
        --allow tcp:$DEFAULT_DB_PORT \
        --target-tags=$DEFAULT_FIREWALL_RULE \
        --direction=INGRESS

    if [ $? -ne 0 ]; then
        echo "Failed to create firewall rule."
        exit 1
    else
        echo "Firewall rule created successfully."
    fi
fi

echo "Deployment complete."
