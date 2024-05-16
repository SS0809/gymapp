import mongoose from "mongoose";

// Define the Payment schema
const PaymentSchema = mongoose.Schema({  
    userid: { 
        type: String, 
        required: true,
    },
    plan: { 
        type: String, 
        required: true,
    },
    month: { 
        type: String, 
        required: true,
    },
    billable_amount: { 
        type: Number, 
        required: true, 
    }
}); 

// Create a model based on the Payment schema
const PaymentAPI = mongoose.model("payments", PaymentSchema); 

// Export the Payment model
export default PaymentAPI; 
