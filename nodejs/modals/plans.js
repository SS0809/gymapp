import mongoose from "mongoose";
const Plans=mongoose.Schema({
    plan_type:{
        type:String,
        require:true, 
    },  
    plan_price:{ 
        type:Number,
        require:true,
    },
    plan_validity:{ 
        type:Number,
        require:true,
    },
}) 
const Membershipmodal=mongoose.model("plans",Plans); 
export default Membershipmodal; 
