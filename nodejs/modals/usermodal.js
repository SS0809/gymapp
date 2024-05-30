import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
    },
    type: {
        type: String,
        required: true,
    },
    password: {
        type: String,
        required: true,
    },
    dataitems: {
        type: String,
    },
    items: {
        type: String,
    },
});

const User = mongoose.model("User", userSchema);
export default User;
