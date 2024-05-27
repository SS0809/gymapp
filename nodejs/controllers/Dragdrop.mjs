import express from "express";
import multer from "multer";
import joi from "joi";
import mongoose from "mongoose"; 
import usernanme from '../modals/usermodal.js'; 
const adsuser=async(req,res)=>{ 
    const{username}=req; 
    if(!username){
        return res.status(404).json({msg:'error'});
    } 
    else{
        return res.status(201).json({msg:'File uploaded Sucsessfully'});
    }
    if(username){ 
        const datacontent=await username.save(username); //Data saving
    }

}; 
export default adsuser;


