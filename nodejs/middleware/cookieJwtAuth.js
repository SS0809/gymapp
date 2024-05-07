const jwt = require("jsonwebtoken");

exports.cookieJwtAuth = (req, res, next) => {
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

exports.bearerJwtAuth = (req, res, next) => {
  const authHeader = req.headers.authorization;
  console.log(authHeader)
  try {
    const user = jwt.verify(authHeader, process.env.MY_SECRET);
    req.user = user;
    console.log("ru")
    next();
  } catch (err) {
    // Token verification failed
    return res.status(403).json({ error: 'Forbidden' });
  }
};
