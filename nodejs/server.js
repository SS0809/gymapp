import express from "express"; 
import cookieParser from "cookie-parser"; 
import path from "path"; 
import cors from "cors";
const app = express(); 
import indexRouter from './routes/index.js';
import Connection from './connection/connection.js';
import {
  Age,Weight,Activitiylevel,DietPlan,FitnessGoal
} from './controllers/Ai.js'
import { config as dotenvConfig } from 'dotenv';
dotenvConfig();
const DB_URL = 'mongodb+srv://user1:wqffE82CrOewXIIh@cluster0.fcjxhuf.mongodb.net/BLEAN';
app.use(cors());
Connection(DB_URL);
app.use(
  express.urlencoded({
    extended: true,
  })
);
app.use(cookieParser());
import multer from 'multer';
const upload = multer({ dest: 'datauploads/' }); // Specify a temporary directory for uploaded files

// Middleware to handle file uploads
app.use(upload.single('file')); 

app.use("/", indexRouter); 

app.listen(process.env.PORT, () => {
  console.log(`App listening at http://localhost:${process.env.PORT}`);
});
