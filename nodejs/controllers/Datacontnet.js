import express, { response } from "express"; 
import mongoose from "mongoose"; 
import datamodel from "../modals/dataconmode.js";
import Diet from "../modals/diet.js";
const isuser=async(req,res)=>{
    const existinguser=req.body.user_name;
    
    try{ 
        const isuseravilable=await datamodel.findbyId(existinguser==user_name); 
        if(!isuseravilable){
            return res.status(301).json({msg:'User not avilable'});
        } 
        const password=req.body.password;
        const validatepassword=await datamodel.findOne(password==password); 
        if(!isuseravilable||!validatepassword){
            return res.status(401).json({msg:'Wrong Credentials'});
        } 
        else{ 
            return res.status(201).json({name:existinguser});  
            return res.status(201).json({diet:diet})

        }
        
    } 
    catch(err){
        console.log('Internal Error'); 
        return res.status(404).json({msg:'Internal Server Error in the Backend'})
    }
};