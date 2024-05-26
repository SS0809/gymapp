const draggeddata = async (req, res) => {
    const data = req.body;
    const parsedData = JSON.parse(data.data);
    const jsonData = parsedData.map(item => {
        return {
            user: item.user,
            items: JSON.stringify(item.items) 
        };
    });
    console.log(jsonData);
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
    res.status(200).send(jsonData); 
};

export { draggeddata };