import express from "express"; 
import mongoose from "mongoose"; 
import Attendence from "../modals/attendence.js";
const attendence=express.Router(); 
// Retrive all attencdence 
attendence.get('/att',async(req,res)=>{ 
    try{
    const att=await Attendence.find(); 
    return res.status(201).json(att);
    }
    catch(err){ 
        return res.status(404).json({msg:'Internal Server Error in the System'})
    }
}); 
// Retrive attendence by userid;
attendence.get('/att/:id',async(req,res)=>{ 
    const ID=req.body; 
    try{ 
        const existinguser=await Attendence.findOne({user_id:ID}); 
        if(!existinguser){ 
            return res.status(301).json({msg:'User with this ID not found in the Database'});
        }
        else{  
            const status=await Attendence.filter(status)
            return res.status(201).json(status);
        }
    }
    catch(err){
        return res.status(404).json({msg:'Internal Server'})
    }
}); 
// Create a New Attendence; 
attendence.post('/create',async(req,res)=>{  
    try{
    const attencdence=new Attendence(req.body); 
    await attencdence.save(); 
    return res.status(201).json(attencdence);
    }
    catch(err){
        return res.status(404).json({msg:'Server Error'})
    }
});
// delete a attendence by id; 
attendence.delete('/delete',async(req,res)=>{ 
    try{ 
        const attendencedelete=await Attendence.findByIdAndDelete(req.body); 
        if(!attendencedelete){
            return res.status(301).json({msg:'Attendence Not Found'});
        }
    } 
    catch(err){
        return res.status(201).json({msg:'Attendence Sucsessfully Deleted'});
    }
});
// Update a Attendence by a specefic id;  
attendence.put('/update/:id',async(req,res)=>{   
    const user_id=req.body;  
    const status=req.body;
    const date=req.body; 
    const checkinTime=req.body; 
    const checkoutTime=req.body; 
    const remarks=req.body;  
    if(!user_id||!status||!date||!checkinTime||checkoutTime||!remarks){
        return res.status(400).json({msg:'Kindly Fill all the Blocks First'});
    } 
    try{ 
        const userexist=await Attendence.findOne({user_id:user_id}); 
        if(userexist){
            userexist.status=new status, 
            userexist.date=new date, 
            userexist.checkinTime=new checkinTime, 
            userexist.checkoutTime=new checkoutTime,
            userexist.remarks=new remarks, 
            await userexist.save(); 
            return res,status(201).json({msg:'Form Updated Sucsesfully'});
        } 
        else{
            return res.status(400).json({msg:'Incorrect User_id'});
        }
    } 
    catch(err){
        return res.status(404).json({msg:'Internal Server Error in the Backend'})
    }



    
}); 
export default attendence; 

