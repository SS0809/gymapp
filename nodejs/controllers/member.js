 import express from "express";
 import mongoose from "mongoose"; 
import member from '../modals/membermodal.js'; 
const Member=express.Router(); 
Member.get('/members',async(req,res)=>{ // fetch all the member
    const member=await member.find(member.query); 
    if(!member){ 
        return res.status(401).json({msg:'Member Not Found'})
    } 
    else{ 
        return res.status(201).json({member});
    }
});  
Member.get(':/id',async(req,res)=>{ // fetch all the member from Id
    const MemberID=await member.findOne(member.Id); 
    const password=req.body;
    if(!MemberID){ 
        return res.status(201).json({msg:'Member with this Id Not Found'})
    } 
    if(password==member.password){ 
        return res.status(201).json({msg:'Login Sucsessfull'})
    } 
    else{ 
        return res.status(401).json({msg:'Incorrect Password'});
    }
});  
Member.post('/new',async(req,res)=>{// Creatre New Member
    const first_name=req.body.first_name; 
    const last_name=req.body.last_name; 
    const email=req.body.email; 
    const password=req.body.password; 
    const mem_id=req.body.mem_id;

    try{ 
        if(!first_name||!last_name||!email||!mem_id){ 
            return res.status(401).json({msg:'Please fill all the Field Carefully'})
        } 
        const existingemail=member.findOne(email); 
        const existingmem_id=member.findOne(mem_id); 
        if(existingemail||existingmem_id){ 
            return res.status(301).json({msg:'This email and Username already Exist'});
        } 
        else{ 
            const newMember=new member({
                first_name, 
                last_name, 
                email, 
                password,
                mem_id
            }) 
            await newMember.save(); 
           return res.status(201).json({msg:'Form Created Sucesfully'});
        }

    } 
    catch(err){ 
      return   res.status(404).json({msg:'Internal Server Errron '})
    }
}); 
// Update Member 
Member.put('/update',async(req,res)=>{  
    try{
    const first_name=req.body; 
    const last_name=req.body; 
    const email=req.email;  
    member_id=req.mem_id;
    const password=req.password; 
    if(!first_name||!last_name||!email||!password){ 
        return res.status(301).json({msg:'Please fill the all section Carefully'});
    }
    const existmem=await member.findOne({member_id:mem_id}); 
    if(existmem){ 
        existmem.first_name=new first_name; 
        existmem.last_name=new last_name; 
        existmem.email=new email; 
        existmem.password=new password; 
        existmem.mem_id=new mem_id; 
       await existmem.save(); 
        res.status(201).json({msg:'Form Sucsessfully Updated'});

    }
} 
catch(err){ 
    return res.status(301).json({msg:'Internal Server Error'});
}
}) 
export default Member;




