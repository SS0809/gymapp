import mongoose, { mongo } from "mongoose"; 
const datacontent=mongoose.Schema({ 
    user_name:{ 
        type:String,
        require:true,
    },
    password:{ 
        type:String, 
        require:true,
    }, 
    diet:{ 
        type:String, 
        require:true,
    },
}); 
const datamodel=mongoose.model("Datacontent",datacontent); 
export default datamodel;