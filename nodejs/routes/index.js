const express = require('express');
const router = express.Router(); // access the method of route
const { bearerJwtAuth } = require("../middleware/cookieJwtAuth");
const controllers = require('../controllers/index');

router.post('/login', controllers.login);
router.post('/logout', controllers.logout);
router.post('/add', bearerJwtAuth, controllers.add);
router.get('/data', bearerJwtAuth, controllers.data);
router.post('/signup',controllers.signup);
module.exports = router;