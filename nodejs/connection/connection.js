import mongoose from "mongoose";

const connectToDatabase = async (DB_URL) => {
    try {
        await mongoose.connect(DB_URL);
    } catch (err) {
        console.error('Connection to the database failed:', err);
        throw err; // Re-throw the error to propagate it
    }
};

mongoose.connection.on('connected', () => {
    console.log('Connected to MongoDB');
});

mongoose.connection.on('error', (err) => {
    console.error('MongoDB connection error:', err);
});

mongoose.connection.on('disconnected', () => {
    console.log('Disconnected from MongoDB');
});

export default connectToDatabase;
