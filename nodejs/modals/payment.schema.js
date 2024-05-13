import mongoose from "mongoose"; 
const Payment=mongoose.Schema({  
    user_id:{ 
        type:String, 
        require:true,
    },
    amount:{ 
        type:Number, 
        require:true, 
        
    },
    desc:{ 
        type:String, 
        require:true, 

    },
}); 
const PaymentAPI=mongoose.connect("Payment",Payment); 
export default PaymentAPI; 

