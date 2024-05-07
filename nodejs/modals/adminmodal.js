import mongoose from 'mongoose'; 
import jwt from 'jsonwebtoken'; 
// User Basic Details Schema

const User=mongoose.Schema({ 
    first_name:{ 
        type:String, 
        require:true,
    }, 
    last_name:{ 
        type:String, 
        require:true,
    }, 
    email:{ 
        type:String, 
        require:true, 
        unique:true,
    }, 
    user_name:{ 
        type:String, 
        require:true, 
        unique:true,
    }, 
    user_address:{ 
        type:String, 
        require:true,
    },
}); 
const UserSchmea=mongoose.model('User',User);  
export default UserSchmea; 

