import mongoose from "mongoose"; 
const Notice=mongoose.Schema({ 
    title:{ 
        type:String, 
        require:true,
    }, 
    content:{ 
        type:String, 
        require:true,
    }, 
    category:{ 
        type:String, 
        require:true,
    },
}); 
const Noticedata=mongoose.model("Noticedata",Notice); 
export default Noticedata; 
