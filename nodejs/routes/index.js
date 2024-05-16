import express from "express";
const router = express.Router();
import { bearerJwtAuth }  from '../middleware/cookieJwtAuth.js';
import { login, signup, add, data, logout } from '../controllers/index.js';


router.post('/login', login);
router.post('/logout', logout);
router.post('/add', bearerJwtAuth, add);
router.get('/data', bearerJwtAuth, data);
router.post('/signup', signup);
export default router;
