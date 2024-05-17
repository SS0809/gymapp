import payment  from "../modals/payment.js"; 

const revenuetotal = async (req, res) => {
  try {
    const { year, month } = req.body;
    console.log(req.body);
    
    let pipeline = [];
    
    // Conditionally add the $match stage if year and month are provided
    if (year && month) {
      pipeline.push({
        $match: {
          $expr: {
            $and: [
              { $eq: [{ $year: "$timestamp" }, parseInt(year)] },
              { $eq: [{ $month: "$timestamp" }, parseInt(month)] }
            ]
          }
        }
      });
    }

    // Add the $group stage
    pipeline.push({
      $group: {
        _id: {
          year: { $year: "$timestamp" },
          month: { $month: "$timestamp" }
        },
        total: { $sum: "$billable_amount" }
      }
    });
    
    // Add the $sort stage
    pipeline.push({
      $sort: { "_id.year": 1, "_id.month": 1 }
    });

    // Execute the aggregation
    const pay = await payment.aggregate(pipeline);

    // Map the results to a more user-friendly format
    const result = pay.map(entry => ({
      year: entry._id.year,
      month: entry._id.month,
      total: entry.total
    }));

    // Return the result as a JSON response
    return res.status(200).json(result);
  } catch (err) {
    // Handle any errors that occur during the process
    return res.status(500).json({ msg: 'Internal Server Error in the System' });
  }
};

   
export { revenuetotal };
