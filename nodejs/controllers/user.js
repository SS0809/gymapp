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

const createuser = async (req, res) => {
    const { username, password } = req.body;
    console.log({username,password})
    if (!username || !password ) {
        return res.status(400).json({ msg: 'Please provide all required fields' });
    }
    try {
        const existingUser = await User.find({ username: username});
        if (!existingUser) {
            return res.status(201).json({ msg: 'User already exists' });
        }
        const newUser = new User({
            username,
            password,
            type:'USER',
        });
        await newUser.save();
        return res.status(200).json(newUser);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
};

const updateuser =  async (req, res) => {

        return res.status(200).json(plan);
};

const deleteuser =  async (req, res) => {   
    const  { username }  = req.body;
    try {
        const user = await User.deleteOne({username:username});
        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }
        return res.status(200).json({ msg: 'User successfully deleted' });
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
};

export {  getuser , getusers_user , getusers , createuser , updateuser , deleteuser };
