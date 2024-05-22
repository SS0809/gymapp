import mongoose from "mongoose"; 
const SearchApi=mongoose.Schema({
    name:{
        type:String, 
        required:true,

    },  
    password:{ 
        type:String, 
        required:true,
    },
    role:{ 
        type:String, 
        required:true,
    }, 
    plan:{ 
        type:String, 
        required:true,
    }, 



}); 
const Search=mongoose.model("SEARCH",SearchApi); 
export default Search; 
