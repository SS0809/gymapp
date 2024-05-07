import express from "express"; 
import cookieParser from "cookie-parser"; 
import path from "path"; 
import cors from "cors";
const app = express(); 
import indexRouter from './routes/index.js';
import Connection from './connection/connection.js';
import admindata from './controllers/admin.js';
const PORT = 8080; 
const DB_URL="mongodb://localhost:27017";
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
