import express, { response } from "express"; 
import mongoose from "mongoose"; 
import Payment from '../modals/payment.schema.js'; 
const payment=express.Router();  
// Payment Method Created For Customer 

payment.post('/payment',async(req,res)=>{  
    try{
    const {user_id,amount,desc}=req.body; 
    const newpayment=new Payment({ 
        user_id, 
        amount, 
        desc, 

    }); 
    await newpayment.save(); 
    return res.status(201).json({msg:'Payment Created Sucessfully'}); 
}
    catch(err){
        return res.status(404).json({msg:'Internal Server Errror'});
    }
}); 
payment.get('/payment/:id',async(req,res)=>{ 
    try{ 
        const pay=await Payment.find(); 
        return res.status(201).json(pay);
    } 
    catch(err){
        console.log('Internal Error '); 
        return res.status(404).json({msg:'Internal Server Error'})
    }
}); 
