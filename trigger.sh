gcloud functions deploy trigger-service \
    --entry-point handler \
    --runtime python39 \
    --trigger-http \
    --allow-unauthenticated \
    --source ./trigger \
    --set-env-vars BUCKET_NAME=cloud-project-424318-picture-bucket