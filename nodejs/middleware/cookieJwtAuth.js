import jwt from "jsonwebtoken"; // Corrected import statement

export const cookieJwtAuth = (req, res, next) => {
  const token = req.cookies.token;
  try {
    const user = jwt.verify(token, process.env.MY_SECRET);
    req.user = user;
    next();
  } catch (err) {
    res.clearCookie("token");
    return res.redirect("/");
  }
};

export const bearerJwtAuth = (req, res, next) => {
  const authHeader = req.headers.authorization;
  console.log(authHeader);
  try {
    const token = authHeader.split(" ")[1]; // Extract token from Authorization header
    const user = jwt.verify(token, process.env.MY_SECRET);
    req.user = user;
    console.log("ru");
    next();
  } catch (err) {
    // Token verification failed
    return res.status(403).json({ error: 'Forbidden' });
  }
};
