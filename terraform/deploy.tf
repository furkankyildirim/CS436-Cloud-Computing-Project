provider "google" {
  credentials = file("/Users/furkankyildirim/Desktop/CS436-Project/json/cs436-424419-f1dbca9bfa11.json")
  project     = "cs436-424419"
  region      = "europe-west4"
}

resource "null_resource" "run_shell_script" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/gcp-start.sh"
    environment = {
      VM_ZONE = "europe-west4-a"
      VM_TYPE = "e2"
      VM_CPU = "medium"
      VM_MEMORY = "4"
      FIREWALL_RULE = "allow-mongo"
      REPOSITORY_NAME = "project-repository"
      REPOSITORY_ZONE = "europe-west4"
      CLOUD_RUN_SERVICE_NAME = "server-backend"
      CLOUD_RUN_SERVICE_ZONE = "europe-west4"
      CLOUD_RUN_SERVICE_SECRET = "secret"
      CLOUD_FUNCTION_NAME = "trigger-service"
      CLOUD_FUNCTION_ZONE = "europe-west3"
      CLOUD_BUCKET_ZONE = "europe-west4"
      CLOUD_BUCKET_NAME = "picture-bucket"
    }
  }
}