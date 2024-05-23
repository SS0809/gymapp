import mongoose from "mongoose"; 
const Users=mongoose.Schema({ 
        username:{ 
            type:String, 
            required: true,
        },
        type:{ 
            type:String, 
            required: true,
        },
        password:{ 
            type:String, 
            required: true,
        }, 
}); 
const User=mongoose.model("users",Users); 
export default User; 
