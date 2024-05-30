import User from "../modals/usermodal.js";

const draggeddata = async (req, res) => {
    try {
        const data = req.body.data;
        console.log("Raw Data:", data);

        const parsedData = JSON.parse(data);
        const jsonData = parsedData.map(item => ({
            user: item.user,
            items: JSON.stringify(item.items),
        }));

        console.log("Parsed JSON Data:", jsonData);

        for (const item of jsonData) {
            const { user, items } = item;
            console.log(`Updating user ${user} with items:`, items);

            const result = await User.updateOne(
                { username: user },
                { $set: { dataitems: items } },
                { upsert: true }
            );

            console.log(`Update result for user ${user}:`, result);

            if (result.nModified === 0 && result.upsertedCount === 0) {
                console.log(`No document found or updated for user: ${user}`);
            } else {
                console.log(`Successfully updated/inserted document for user: ${user}`);
            }
        }

        res.status(200).json("ok");
    } catch (error) {
        console.error("Error occurred:", error);
        res.status(500).json({ message: "Server error." });
    }
};

export { draggeddata };

// TODO add edit and delete functionality for specific user

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