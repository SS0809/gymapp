import mongoose from "mongoose";

const CONNECTION=async(DB_URL)=>{
try{ 
    await mongoose.connect(DB_URL); 
    console.log(`Server Connected to the Database`);
} 
catch(err){ 
    console.log(`Internal Server Eroor`);
} 
}
export default CONNECTION; 



