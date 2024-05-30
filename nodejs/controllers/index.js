import jwt from 'jsonwebtoken';

import User from '../modals/usermodal.js';

const getSuggestions = async (req, res) => {
  const { username } = req.query;
  if (!username) {
    return res.status(400).json({ message: 'Query parameter is required' });
  }

  try {
    const suggestions = await User.find({
      username: { $regex: username, $options: 'i' }
    }).limit(10).exec();
    res.json(suggestions);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getUser = async (username) => {
  try {
    const user = await User.findOne({ username }).exec();
    if (!user) {
      throw new Error('User not found');
    }
    return user;
  } catch (error) {
    console.error(error);
    throw new Error('Error getting user');
  }
};

const updateCount = async (username) => {
  try {
    const user = await User.findOneAndUpdate(
      { username },
      { $inc: { count: 1 } },
      { new: true }
    ).exec();
    if (!user) {
      console.log(`User ${username} not found`);
    }
  } catch (error) {
    console.error(error);
    throw new Error('Error updating count');
  }
};

const saveUser = async (username, password, type) => {
  try {
    const existingUser = await User.findOne({ username }).exec();
    if (existingUser) {
      throw new Error('Username already exists');
    }
    const user = new User({ username, password, type });
    await user.save();
    return user;
  } catch (error) {
    console.error(error);
    throw new Error('Error saving user');
  }
};

const login = async (req, res) => {
  const { username, password, type } = req.body;
  try {
    const user = await getUser(username);
    if (user.password !== password) {
      return res.status(403).json({ error: "invalid login" });
    }
    delete user.password;

    if (user.type === type) {
      const token = jwt.sign(user.toObject(), process.env.MY_SECRET, { expiresIn: "1h" });
      res.json({ token });
    } else {
      res.status(403).json({ error: "invalid type" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const signup = async (req, res) => {
  const { username, password, type } = req.body;
  try {
    await saveUser(username, password, type);
    return res.json("ok");
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error registering user' });
  }
};

const add = async (req, res) => {
  try {
    const user = req.user;
    await updateCount(user.username);
    let updatedUser = await getUser(user.username);
    res.json({ count: updatedUser.count });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error processing request' });
  }
};

const data = async (req, res) => {
  try {
    const user = req.user;
    let userData = await getUser(user.username);
    res.json({ count: userData.count });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error processing request' });
  }
};

const logout = (req, res) => {
  res.clearCookie('token');
  return res.redirect('/');
};

export { getSuggestions, login, signup, add, data, logout };
