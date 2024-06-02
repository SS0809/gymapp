import express from "express"; 
import cookieParser from "cookie-parser"; 
import path from "path"; 
import cors from "cors";
const app = express(); 
import indexRouter from './routes/index.js';
import Connection from './connection/connection.js';
//import admindata from './controllers/admin.js'; 
//import Search from "./controllers/Search.cont.js";{error pushed without even testing}
// import attendence from "./controllers/attendence.contr.js"; 
import {
  Age,weight,Activitiylevel,DietPlan,FitnessGoal
} from './controllers/Ai.js'
const PORT = 8080; 
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
//app.use("/member",Member); 
//app.use("/membership",membership);  
//app.use("/Search",Search);
// app.use("/attendence",attendence); 

app.listen(PORT, () => {
  console.log(`App listening at http://localhost:${PORT}`);
});
