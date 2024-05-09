 import express from "express";
 import mongoose  from "mongoose";

import trainermodel from '../modals/trainermodal.js' 
import member from "./member.js";
const trainer=express.Router(); 
// Retrive all the trainer 
trainer.get('/trainer',async(req,res)=>{ 
    try{
        await trainermodel.find(req.query);  

        return res.status(201).json(trainer);
    } 
    catch(err){  
        console.log('Error in the database');
        return res.status(404).json({msg:'Internal Server Error'});
    } 


}); 
// Retrtive Trainer Via id 
trainer.get('/trainer/:id',async(req,res)=>{
    try{ 
        const trainer_id=req.body; 
        if(!trainer_id){ 
            return res.status(301).json({msg:'Please Enter the trainer id Carefully'})
        } 
        const trainer_found=await trainermodel.findOne(trainer_id);  
        if(!trainer_found){ 
            return res.status(401).json({msg:'Trainer not found with this Specific Id'})
        }
        else{ 
            return res.status(201).json(trainer_id);
        }

    } 
    catch(err){ 
        console.log('Server Error in the Database');
        return res.status(404).json({msg:'Internal Server Error in the System'});
    }
});   
// Create a new member 

trainer.post('/create',async(req,res)=>{ 
        const first_name=req.body.first_name; 
        const last_name=req.last_name; 
        const train_id=req.train.id; 
        const fee=req.body.fee; 
        const email=req.body.email;
        const weight=req.body.url;
        if(!first_name||!last_name||!train_id||!fee||!weight){ 
            return res.status(301).json({msg:'Please Fill all the Data Carefully'});
        } 
        try{ 
            const existingemail=await trainermodel.findOne({email:email}); 
            const existingid=await trainermodel.findOne({train_id:train_id}); 
            if(existingemail){ 
                res.status(301).json({msg:'This email is Already taken'})
            } 
            if(existingid){ 
                res.status(301).json({msg:'This Username is Already Taken'})
            } 
            const fee=req.body; 
            if(fee<500){ 
                return res.status(301).json({msg:`Kindly ENter the amount Greater than 500`})
            }
            const newMember=new member({ 
                first_name, 
                last_name, 
                train_id, 
                fee, 
                email, 
                weight
            })
            await newMember.save(); 
            return res.status(201).json({msg:`Form Sucsessfully SUbmiited`})
        }
        catch(err){ 
            console.log('Internal Server Error');
            return res.status(404).json({msg:'Internal Server Error'});
        }

})  
trainer.put()



