import cloudinary from 'cloudinary';
import fs from 'fs';
cloudinary.v2.config({
  cloud_name: process.env.CLOUD_NAME ,
  api_key: process.env.CLOUD_API_KEY,
  api_secret: process.env.CLOUD_API_SECRET,
  secure: true,
});

const uploaddata = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'No file was uploaded' });
    }
    const result = await cloudinary.v2.uploader.upload(req.file.path, {
      folder: 'data', 
      resource_type: req.file.mimetype.startsWith('image/') ? 'image' : 'video', 
    });
    fs.unlinkSync(req.file.path);

    res.json({
      message: 'File uploaded successfully',
      publicId: result.public_id,
      secureUrl: result.secure_url,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to upload file' });
  }
};

const getAlldata = async (req, res) => {
    try {
      const { resources } = await cloudinary.v2.search
        .expression('folder:data') // Search for all items in the 'data' folder
        .sort_by('public_id', 'desc') // Sort results by public_id in descending order
        .max_results(500) // Max number of results to return (adjust as needed)
        .execute();
  
      res.json(resources);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to retrieve data' });
    }
  };

const deletedata = async (req, res) => {
    try {
      const { publicId } = req.body;
      if (!publicId) {
        return res.status(400).json({ message: 'No publicId was provided' });
      }
  
      await cloudinary.v2.uploader.destroy(publicId);
  
      res.json({ message: 'File deleted successfully' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to delete file' });
    }
  }
export { uploaddata , getAlldata , deletedata};