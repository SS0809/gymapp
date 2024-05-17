import  mongoose from "mongoose"; 
const PaymentSchmea=mongoose.Schema({ 
    admin_id:{ 
        type:String, 
        require:true,
    }, 
    admin_password:{ 
        type:String, 
        require:true,
    }, 
    amount:{ 
        type:Number,
        require:true,
    }, 
    month:{ 
        type:String, 
        require:true,
    },
}); 
const Revenue=mongoose.model("Revenue",PaymentSchmea);  
export default Revenue; 
