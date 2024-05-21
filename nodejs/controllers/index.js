import jwt from "jsonwebtoken";
import { MongoClient } from 'mongodb';

import { config as dotenvConfig } from 'dotenv';
dotenvConfig();

const getSuggestions = async (req, res) => {
  const { username } = req.query;
  console.log(username);
  const uri = process.env.DB_URI;
  let mongoClient;
  if (!username) {
      return res.status(400).json({ message: 'Query parameter is required' });
  }

  try {

    mongoClient = new MongoClient(uri);
    await mongoClient.connect();
    const db = mongoClient.db('BLEAN');
    const userModel = db.collection('users');
    const suggestions = await userModel.find({
      username: { $regex: username, $options: 'i' }
    }).limit(10).toArray();
    
      
      res.json(suggestions);
  } catch (err) {
      res.status(500).json({ message: err.message });
  }
};

const getUser = async (username) => {
  const uri = process.env.DB_URI;
  let mongoClient;

  try {
    mongoClient = new MongoClient(uri);
    await mongoClient.connect();
    const db = mongoClient.db('BLEAN');
    const userModel = db.collection('users');
    const user = await userModel.findOne({ username });

    if (!user) {
      throw new Error('User not found');
    }

    return user;
  } catch (error) {
    console.error(error);
    throw new Error('Error getting user');
  } finally {
    if (mongoClient) {
      await mongoClient.close();
    }
  }
}

const updateCount = async (username) => {
  const uri = process.env.DB_URI;
  let mongoClient;

  try {
    mongoClient = new MongoClient(uri);
    await mongoClient.connect();
    const db = mongoClient.db('BLEAN');
    const userModel = db.collection('users');
    const user = await userModel.findOne({ username });

    if (user) {
      const updatedUser = await userModel.updateOne(
        { username },
        { $inc: { count: 1 } }
      );
    } else {
      console.log(`User ${username} not found`);
    }
  } catch (error) {
    console.error(error);
    throw new Error('Error updating count');
  } finally {
    if (mongoClient) {
      await mongoClient.close();
    }
  }
}

const saveUser = async (username, password ,type) => {
  const uri = process.env.DB_URI;
  let mongoClient;

  try {
    mongoClient = new MongoClient(uri);
    await mongoClient.connect();

    const db = mongoClient.db('BLEAN');
    const userModel = db.collection('users');

    const existingUser = await userModel.findOne({ username });

    if (existingUser) {
      throw new Error('Username already exists');
    }

    const user = await userModel.insertOne({ username, password, count: 0 ,type});

    return user;
  } catch (error) {
    console.error(error);
    throw new Error('Error saving user');
  } finally {
    if (mongoClient) {
      await mongoClient.close();
    }
  }
}

 const login = async (req, res) => {
  const { username, password ,type } = req.body;
  const user = await getUser(username);
  console.log({ username, password , type});
  if (user.password !== password) {
    return res.status(403).json({ error: "invalid login" });
  }

  delete user.password;

  if(user.type && user.type == type){ 
  const token = jwt.sign(user, process.env.MY_SECRET, { expiresIn: "1h" });
  res.json({ token: token });
 }
};

 const signup = async (req, res) => {
  const { username, password ,type} = req.body;

  try {
    await saveUser(username, password ,type);
    return res.json("ok");
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error registering user' });
  }
};

 const add = async (req, res, next) => {
  try {
    const user = req.user;
    await updateCount(user.username);
    let count = await getUser(user.username);
    res.json({ count });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error processing request' });
  }
};

 const data = async (req, res, next) => {
  try {
    const user = req.user;
    console.log(user)
    let count = await getUser(user.username);
    res.json({ count });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error processing request' });
  }
};

 const logout = async (req, res) => {
  const token = req.cookies.token;
  res.clearCookie('token');
  return res.redirect('/');
};


export { getSuggestions , login, signup, add, data , logout};