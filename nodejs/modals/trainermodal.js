import mongoose from "mongoose"; 
const Trainer=mongoose.Schema({ 
    
    train_first_name:{ 
        type:String, 
        require:true,
    },
    train_last_name:{ 
        type:String, 
        require:true,
    },
    train_id:{ 
        type:String, 
        lowercase:true, 
        unique:true,
    }, 
    fee:{ 
        type:Number, 
        require:true,
    }
}) 
const TrainerModel=mongoose.model("Trainer",Trainer);
export default TrainerModel; 
