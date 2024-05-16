import mongoose from "mongoose";
const Membership=mongoose.Schema({
    plane_type:{
        type:String,
        require:true, 
        
    },  

    plane_price:{ 
        type:Number,
        require:true,
    },
    plan_validity:{ 
        type:Number,
        require:true,
    }, 
    plan_id:{ 
        type:String, 
        require:true,

    }
}) 
const Membershipmodal=mongoose.model("Membership",Membership); 
export default Membership; 
