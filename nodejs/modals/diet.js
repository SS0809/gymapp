import mongoose from "mongoose"; 
const Diet=mongoose.Schema({
    
    diet_name:{
        type:String, 
        require:true,
    },
    diet_description:{
        type:String, 
        require:true,
    }, 
    diet_plan:{ 
        type:String, 
        require:true,
    },



}); 
const Dietapi=mongoose.model("Diet_plan",Diet); 
export default Diet; 
