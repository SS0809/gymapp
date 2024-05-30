import express from "express"; 
import bodyParser from "body-parser";   
import predictWeight from "../predection/Weight";
const app=express();
const Age=async(req,res)=>{ 
    function predictage(features){ 
        const age=Math.floor(Math.random()*(65-18+1))+18; 
        return age;
    }  
    app.post('/predict-age',(req,res)=>{
        const features=req.body; 
        if(!features){
            return res.status(401).json({msg:'No features Provided'});
        } 
        else{ 
            return res.status(201).json({msg:'Predicted age:', age})
        }
    })
    
}; 
const Weight=app.post('/weight',async(req,res)=>{ 
    const{height,age}=req.body; 
    if(!height||!age){
        return res.status(401).json({msg:'Kindly Enter all the Fields'});
    } 
    else{ 
        const predictedWeight=predictWeight(height,age); 
        return res.status(201).json({predictedWeight});
    }

}); 
const Gender=app.post('/Gender',async(req,res)=>{ 
     const predictGender=Math.random()?'male':'feamle'; 
     const error='This may be not be accurate'; 
     return res.status(201).json({'Gender':predictGender});
}); 


