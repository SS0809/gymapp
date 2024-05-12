import epxress from "express"; 
import mongoose from "mongoose";
import diet from '../modals/diet.cont.js' 
const Diet=epxress.Router();  
// Get Diet Plans
Diet.get('/diet',async(req,res)=>{
    try{
        const dietPlan=await diet.find();
        return res.status(201).json(dietPlan);
    } 
    catch(err){ 
        console.log('Internal Server Error in the System');
        return res.status(404).json('Internal Server Error')
    }
});  
//POST A new Diet Plan 
Diet.post('/diet-plan',authorize,async(req,res)=>{ 
    try{
    if(!req.isAdmin){
        return res.status(401).json({msg:'Forbidden'});
    } 
    else{ 
        const dietPlan=new dietPlan({
           diet_name:req.body.name,  
           description:req.body.description, 
           calories:req.body.calories,

        }); 
        const newDietplan=await dietPlan.save(); 
        return res.status(201).json({msg:'Diet Sucsessfully Created'},newDietplan); 

    }
} 
catch(err){
    return res.status(404).json({msg:'Internal Server Error in the System'})
}
});  
// Update a Existing Diet id;  
Diet.put('/diet-update/:id',authorize,async(req,res)=>{ 
    try{
    if(!req.isAdmin){
        return res.status(401).json({msg:'Forbidden'});
    } 
    else{ 
        const dietplan_name=req.body.diet_name;  
        const existingdiet_name=await diet.findOne({dietplan_name:diet_name});
        if(!existingdiet_name){
            return res.status(400).json({msg:'Diet_name not exist'});
        } 
        else{ 
            dietplan_name.diet_name=new diet_name,  
            dietplan_name.diet_description=new diet_description; 
            dietplan_name.calories=new calories;  
            await existingdiet_name.save(); 
            return res.status(201).json({msg:'Diet Sucsessfully Updated'});


        }
        

    }
} 
catch(err){
    return res.status(404).json({msg:'Caught Internal Server Error in the Backend'});
}
}); 
Diet.delete('/deletedoner/:id',authorize,async(req,res)=>{  
    try{
    if(!req.isAdmin){
        return res.status(401).json({msg:'Forbiden'});
    } 
    else{ 
        const id=req.body.diet_name; 
        await diet.findByidandRemove(id).exec(); 
        return res.status(201).json({msg:'Data Deleted Sucsessfully'});
    }
} 
catch(err){
    return res.status(404).json({msg:'Internal Server Error in the Backend'});
}

}) 
export default Diet; 



   


 

