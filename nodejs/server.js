import express from "express"; 
import cookieParser from "cookie-parser"; 
import path from "path"; 
const app = express();
const indexRouter = require("./routes/index");
const PORT = 8080; 
const DB_URL="mongodb://localhost:27017";

app.use(
  express.urlencoded({
    extended: true,
  })
);
app.use(cookieParser());

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "../public/index.html"));
});

app.get("/welcome", (req, res) => {
  res.sendFile(path.join(__dirname, "../public/welcome.html"));
});

app.use("/", indexRouter);

app.listen(PORT, () => {
  console.log(`Example app listening at http://localhost:${PORT}`);
});
