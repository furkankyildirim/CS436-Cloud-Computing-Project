import { Storage } from '@google-cloud/storage';
import express from 'express';
import { format } from 'util';
import Multer from 'multer';
import { v4 as uuidv4 } from 'uuid';

const app = express();
const storage = new Storage();
const bucketName = process.env.BUCKET_NAME;
const bucket = storage.bucket(bucketName);

const multer = Multer({
  storage: Multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024, // Limit file size to 5MB
  },
});

// Define a route to handle file upload
app.post('/upload', multer.single('picture'), async (req, res) => {
  try {
    const file = req.file;
    if (!file) {
      return res.status(400).send('No file uploaded.');
    }

    const fileName = `${uuidv4()}.${file.originalname.split('.').pop()}`;

    const fileUpload = bucket.file(fileName);
    const stream = fileUpload.createWriteStream({
      metadata: {
        contentType: file.mimetype,
      },
    });

    stream.on('error', err => {
      res.status(500).send('Error uploading file: ' + err);
    });

    stream.on('finish', async () => {
      await fileUpload.makePublic(); // Make the file publicly accessible
      const publicUrl = format(
        `https://storage.googleapis.com/${bucket.name}/${fileName}`
      );
      res.status(200).send(publicUrl);
    });

    stream.end(file.buffer);
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
});

// Start the server
const PORT = process.env.PORT || 8081;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
