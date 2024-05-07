import express from "express";
const router = express.Router();
import cookieJwtAuth from '../middleware/cookieJwtAuth.js';
//import bearerJwtAuth from '../middleware/bearerJwtAuth.js'; // Corrected import path
import controllers from '../controllers/index.js';

router.post('/login', controllers.login);
router.post('/logout', controllers.logout);
router.post('/add', cookieJwtAuth, controllers.add);
router.get('/data', bearerJwtAuth, controllers.data);
router.post('/signup', controllers.signup);
export default router;
