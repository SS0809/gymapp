import express from "express"; 
import bodyParser from "body-parser";   
import predictWeight from "../predection/Weight.js"; 
import calculateActivityLevel from "../predection/Activitiylevel.js"; 
//import Diet from "../predection/Dietpredection.js"; 
import fitnessGoal from "../predection/FitnessGoal.js";

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
const Activitiylevel=app.post('/activity-level',(req,res)=>{  
    const {userData}=req.body;
    if(!age||!height||!weight||!height||!workoutsPerWeek||!averageWorkoutDuration){
        return res.status(401).json({msg:'Fill all the Field Sucsessfully'}); 

    } 
    else{ 
        const level= calculateActivityLevel(userData); 
        return res.status(201).json({level});
    }

}); 
const DietPlan=app.post('/diet',async(req,res)=>{ 
    const{userData}=req.body; 
    if(!age||!weight||!height||!Activitiylevel||!DietRestriction){
        return res.status(401).json({msg:'Fill all the Field'});
    } 
    else{ 
        const Dietpref=recommandDiet(userData); 
        return res.status(201).json({Dietpref});
    }
});   
const FitnessGoal=app.post('/fitness',async(req,res)=>{ 
    const{userData}=req.body; 
    if(!age||!weight||!height){ 
        return res.status(401).json({msg:'Kindly Fill all the Fields'});
    } 
    else{ 
        const Goal=fitnessGoal(userData); 
        return res.status(201).json(Goal);
    }
}); 
export {Age,Weight,Activitiylevel,DietPlan,FitnessGoal};







