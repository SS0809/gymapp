import express from 'express'; 
import AdminSchmea from '../modals/adminmodal.js';
const admin=express.Router(); 
admin.get('/',async(req,res)=>{ 
    try{
        const admin=AdminSchmea.find(req.query);
        return res.status(201).json(`Admin Fetched Sucsessfully`);
    } 
    catch(err){ 
        console.log(`Internal Server Error`); 
        return res.status(201).json({msg:'Admin Not Found'})
    }
});
    admin.get('/:id',async(req,res)=>{  
        try{
        const ID=req.body.Id;  
        if(ID==user_id){ 
            return res.status(201).json({msg:"Admin Sucsessfully Fetched"})
        } 
        else{ 
            return res.status(401).json({msg:'Member with this id Not FOund'})
        }
    } 
    catch(err){ 
        return res.status(err)
    }

    }); 
    
    export default admin;
