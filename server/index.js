import express from "express";
import bodyParser from "body-parser";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import multer from "multer";
import helmet from "helmet";
import morgan from "morgan";
import path from "path";
import { fileURLToPath } from "url";
import https from 'https';
import { Readable } from 'stream';
import authRoutes from "./routes/auth.js";
import userRoutes from "./routes/users.js";
import postRoutes from "./routes/posts.js";
import { register } from "./controllers/auth.js";
import { createPost } from "./controllers/posts.js";
import { verifyToken } from "./middleware/auth.js";
import User from "./models/User.js";
import Post from "./models/Post.js";
import { users, posts } from "./data/index.js";

/* CONFIGURATIONS */
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config();
const app = express();
app.use(express.json());
app.use(helmet());
app.use(helmet.crossOriginResourcePolicy({ policy: "cross-origin" }));
app.use(morgan("common"));
app.use(bodyParser.json({ limit: "30mb", extended: true }));
app.use(bodyParser.urlencoded({ limit: "30mb", extended: true }));
app.use(cors());
app.use("/assets", express.static(path.join(__dirname, "public/assets")));

const uploadImage = async (req) => {
  try {
    const { file } = req;
    if (!file) {
      throw new Error("File is required.");
    }

    const serviceUrl = new URL(`${process.env.TRIGGER_URL}/upload`);

    const formDataBoundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW';
    const formData = [
      `--${formDataBoundary}`,
      `Content-Disposition: form-data; name="file"; filename="${file.originalname}"`,
      'Content-Type: application/octet-stream',
      '',
      file.buffer.toString('binary'),
      `--${formDataBoundary}--`,
    ].join('\r\n');

    const formDataBuffer = Buffer.from(formData, 'binary');

    const options = {
      method: 'POST',
      hostname: serviceUrl.hostname,
      path: serviceUrl.pathname,
      headers: {
        'Content-Type': `multipart/form-data; boundary=${formDataBoundary}`,
        'Content-Length': formDataBuffer.length,
      },
    };

    const uploadPromise = new Promise((resolve, reject) => {
      const req = https.request(options, (res) => {
        let data = '';
        res.on('data', (chunk) => {
          data += chunk;
        });

        res.on('end', () => {
          if (res.statusCode !== 200) {
            reject(new Error(`Error from Cloud Function: ${res.statusCode} - ${res.statusMessage}`));
          } else {
            resolve(JSON.parse(data));
          }
        });
      });

      req.on('error', (error) => {
        reject(error);
      });

      req.write(formDataBuffer);
      req.end();
    });

    const uploadResponse = await uploadPromise;
    return uploadResponse;
  } catch (error) {
    console.error("Error uploading image:", error);
    throw error;
  }
};

/* FILE STORAGE */
const storage = multer.memoryStorage();
const upload = multer({ storage });

/* ROUTES WITH FILES */
app.post("/auth/register", upload.single("picture"), register);
app.post("/posts", verifyToken, upload.single("picture"), async (req, res) => {
  try {
    console.log("Received request with body:", req.body);
    console.log("Received file:", req.file);

    const uploadResponse = await uploadImage(req);
    console.log("Upload response:", uploadResponse);

    const { url } = uploadResponse;
    console.log("Image URL:", url);

    const { userId, description } = req.body;
    const user = await User.findById(userId);
    if (!user) {
      throw new Error("User not found");
    }

    const newPost = new Post({
      userId,
      firstName: user.firstName,
      lastName: user.lastName,
      location: user.location,
      description,
      userPicturePath: user.picturePath,
      picturePath: url,
      likes: {},
      comments: [],
    });

    await newPost.save();
    const posts = await Post.find();
    res.status(201).json(posts);
  } catch (error) {
    console.error("Error creating post:", error);
    res.status(409).json({ message: error.message });
  }
});

/* ROUTES */
app.use("/auth", authRoutes);
app.use("/users", userRoutes);
app.use("/posts", postRoutes);

/* HOME ROUTE */
app.get("/", (req, res) => {
  res.send("Welcome to the API");
});

/* MONGOOSE SETUP */
const PORT = process.env.PORT || 8080;

mongoose
  .connect(process.env.MONGO_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    app.listen(PORT, () => console.log(`Server Port: ${PORT}`));

    /* ADD DATA ONE TIME */
    // User.insertMany(users);
    // Post.insertMany(posts);
  })
  .catch((error) => console.log(`${error} did not connect`));
