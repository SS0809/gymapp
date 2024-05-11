import express from "express";
const router = express.Router();
import { bearerJwtAuth }  from '../middleware/cookieJwtAuth.js';
import { login, signup, add, data, logout } from '../controllers/index.js';
import { getPlan , getPlans , createPLan , updatePlan , deletePlan } from '../controllers/plans.js'

//<-----------------------------------ADMIN-------------------------------------->
router.post('/login', login);
router.post('/logout', logout);
router.post('/add', bearerJwtAuth, add);
router.get('/data', bearerJwtAuth, data);//homepage data
router.post('/signup', signup);// adds new user
//router.post('CRUD PLANS { NAME , PRICE... }')
//router.post('CRUD USERS { CANCELL , ACTIVATE }')
//router.post('CRUD USER SPECIFIC CONTENT')
``

//plans to be edited by only admins 
//can be viewed by users
router.get('/getplan',bearerJwtAuth ,getPlan);//done
router.get('/getplans',bearerJwtAuth ,getPlans);//done
router.post('/createPLan',bearerJwtAuth ,createPLan);//done
router.post('/deleteplan' ,bearerJwtAuth ,deletePlan);//done
router.post('/updateplan' , bearerJwtAuth ,updatePlan);//done


//<-----------------------------------CLIENT------------------------------------->
router.post('/login', login);
router.post('/logout', logout);
router.get('/data', bearerJwtAuth, data);//homepage data
export default router;
