import express from "express"; 
import Search from '../modals/Search.modal.js'; 
const Searchname=async(req,res)=>{ 
    try{ 
        const name=req.body.name; 
        if(!name){ 
            return res.status(401).json({msg:'Kindly Fill all the Details Carefully'});
        } 
        else{ 
            const existingname=await Search.find({name:name})
                if(existingname)
                    return res.status(201).json({name:name,role:name.role})// will return the username and it role i.e user or ADMIN;
                
                else
                    return res.status(301).json({msg:'Name not Found in the Database'})
                

        
        }
    }
    catch(err){
        return res.status(404).json({msg:'Internal Server Error in the System'})
    }
} 
export default Searchname; 
