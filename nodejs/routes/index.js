import express from "express";
const router = express.Router();
import { bearerJwtAuthmustAdmin , bearerJwtAuth }  from '../middleware/cookieJwtAuth.js';
import { getSuggestions, login, signup, add, data, logout } from '../controllers/index.js';
import { getPlan , getPlans , createPLan , updatePlan , deletePlan } from '../controllers/plans.js'
import { getuserpayment , createpayment , getpayments } from "../controllers/payment.js";
import { getuser , getusers_user , getusers } from "../controllers/user.js";
import { revenuetotal } from "../controllers/Revenue.js";
import { uploaddata , getAlldata, deletedata } from "../controllers/content.js";
//<-----------------------------------ADMIN-------------------------------------->
router.post('/login', login);
router.post('/logout', logout);
router.get('/suggestions', bearerJwtAuthmustAdmin, getSuggestions);
router.post('/add', bearerJwtAuth, add);
router.get('/data', bearerJwtAuth, data);//homepage data
router.post('/signup',bearerJwtAuthmustAdmin , signup);// adds new user
//router.post('CRUD PLANS { NAME , PRICE... }')
//router.post('CRUD USERS { CANCELL , ACTIVATE }')
//router.post('CRUD USER SPECIFIC CONTENT')
``
//PLAN
//plans to be edited by only admins 
//can be viewed by users
router.get('/getplan',bearerJwtAuth ,getPlan);//done
router.get('/getplans',bearerJwtAuth ,getPlans);//done
router.post('/createPLan',bearerJwtAuthmustAdmin ,createPLan);//done
router.post('/deleteplan' ,bearerJwtAuthmustAdmin ,deletePlan);//done
router.post('/updateplan' , bearerJwtAuthmustAdmin ,updatePlan);//done


//PAYMENT
router.post('/createpayment',bearerJwtAuthmustAdmin ,createpayment);//done
router.get('/getpayments',bearerJwtAuthmustAdmin ,getpayments);//done
router.get('/getuserpayment',bearerJwtAuth ,getuserpayment);//done
router.post('/revenuetotal',bearerJwtAuthmustAdmin,revenuetotal);
/*
[
    { "year": 2024, "month": 1, "total": 301.25 },
    { "year": 2024, "month": 2, "total": 300.00 }
]
*/  
//USER
router.get('/getuser' , bearerJwtAuthmustAdmin , getuser);
router.get('/getusers' , bearerJwtAuthmustAdmin , getusers);
router.get('/getusers_user' , bearerJwtAuthmustAdmin , getusers_user);






//Content
router.post('/uploaddata' , bearerJwtAuthmustAdmin , uploaddata);//done
router.get('/getalldata' , bearerJwtAuthmustAdmin ,  getAlldata);//done
router.post('/deletedata' , bearerJwtAuthmustAdmin , deletedata);

//<-----------------------------------CLIENT------------------------------------->
router.post('/login', login);
router.post('/logout', logout);
router.get('/data', bearerJwtAuth, data);//homepage data
export default router;
