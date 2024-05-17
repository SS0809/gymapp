import express from "express"; 
import mongoose from "mongoose" 
import Revenue  from "../modals/Revenue.modal.js"; 
const revenue=express.Router();  
let users=[]; 
let TotalRevenue=[]; 
// Only Admin can Add users 
revenue.post('/add',async(req,res)=>{   
    try{
    const {user_id,password}=req.body; 
    const adminfound=await Revenue.findOne({user_id:user_id}); 
    if(!adminfound){
        return res.status(301).json({msg:'No admin Exist in the Database'});
    }  
    else{ 
        return res.status(201).json({msg:'Admin found'});
    }  
    const passwordverify=await Revenue.findOne({password:password}); 
    if(passwordverify){
        return res.status(201).json({msg:'Admin Sucsessfully Verified'});
    } 
    else{ 
        return  res.status(404).json({msg:'Wrong Password!,Please Try again'});
    } 
    if(adminfound&&password){// Only user can be added  by admin

        const user=req.body; 
        users.push(user);
        return res.status(201).json({msg:"User Added Sucsessfully"});
    } 
    else{ 
        return res.status(401).json({msg:'Unauthorized'});
    }

} 
catch(err){
    console.log('Internal Server Error');
    return res.status(404).json({msg:'Internal Server Error'});
}

}) 
revenue.get('/total',async(req,res)=>{ // Get total Income at present
    try{
        const amount=req.body; 
        const total=TotalRevenue.reduce((acc,curr)=>acc+amount,0);
        return res.status(201).json(total);
    }
    catch(err){
        return res.status(404).json({msg:'Internal Server Error in the System'});
    }
}) 
revenue.get('/revenue/monthly/:year/:month', (req, res) => {
    const { year, month } = req.body;
    const startDate = new Date(year, month - 1, 1); // month is 0-indexed in Date constructor
    const endDate = new Date(year, month, 0);

    const monthlyRevenue = TotalRevenue.reduce((acc, payment) => {
        const paymentDate = new Date(payment.payment_date);
        if (paymentDate >= startDate && paymentDate <= endDate) {
            acc += payment.amount;
        }
        return acc;
    }, 0);

    res.json({ monthlyRevenue });
});  
export default revenue;
