import Payment from '../modals/payment.schema.js'; 
const createpayment = async(req,res)=>{  
    try{
    const { billable_amount,
        month,
        plan,
        userid}=req.body; 
    const newpayment=new Payment({ 
        billable_amount,
        month,
        plan,
        userid
    }); 
    await newpayment.save(); 
    return res.status(201).json({msg:'Payment Created Sucessfully'}); 
}
    catch(err){
        return res.status(404).json({msg:'Internal Server Errror'});
    }
}; 
const getpayments = async(req,res)=>{  
    try{ 
        const pay = await Payment.find({});
        return res.status(200).json(pay);
    } 
    catch(err){
        console.log('Internal Error '); 
        return res.status(404).json({msg:'Internal Server Error'})
    }
}; 


export { createpayment , getpayments };
