import express from "express"; 
import admindata from '../modals/adminmodal.js';
const router=express.Router(); 
router.get('/admin',async(req,res)=>{ 
    try{ 
        const admindata=await admindata.find(req.query); 
        return res.status(201).json({msg:`Data Fetched Sucessfully`});
    } 
    catch(err){ 
        return res.status(301).json({msg:`Internal Server Error`});
    }
}); 

export default router;
