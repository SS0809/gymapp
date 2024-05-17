import payment  from "../modals/payment.js"; 

const revenuetotal = async (req, res) => {
    try {
      const month = req.body.month ?? "";
      const year = req.body.year ?? "";
      const pay = await payment.aggregate([
        {
          $group: {
            _id: {
              year: { $year: "$timestamp" },
              month: { $month: "$timestamp" }
            },
            total: { $sum: "$billable_amount" }
          }
        },
        {
          $sort: { "_id.year": 1, "_id.month": 1 }
        }
      ]);
  
      // Map the results to a more readable format if needed
      const result = pay.map(entry => ({
        year: entry._id.year,
        month: entry._id.month,
        total: entry.total
      }));
  
      return res.status(200).json(result);
    } catch (err) {
      return res.status(500).json({ msg: 'Internal Server Error in the System' });
    }
  };
   
export { revenuetotal };
