import mongoose from "mongoose";
const CONNECTION=async(DB_URL)=>{
try{ 
    const DB_NAME={ 
        db_name:"BLEAN",
    }; 
    await mongoose.connect(DB_URL,DB_NAME); 
    console.log(`Server Connected to the Database`);
} 
catch(err){ 
    console.log(`Internal Server Eroor`);
} 
}
export default CONNECTION; 



