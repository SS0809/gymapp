import jwt from "jsonwebtoken"; // Corrected import statement

const cookieJwtAuth = (req, res, next) => {
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

 const bearerJwtAuth = (req, res, next) => {
  const authHeader = req.headers.authorization;
  try {
   const user = jwt.verify(authHeader, process.env.MY_SECRET);
    req.user = user;
    next();
  } catch (err) {
    // Token verification failed
    return res.status(403).json({ error: 'Forbidden' });
  }
};

export { bearerJwtAuth , cookieJwtAuth };
