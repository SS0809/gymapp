import User from "../modals/usermodal.js";

const draggeddata = async (req, res) => {
    try {
        const data = req.body;
        const parsedData = JSON.parse(data.data);
        const jsonData = parsedData.map(item => ({
            user: item.user,
            items: JSON.stringify(item.items)
        }));
        console.log(jsonData);
        for (const item of jsonData) {
            const { user, items } = item;
            await User.updateOne(
                { username: user }, 
                { $set: { dataitems: items } }, 
                { upsert: true } 
            );
        }
        res.status(200).json("ok");
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error." });
    }
};

export { draggeddata };


    /*
    [
      { user: 'tanu', items: '[{"filename":"mypdf","resource_type":"image"}]' },
      { user: 'anshika', items: '[{"filename":"myname","resource_type":"image"}]' },
      { user: 'nishant', items: '[]' },
      { user: 'tanu', items: '[]' },
      { user: 'tanu', items: '[]' },
      { user: 'anshika', items: '[]' },
      { user: 'nishant', items: '[]' }
    ]
    */