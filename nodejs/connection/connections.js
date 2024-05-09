import mongoose from 'mongoose';
const CONNECTION=async(URL)=>{
try{ 
    const DB_NAME={ 
        dbname:"BLEAN",
    }; 
    await mongoose.connect(URL,DB_NAME); 
    console.log(`Server Connected to the Database`);
} 
catch(err){ 
    console.log('Internal Server Error');
} 
};
export default CONNECTION; 



