from fastapi import FastAPI, UploadFile, File, HTTPException
from google.cloud import storage
from google.cloud.storage.blob import Blob
import tempfile
import os
import uuid
from dotenv import load_dotenv

app = FastAPI()

# Load environment variables from .env file
load_dotenv()

# Get bucket name from environment variables
bucket_name = os.getenv("BUCKET_NAME", "cs-436-project")
if not bucket_name:
    raise EnvironmentError("BUCKET_NAME not found in environment variables")

# Set up Google Cloud Storage client
storage_client = storage.Client()
bucket = storage_client.get_bucket(bucket_name)

@app.post("/upload/")
async def upload_file(file: UploadFile = File(...)):
    try:
        # Generate a random filename
        file_extension = os.path.splitext(file.filename)[1]
        file_name = str(uuid.uuid4()) + file_extension

        # Create a temporary file to store the uploaded file
        with tempfile.NamedTemporaryFile(delete=False) as temp_file:
            temp_file.write(await file.read())

        # Upload the file to Google Cloud Storage
        blob = bucket.blob(file_name)
        blob.upload_from_filename(temp_file.name)

        # Make the file publicly accessible
        blob.make_public()

        # Delete the temporary file
        os.unlink(temp_file.name)

        # Return the URL of the uploaded file
        return {"url": blob.public_url}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
