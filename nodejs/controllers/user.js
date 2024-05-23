import User from '../modals/usermodal.js'; 

const getusers = async(req,res)=>{  
    try{ 
        const user = await User.find({});
        return res.status(200).json(user);
    } 
    catch(err){
        console.log('Internal Error '); 
        return res.status(404).json({msg:'Internal Server Error'})
    }
}; 
const getusers_user = async(req,res)=>{  
    try{ 
        const user = await User.find({type:'USER'});
        return res.status(200).json(user);
    } 
    catch(err){
        console.log('Internal Error '); 
        return res.status(404).json({msg:'Internal Server Error'})
    }
}; 
const getuser = async(req,res)=>{
    const username_incoming = req.user.username;
    try{
    const users = await User.find({ userid: username_incoming });
    return res.status(200).json(users);
    }
    catch(err){
        console.log('Internal Error '); 
        return res.status(404).json({msg:'Internal Server Error'})
    }
}

export {  getuser , getusers_user , getusers };
