import express from "express";
 import mongoose  from "mongoose";
 import Membership from "../modals/membership.js";
 const membership=express.Router(); 
 //Retrive the membership
 membership.get('/memership',async(req,res)=>{ 
    try{ 
        const memberhsip_data=await Membership.find(req.query); 
        return res.status(301).json(membership_data); 
    } 
    catch(err){
        console.log('Internal Error');
        return res.status(404).json({msg:'Internal Server Error in the System'})
    }
 })  
 // Retrive the membership with the Id name; 
 membership.get('/memeberhship/:id',async(req,res)=>{ 
    let  membership_id=req.body;  
    try{
    const isexist=await Membership.findByOne(plan_id=membership_id);  
    if(!isexist){
        return res.status(301).json({msg:'This Plan Does Not Exist,try again'}) 

    } 
    else{ 
        return res.status(201).json(membership_id)
    } 


}
    catch(err){ 
        return res.status(404).json({msg:'Internal Server Error in the System'})
    }



 })  
 // Create a new Membership type(VIP,PREMIMUM,NORMAL); 
 membership.post('/new member',async(req,res)=>{  
    const plan_type=req.body; 
    const plan_price=req.body; 
    const plan_validity=req.body; 
    const plan_id=req.body; 
    if(!plane_type||!plan_price||!plan_validity||!plan_id){
        res.status(301).json({msg:'Please Enter the all data Carefully'});
    }
    try{ 
        const plan_id=await membership.findOne(membership); 
        if(plan_id){  
            return res.status({msg:'This Plan Already Exist'});

        } 
        else{ 
            const newmember=new Membership({
                plan_type,
                plan_price,
                plan_validity,
                plan_id,
            }) 
            await newmember.save(); 
            res.status(401).json({msg:'New Member Created Sucsesfully'}); 


        }

    } 
    catch(err){ 
        return res.status(404).json({msg:'Internal Server Error in the Backend'}); 
    }
 })   
 // Update the Membership Plan 
 membership.put('/update',async(req,res)=>{
    const plan_type=req.body; 
    const plan_id=req.body; 
    const plan_price=req.body; 
    const plan_validity=req.body; 
    if(!plan_type||!plan_id||!plan_price||!plan_validity){
        return res.status(401).json({msg:'Kindly Enter All the Details Carefully'})
    } 
    try{
        const existplan=await Membership.findOne({plan_id:plan_id}); 
        if(existplan){
            existplan.plan_id=new plan_id; 
            existplan.plan_type=new plan_type; 
            existplan.plan_price=new plan_price; 
            existplan.plan_validity=new plan_validity; 
            await existplan.save(); 
            return res.status(201).json({msg:'Plan Updated Sucsessfully'})
        } 
        else{
            return res.status(401).json({msg:'Form cant be updated'});
        }
    
    } 
    catch(err){ 
        return res.status(404).json({msg:'Internl Server Error in the System'})
    }
 })  
 // Delete a Membershi by validation of the Id;  
 membership.delete('/delete/:id',async(req,res)=>{ 
    const id=req.params.body;
    console.log(id); 
    await Membership.findByOneandRemove(id).exec(); 
    return res.status(201).json({msg:'Memeber Sucsessfully Deleted from the Database'})
 });   
 export default membership; 
 




 // To be continue .


