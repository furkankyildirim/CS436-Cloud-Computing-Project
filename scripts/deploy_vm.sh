#!/bin/bash

# Default configuration values
DEFAULT_DB_USER="user"
DEFAULT_DB_PASSWORD="123456"
DEFAULT_DB_HOSTNAME="server-db"
DEFAULT_DB_PORT="27017"

DEFAULT_VM_ZONE="europe-west4-a"
DEFAULT_VM_TYPE="e2-medium"
DEFAULT_VM_MEMORY="4GB"

DEFAULT_FIREWALL_RULE="allow-mongo"

# Google Cloud Project ID
PROJECT_ID="$(gcloud config get-value project)"

# Deploy MongoDB on a GCE instance
function deploy_mongo_vm() {
    echo "Checking if the MongoDB VM exists..."
    if gcloud compute instances describe $DEFAULT_DB_HOSTNAME --zone $DEFAULT_VM_ZONE &> /dev/null; then
        echo "MongoDB VM already exists."
    else
        echo "Creating MongoDB VM..."
        gcloud compute instances create $DEFAULT_DB_HOSTNAME \
            --machine-type=$DEFAULT_VM_TYPE \
            --image-family=debian-10 \
            --image-project=debian-cloud \
            --zone=$DEFAULT_VM_ZONE \
            --tags=$DEFAULT_FIREWALL_RULE \
            --metadata=startup-script='#! /bin/bash
            apt-get update
            apt-get install -y mongodb
            service mongodb start
            mongo --eval "db.createUser({user: "'$DEFAULT_DB_USER'", pwd: "'$DEFAULT_DB_PASSWORD'", roles:[{role:"'root'", db:"'admin'"}]})"
            echo "bind_ip = 0.0.0.0" >> /etc/mongodb.conf
            service mongodb restart'
        echo "MongoDB VM created."
    fi
}

# Configure Firewall to allow traffic to MongoDB
function setup_firewall() {
    echo "Setting up firewall rule for MongoDB..."
    if gcloud compute firewall-rules describe $DEFAULT_FIREWALL_RULE &> /dev/null; then
        echo "Firewall rule already exists."
    else
        gcloud compute firewall-rules create $DEFAULT_FIREWALL_RULE \
            --direction=INGRESS \
            --priority=1000 \
            --network=default \
            --action=ALLOW \
            --rules=tcp:$DEFAULT_DB_PORT \
            --source-ranges=0.0.0.0/0 \
            --target-tags=$DEFAULT_FIREWALL_RULE
        echo "Firewall rule created."
    fi
}

# Main execution
echo "Deploying MongoDB on Google Cloud VM..."
deploy_mongo_vm
setup_firewall

echo "Deployment complete."
