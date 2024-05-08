import mongoose from "mongoose"; 
import jwt from "jsonwebtoken"; 
const Member=mongoose.Schema({ 
        mem_first_name:{ 
            type:String, 
            require:true,
        },
        mem_last_name:{ 
            type:String, 
            require:true,
        },
        mem_id:{ 
            type:String, 
            lowercase:true, 
            unique:true,
        }, 
        mem_emai:{ 
            type:String, 
            lowercase:true,
            unique:true,
        },
}); 
const MemberSchema=mongoose.model("Member",Member); 
export default MemberSchema; 
