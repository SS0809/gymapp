import express from "express"; 
import cookieParser from "cookie-parser"; 
import path from "path"; 
import cors from "cors";
const app = express(); 
import indexRouter from './routes/index.js';
import Connection from './connection/connection.js';
import admindata from './controllers/admin.js';
const PORT = 8080; 
import { config as dotenvConfig } from 'dotenv';
dotenvConfig();
const DB_URL = process.env.DB_URI;
app.use(cors());
Connection(DB_URL);
app.use(
  express.urlencoded({
    extended: true,
  })
);
app.use(cookieParser());


app.use("/", indexRouter);

app.listen(PORT, () => {
  console.log(`Example app listening at http://localhost:${PORT}`);
});
